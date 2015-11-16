#include <cmath>
#include <bits/stdc++.h>
#include <armadillo>

using namespace std;

template <typename T>
void quicksort(vector<T> & A, int lo, int hi)
{
	if(lo < hi)
	{
		T cur = A[hi];
		// i: cell to be compared
		// j: empty cell
		int i = lo, j = hi, tmp;
		while (i != j)
		{
			if ((i < j) == (A[i] > cur))
			{
				A[j] = A[i];
				tmp = j;
				j = i;
				i = tmp;
			}
			(i < j)? i++ : i--;
		}
		A[j] = cur;
		quicksort(A, lo, j-1);
		quicksort(A, j+1, hi);
	}
}

template <typename T>
void quicksort(vector<T> & A)
{
	quicksort(A, 0, A.size()-1);
}


int main(int argc, char* argv[]) 
{
	int n = 10;
	if (argc >= 2) 
		n = atoi(argv[1]);
	cout << "n = " << n << endl;
	arma::vec x0 = arma::randn<arma::vec>(n);
	vector<double> x(x0.begin(), x0.end());

	quicksort(x);

	bool sorted = true;
	for (int i = 1; i < n && sorted; i++)
	{
		sorted = (x[i] - x[i-1] >= 0);
	}

	if (sorted)
		cout << "sorted!" << endl;
	else
		cout << "not sorted!" << endl;
	return 0;
}
