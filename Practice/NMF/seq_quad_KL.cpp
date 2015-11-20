#include <bits/stdc++.h>
#include <omp.h>

//[[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

using namespace arma;

//[[Rcpp::export]]
mat sqKL(mat A, mat b, double L2 = 0, double L1 = 0, int max_iter = 10000, double rel_tol = 1e-8)
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

	mat x(A.n_cols, b.n_cols, fill::randu);
	
	//pragma omp parallel for
	for (int j = 0; j < b.n_cols; j++)
	{
		vec x0;
		vec b0 = A*x.col(j);
		double alpha, beta;
		double err = 9999, err0;
		double rel_err = rel_tol + 1;
		double tmp;

		for (int t = 0; t < max_iter && rel_err > rel_tol; t++)
		{
			x0 = x.col(j);
			err0 = err;
			for (int k = 0; k < A.n_cols; k++)
			{
				alpha = L2 + sum((b.col(j)/b0) % square(A.col(k)));
				beta = L1 + sum(A.col(k) % (1 - b.col(j)/b0));
				tmp = x(k,j);
				x(k,j) -= beta / (2*alpha); 
				if (x(k,j) < 0) x(k,j) = 0;
				b0 += (x(k,j) - tmp) * A.col(k);
			}
			//err = sum(b0 - b.col(j) % trunc_log(b0));
			err = max(abs(x.col(j) - x0));
			rel_err = std::abs(err - err0)/(err0 + 1e-9);
		}
	}

	return x;
}
