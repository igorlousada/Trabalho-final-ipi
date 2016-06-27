#include <bits/stdc++.h>

using namespace std;

#define mp make_pair
#define ff first
#define ss second

long long djikstra(int beg[2], int endi[2], int **I, int **mask, int v8_x[8], int v8_y[8], int *route, int *siz) {
	
	priority_queue<pair<long long, pair<int, int> > > q;
	
	long long dist[siz[0]][siz[1]];
	
	for (int i = 0; i < siz[0]; i++)
		for (int j = 0; j < siz[1]; j++)
			dist[i][j] = 2e17;
	
	dist[beg[0]][beg[1]] = 0;
	
	q.push(mp(0, mp(beg[0], beg[1])));
	
	while (!q.empty()) {
		
		pair <double, pair<int, int> > v = q.top(); q.pop();
		int i = v.ss.ff;
		int j = v.ss.ss;
		
		if (j == endi[0] && i == endi[1]) {
			return v.ff;
		}
		
		for (int a = 0; a < 8; a++) {
			int newi = i + v8_x[a];
			int newj = j + v8_y[a];
			
			if (mask[newi][newj]) {
				
				long long grad = abs(I[newi][newj] - I[i][j]);
				
				if (dist[newi][newj] > v.ff + grad) {
					dist[newi][newj] = v.ff + grad;
					q.push(mp(dist[newi][newj], mp(newi, newj)));
				}
			}
		}
	}
	
	return -1;
	
}
