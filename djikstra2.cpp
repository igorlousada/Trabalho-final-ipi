#include <bits/stdc++.h>
#include "mex.h"

using namespace std;

#define mp make_pair
#define ff first
#define ss second

static const int v8_x[] = { -1,  0, 0, 1};
static const int v8_y[] = {  0, -1, 1, 0};

void djikstra2(const mxArray *mx_beg, const mxArray *mx_endi, const mxArray *mx_I, const mxArray *mx_mask, mxArray *mx_route)
{
	const mwSize *siz, *siz_mask, *siz_beg, *siz_endi;
	int nDims, nDims_mask, nDims_beg, nDims_endi;
	int16_t *beg, *endi;
	double  *I;
	bool  *route, *mask;
	nDims = (int)mxGetNumberOfDimensions(mx_I);
	siz = mxGetDimensions(mx_I);
	nDims_mask = (int)mxGetNumberOfDimensions(mx_mask);
	siz_mask = mxGetDimensions(mx_mask);

	if(nDims != 2) {
		mexPrintf("Dim errado");
		return;
	}
	mexPrintf("siz = [%d, %d]\n", siz[0], siz[1]);
//return;

	I = (double*)mxGetPr(mx_I);
	mask = (bool*)mxGetPr(mx_mask);
	
	route = (bool*)mxGetPr(mx_route);
	mexPrintf("Conseguiu imagens\n");
	nDims_beg = (int)mxGetNumberOfDimensions(mx_beg);
	siz_beg = mxGetDimensions(mx_beg);
	beg = (int16_t*)mxGetPr(mx_beg);
	nDims_endi = (int)mxGetNumberOfDimensions(mx_endi);
	siz_endi = mxGetDimensions(mx_endi);
	endi = (int16_t*)mxGetPr(mx_endi);
	mexPrintf("Conseguiu abrir\n");

	mexPrintf("%d, (%d, %d)\n", nDims, siz[1], siz[0]);
	mexPrintf("%d, (%d, %d)\n", nDims_mask, siz_mask[1], siz_mask[0]);
	mexPrintf("%d, (%d, %d)\n", nDims_beg, siz_beg[1], siz_beg[0]);
	mexPrintf("%d, (%d, %d)\n", nDims_endi, siz_endi[1], siz_endi[0]);

	priority_queue<pair<double, pair<int, int> > > q;

//invert beg e endi
int t = beg[0] - 1;
beg[0] = beg[1] - 1;
beg[1] = t;
t = endi[0] - 1;
endi[0] = endi[1] - 1;
endi[1] = t;

	double dist[siz[1]][siz[0]];
	int prev[siz[1]][siz[0]];
	for (int i = 0; i < siz[1]; i++)
		for (int j = 0; j < siz[0]; j++) {
			dist[i][j] = 2e17;
			prev[i][j] = 0;
			route[i * siz[0] + j] = false;
		}

	dist[beg[0]][beg[1]] = 0.0;
//return;
	mexPrintf("%d %d\n", beg[0], beg[1]);
	mexPrintf("%d %d\n", endi[0], endi[1]);
//return;

	q.push(mp(0.0, mp(beg[0], beg[1])));
//return;

//	FILE *fp = fopen("teste", "w");
//	for (int i = 0; i < siz[1]; i++) {
//		for (int j = 0; j < siz[0]; j++) {
//			fprintf(fp, "%d", mask[i * siz[0] + j]);
//		}
//	fprintf(fp, "\n");
//	}
//	fclose(fp);



	if (!mask[endi[0] * siz[0] + endi[1]] || !mask[beg[0] * siz[0] + beg[1]]) {
		mexPrintf("Dados errados\n");
		return;
	}
	while (!q.empty()) {

		pair <double, pair<int, int> > v = q.top(); q.pop();
		//mexPrintf("(%d, (%d, %d))\n", v.ff, v.ss.ff, v.ss.ss);
		int i = v.ss.ff;
		int j = v.ss.ss;

		if (i == endi[0] && j == endi[1]) {
			mexPrintf("Chegou\n");
			while ((i != beg[0]) || (j != beg[1])) {
				int t = i;
				route[i * siz[0] + j] = true;
				i -= v8_x[prev[i][j]];
				j -= v8_y[prev[t][j]];
			}
			route[i * siz[0] + j] = true;

			return;
		}

		for (int a = 0; a < 4; a++) {
			int newi = i + v8_x[a];
			int newj = j + v8_y[a];
			//mexPrintf("(%d, %d)\n", newi, newj);
			if (mask[newi * siz[0] + newj]) {
			//mexPrintf("Yeah\n");
				double grad = abs(I[newi * siz[0] + newj] - I[i * siz[0] + j]);
				if (dist[newi][newj] > v.ff + grad) {
					dist[newi][newj] = v.ff + grad;
					prev[newi][newj] = a;
					//mexPrintf("push (%d, (%d, %d))\n", dist[newi][newj], newi, newj);
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

	int nDims = (int)mxGetNumberOfDimensions(prhs[3]);
	const mwSize *siz = mxGetDimensions(prhs[3]);
	plhs[0] = mxCreateNumericArray(2, siz, mxLOGICAL_CLASS, mxREAL);

	djikstra2(prhs[0], prhs[1], prhs[2], prhs[3], plhs[0]);

}
