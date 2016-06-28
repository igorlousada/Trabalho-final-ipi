#include <bits/stdc++.h>
#include "mex.h"

using namespace std;

#define mp make_pair
#define ff first
#define ss second

static const int v8_x[] = { -1, -1, -1, 0, 0, 1, 1, 1};
static const int v8_y[] = { -1, 0, 1, -1, 1, -1, 0, 1};

void djikstra(const mxArray *mx_beg, const mxArray *mx_endi, const mxArray *mx_I, const mxArray *mx_mask, mxArray *mx_route)
{
	const mwSize *siz;
	int nDims;
	uint8_t *beg, *endi, *I, *mask, *route;
	nDims = (int)mxGetNumberOfDimensions(mx_I);
	siz = mxGetDimensions(mx_I);

	beg = (uint8_t*)mxGetPr(mx_beg);
	endi = (uint8_t*)mxGetPr(mx_endi);
	I = (uint8_t*)mxGetPr(mx_I);
	mask = (uint8_t*)mxGetPr(mx_mask);
	route = (uint8_t*)mxGetPr(mx_route);

	priority_queue<pair<long long, pair<int, int> > > q;

	long long dist[siz[0]][siz[1]];
	int prev[siz[0]][siz[1]];

	for (int i = 0; i < siz[0]; i++)
		for (int j = 0; j < siz[1]; j++) {
			dist[i][j] = 2e17;
			prev[i][j] = 0;
		}

	dist[beg[0]][beg[1]] = 0;

	q.push(mp(0, mp(beg[0], beg[1])));

	while (!q.empty()) {

		pair <long long, pair<int, int> > v = q.top(); q.pop();
		int i = v.ss.ff;
		int j = v.ss.ss;

		if (j == endi[0] && i == endi[1]) {

			while ((i != beg[0]) || (j != beg[1])) {
				int t = i;
				route[i * siz[0] + j] = 1;
				i -= v8_x[prev[i][j]];
				j -= v8_y[prev[t][j]];
			}

			return;
		}

		for (int a = 0; a < 8; a++) {
			int newi = i + v8_x[a];
			int newj = j + v8_y[a];

			if (mask[newi * siz[0] + newj]) {
				long long grad = abs(I[newi * siz[0] + newj] - I[i * siz[0] + j]);
				if (dist[newi][newj] > v.ff + grad) {
					dist[newi][newj] = v.ff + grad;
					prev[newi][newj] = a;
					q.push(mp(dist[newi][newj], mp(newi, newj)));
				}
			}
		}
	}
}


// MATLAB entry point
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if(nlhs != 1) {
		mexPrintf("Sem argumento de saida\n");
		return;
	}
	if(nrhs != 4) {
		mexPrintf("Sem argumento de entrada\n");
		return;
	}

	djikstra(prhs[0], prhs[1], prhs[2], prhs[3], plhs[0]);

}
