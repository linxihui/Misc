#include <cmath>
#include <bits/stdc++.h>
#include <armadillo>

using namespace std;

template <typename T>
int merge_sort(vector<T> & x, int start, int end)
{
	if (start == end) return 1;
	int n = end - start + 1;
	int n1 = (n % 2 == 0? n/2 : (n-1)/2);
	merge_sort(x, start, start + n1-1);
	merge_sort(x, start + n1, end);

	vector<T> x2(n);
	for (int ii = 0; ii < n; ii ++)
		x2[ii] = x[start+ii];
	
	int i = 0, j = n1;
	typename vector<T>::iterator k = x.begin()+start;

	while(i < n1 && j < n)
	{
		if (x2[i] <= x2[j])
		{
			*k = x2[i];
			i++; k++;
		}
		else
		{
			*k = x2[j];
			j++; k++;
		}
	}

	for (; i < n1; i++, k++) *k = x2[i];
	for (; j < n; j++, k++) *k = x2[j];

	return 1;
}


int main() 
{
	int n = 10000000;
	arma::vec x0 = arma::randu<arma::vec>(n);
	vector<double> x(x0.begin(), x0.end());

	merge_sort(x, 0, n-1);

	bool sorted = true;
	for (int i = 1; i < n; i++)
	{
		sorted = (x[i] - x[i-1] >= 0)  && sorted;
	}

	if (sorted)
		cout << "sorted!" << endl;
	else
		cout << "not sorted!" << endl;
	return 1;
}
