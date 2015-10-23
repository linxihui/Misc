//[[Rcpp::depends(RcppArmadillo)]]
#include <bits/stdc++.h>
#include <RcppArmadillo.h>

using namespace std;
using namespace arma;

//[[Rcpp::export]]
Rcpp::List nmfcpp(mat V, int k, int max_iter = 100, double tol = 1e-4)
{
	mat W = randu(V.n_rows, k), H = randu(k, V.n_cols);
	mat wtemp(W), htemp(H);
	mat Vbar = W*H;
	vec err(max_iter);
	err.fill(-1);

	int i = 0;
	for(; i < max_iter; i++)
	{
		wtemp.each_row() /= sum(wtemp, 0);
		htemp.each_col() /= sum(htemp, 1);
		H = wtemp.t() * (V / (Vbar)) % H;
		W = (V / Vbar) * htemp.t() % W;
		Vbar = W*H;
		wtemp = W;
		htemp = H;
		err.at(i) =  sqrt(mean(mean(square(V - Vbar), 1)));
		if (i > 0 && abs(err.at(i) - err.at(i-1)) < tol)
		{
			cout << "Algorithm converges after " << ++i << " steps" << endl;
			err.resize(i);
			break;
		}
	}

	if (i == max_iter)
		cout << "Algorithm not convergenet." << endl;

	return Rcpp::List::create(
		Rcpp::Named("W") = W,
		Rcpp::Named("H") = H,
		Rcpp::Named("error") = err,
		Rcpp::Named("iteration") = i
		);
}




//[[Rcpp::export]]
Rcpp::List nmf2(mat V, int k, int max_iter = 100, double tol = 1e-4)
{
	mat W = randu(V.n_rows, k), H = randu(k, V.n_cols);
	mat Vbar;
	rowvec w;
	colvec h;
	vec err(max_iter);
	err.fill(-1);

	int i = 0;
	for(; i < max_iter; i++)
	{
		w = sum(W);
		h = sum(H, 1);
		for (int a = 0; a < k; a++)
		{
			H.row(a) %= W.col(a).t() * (V / (W*H)) / w.at(a);
			W.col(a) %= (V / (W*H)) * H.row(a).t() / h.at(a);
		}
		Vbar = W*H;
		err.at(i) =  sqrt(mean(mean(square(V - Vbar), 1)));
		if (i > 0 && abs(err.at(i) - err.at(i-1)) < tol)
		{
			cout << "Algorithm converges after " << ++i << " steps" << endl;
			err.resize(i);
			break;
		}
	}

	if (i == max_iter)
		cout << "Algorithm does not converge." << endl;

	return Rcpp::List::create(
		Rcpp::Named("W") = W,
		Rcpp::Named("H") = H,
		Rcpp::Named("error") = err,
		Rcpp::Named("iteration") = i
		);
}
