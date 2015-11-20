#include <bits/stdc++.h>
//[[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

using namespace arma;

//[[Rcpp::export]]
vec sqKL(mat A, mat b, double eta = 0, int max_iter = 10000, double rel_tol = 1e-8)
{
	// solve Non-negative linear equation by minimizing KL-divergence distance, i.e.,
	// 		argmin_{x>=0} sum(Ax - b log(Ax)) + eta/2 ||x||_F^2
	// Agorithm:
	// 	 Sequentially update each entry of x by approximating the KL-divergence distance with
	// 	 a quadratic function, which can be solved explicitely. This is equivalent to sequential
	// 	 1-step Newton-Raphson algorithm. This should be better than 
	// 	 diagnosed (rank 1) quasi-Newton methods.
	vec x(A.n_cols, fill::randu);
	vec x0;
	vec b0 = A*x;
	double alpha, beta;
	double err = 9999, err0;
	double rel_err = rel_tol + 1;
	double tmp;
	
	for (int t = 0; t < max_iter && rel_err > rel_tol; t++)
	{
		x0 = x;
		err0 = err;
		for (int k = 0; k < A.n_cols; k++)
		{
			alpha = eta + sum((b/b0) % square(A.col(k)));
			beta = sum(A.col(k) % (1 - b/b0));
			tmp = x(k);
			x(k) -= beta / (2*alpha); 
			if (x(k) < 0) x(k) = 0;
			b0 += (x(k) - tmp) * A.col(k);
		}
		//err = sum(b0 - b % trunc_log(b0));
		err = max(abs(x - x0));
		rel_err = std::abs(err - err0)/(err0 + 1e-9);
	}

	return x;
}
