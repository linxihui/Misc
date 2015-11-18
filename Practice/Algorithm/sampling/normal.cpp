#include <bits/stdc++.h>
#include <omp.h>

using namespace std;

//[[Rcpp::export]]
vector<double> rand_std_norm(int n)
{
	// generate standard normal distribution using Box-Muller transform
	// if u1, u2 ~ unif(0,1) independently, then 
	// r1 = sqrt(-2*log(u1))*cos(2*M_PI*u2)
	// r2 = sqrt(-2*log(u1))*sin(2*M_PI*u2)
	// are independent standardard normal sample
	vector<double> out(n);
	register double u1, u2, a, b;
	vector<double>::iterator p = out.begin();

	// seeding problem?
	// cannot use OMP when using iterator p. Switch to index access if parallel required
	//#pragma omp parallel for private(u1, u2, a, b)
	for (int j = 0; j < n/2; j++)
	{
		u1 = double(rand()) / RAND_MAX;
		u2 = double(rand()) / RAND_MAX;
		a = ::sqrt(-2*::log(u1));
		b = ::cos(2*M_PI*u2);
		*p++ = a*b;
		*p++ = (u2 > 0.5) ? a*::sqrt(1.-b*b) : -a*::sqrt(1.-b*b);
	}

	if ( n % 2 == 1)
	{
		u1 = double(rand()) / RAND_MAX;
		u2 = double(rand()) / RAND_MAX;
		*p = ::sqrt(-2*::log(u1)) * ::cos(2*M_PI*u2);
	}

	return out;
}
/*
int main() {

	int n = 20;
	vector<double> x(n);

	x = rand_std_norm(n);

	for (vector<double>::iterator p = x.begin(); p < x.end(); p++)
	{
		cout << *p << endl;
	}
	return 0;
}
*/
