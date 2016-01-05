#include <bits/stdc++.h>
#include <omp.h>

//[[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

#define ARMA_NO_DEBUG

using namespace arma;

//[[Rcpp::export]]
mat sqKL(const mat & A, const mat & b, double L2 = 0, double L1 = 0, int max_iter = 10000, double rel_tol = 1e-8)
{
	/*
	 * Solve Non-negative linear equation by minimizing KL-divergence distance, i.e.,
	 * 		argmin_{x>=0} sum(Ax - b log(Ax)) + L2/2 ||x||_F^2 + L1 ||x||1
	 * Agorithm:
	 * 	 Sequentially update each entry of x by approximating the KL-divergence distance with
	 * 	 a quadratic function, which can be solved explicitely. This is equivalent to sequential
	 * 	 1-step Newton-Raphson algorithm. This should be better than 
	 * 	 diagnosed (rank 1) quasi-Newton methods.
	 */

	double n = A.n_rows;
	mat x(A.n_cols, b.n_cols);
	x = solve(A, b);
	x.elem(find(x < 0)).fill(0);
	
	vec sA = conv_to<vec>::from(mean(A));

	//pragma omp parallel for
	for (int j = 0; j < b.n_cols; j++)
	{
		vec x0;
		vec b0 = A*x.col(j);
		mat mu = A.each_col() % b.col(j);
		vec mu2(mu.n_rows);
		double alpha, beta;
		double err = 9999, err0;
		double rel_err = rel_tol + 1;
		double tmp;

		int t = 0; 
		for (;t < max_iter && rel_err > rel_tol; t++)
		{
			if (t*A.n_cols % 1000 == 0)
				Rcpp::checkUserInterrupt();

			x0 = x.col(j);
			err0 = err;
			for (int k = 0; k < A.n_cols; k++)
			{
				mu2 = mu.col(k) / (b0+1e-15);
				alpha = L2 + dot(A.col(k), mu2)/n; // sum((b.col(j)/(b0+1e-15)) % square(A.col(k)));
				beta = L1 + (sA(k) - mean(mu2)); //sum(A.col(k) % (1 - b.col(j)/(b0+1e-15)));
				tmp = x(k,j);
				x(k,j) -= beta / (2*alpha); 
				if (x(k,j) < 0) x(k,j) = 0;
				b0 += (x(k,j) - tmp) * A.col(k);
			}
			//err = sum(b0 - b.col(j) % trunc_log(b0));
			err = max(abs(x.col(j) - x0));
			rel_err = std::abs(err - err0)/(err0 + 1e-9);
		}
		std::cout << t << std::endl;
	}

	return x;
}
