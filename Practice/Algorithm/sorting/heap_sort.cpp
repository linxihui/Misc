#include <bits/stdc++.h>
#include <armadillo>

using namespace std;

template <typename T>
void print_tree(vector<T> &x)
{
	// print an array represented complete binary tree
	int i = 0;
	while(i < x.size())
	{
		for (int j = i; j <= 2*i && j < x.size(); j++)
			cout << x[j] << "\t";
		cout << endl;
		i = 2*i + 1;
	}
}

template <typename T>
void moveup(vector<T> & x, int k)
{
	//move large element up on the tree, while constructing a max heap
	// k: current node index
	if (k == 0) return;
	int p = (k - 1) / 2; // parent of k
	T tmp;
	while (k > 0 && x[p] < x[k])
	{
		tmp = x[p];
		x[p] = x[k];
		x[k] = tmp;
		k = p;
		p = (k - 1) / 2; // if k = 0, p = 0, integer divid;
	}
}

template <typename T>
void build_max_heap(vector<T> &x)
{
	//construct a max heap
	for (int k = 0; k < x.size(); k++)
		moveup(x, k);
}

template <typename T>
void movedown(vector<T> & x, int e)
{
	/* after swapping root node with last element
	 * and removing the last node from the tree,
	 * the tree is not longer a heap, thus 
	 * move the root node down if it is smaller than 
	 * its children to re-construct a max heap
	 */
	// e: last node index in the current heap
	if (e == 0) return;
	int p = 0; // current node
	int f = 0; // largest of p and its children
	int l = 2*p + 1; // left child of p
	T tmp;
	while (l <= e)
	{
		if (x[l] > x[f])
			f = l;
		if (++l <= e && x[l] > x[f]) // right child
			f = l;
		if (f == p) break;
		tmp = x[f];
		x[f] = x[p];
		x[p] = tmp;
		p = f;
		l = 2*p+1;
	}
}

template <typename T>
void heapsort(vector<T> & x)
{
	// build a heap
	build_max_heap(x);

	int e = x.size() - 1; //end of unsorted
	T tmp;
	// movedown in sorting
	while(e > 0)
	{
		// move biggest, root, to x[e]
		tmp = x[e];
		x[e] = x[0];
		x[0] = tmp;
		// move root node down to form a max heap
		movedown(x, --e);
	}
}

// test
int main(int argc, char* argv[]) 
{
	int n = 10;
	if (argc >= 2) n = atoi(argv[1]);
	cout << "n = " << n << endl;
	arma::vec x0 = arma::randu<arma::vec>(n);
	vector<double> x(x0.begin(), x0.end());


	heapsort(x);

	bool sorted = true;
	for (int i = 1; sorted && i < n; i++)
	{
		sorted = (x[i] - x[i-1] >= 0);
	}

	if (sorted)
		cout << "sorted!" << endl;
	else
		cout << "not sorted!" << endl;
	return 1;
}
