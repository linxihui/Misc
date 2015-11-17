#include <bits/stdc++.h>
#include <armadillo>

using namespace std;

template <typename T>
void quicksort(vector<T> & x, int lo, int hi)
{
	if (lo < hi)
	{
		// T pivot = x[hi]; // fixed pivot
		// random pivot
		T pivot = x[rand() % (hi - lo) + lo];
		// i: cell to be compared
		// j: empty cell
		int i = lo, j = hi, tmp;
		while (i != j)
		{
			if ((i < j) == (x[i] > pivot))
			{
				x[j] = x[i];
				tmp = j;
				j = i;
				i = tmp;
			}
			(i < j)? i++ : i--;
		}
		x[j] = pivot;
		quicksort(x, lo, j-1);
		quicksort(x, j+1, hi);
	}
}

template <typename T>
void quicksort(vector<T> & x)
{
	quicksort(x, 0, x.size()-1);
}


int main(int argc, char* argv[]) 
{
	int n = 10;
	if (argc >= 2) n = atoi(argv[1]);
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
