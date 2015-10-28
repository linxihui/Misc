//[[Rcpp::depends(RcppArmadillo)]]
#include <bits/stdc++.h>
#include <RcppArmadillo.h>

using namespace std;
using namespace arma;

//vec nnls_col(mat A, colvec b, int max_iter = 500, double tol = 1e-6)
vec nnls_col(const mat &A, const subview_col<double> &b, int max_iter = 500, double tol = 1e-6, bool verbose = false)
{
	/*
	 * Description: sequential Coordinate-wise algorithm for non-negative least square regression A x = b, s.t. x >= 0
	 * 	Reference: http://cmp.felk.cvut.cz/ftp/articles/franc/Franc-TR-2005-06.pdf 
	 */

	vec mu = -A.t() * b;
	mat H = A.t() * A;
	vec x(A.n_cols), x0(A.n_cols);
	x.fill(0);
	x0.fill(-9999);

	int i = 0;
	double tmp;
	while(i < max_iter && max(abs(x - x0)) > tol) 
	{
		x0 = x;
		for (int k = 0; k < A.n_cols; k++) 
		{
			tmp = x[k] - mu[k] / H.at(k,k);
			if (tmp < 0) tmp = 0;
			if (tmp != x[k]) mu += (tmp - x[k]) * H.col(k);
			x[k] = tmp;
		}
		++i;
	}
	
	return x;
}


//[[Rcpp::export]]
mat nnls(mat A, mat b, int max_iter = 500, double tol = 1e-6)
{
	// solving Ax = b, where x and b are both matrices
	if(A.n_rows != b.n_rows)
		throw std::invalid_argument("A and b must have the same number of rows.");
	mat x(A.n_cols, b.n_cols);
	for (int i = 0; i < b.n_cols; i++)
		x.col(i) = nnls_col(A, b.col(i), max_iter, tol);

	return x;
}


//[[Rcpp::export]]
Rcpp::List nmf_nnls(mat A, int k = 1, double max_iter = 100, double tol = 1e-6, bool verbose = false)
{
	// A = WH
	mat W(A.n_rows, k, fill::randu);
	mat H(k, A.n_cols);
	W *= mean(mean(A)) / k;
	vec err(max_iter);
	err.fill(-9999);

	int i = 0;
	for(; i < max_iter; i++)
	{
		H = nnls(W, A, 500*(1+i), tol/(1+i));
		W = nnls(H.t(), A.t(), 500*(1+i), tol/(1+i)).t();
		err[i] = sqrt(mean(mean(square(A - W*H))));
	 	if (i > 0 && abs(err[i-1] - err[i]) < tol)
			break;
	}

	if (verbose && max_iter <= i)
	{
		Rcpp::Function warning("warning");
		warning("Algorithm does not converge.");
	}

	err.resize(i < max_iter ? i+1 : max_iter);

	return Rcpp::List::create(
		Rcpp::Named("W") = W, 
		Rcpp::Named("H") = H, 
		Rcpp::Named("error") = err
		);
}
