// DP_L2.CPP: implements a dynamic programming procedure that computes S=argmin_{S}||y-S*y_hat||_2

// if you have found this code helpful in your research,
// kindly cite this paper:
// M. C. Tsakiris and L. Peng, Homomorphic sensing, arXiv:1901.07852 [cs.IT], 2019

// Copyright @ L. Peng and M.C. Tsakiris, 2019.

#include "mex.h"
#include <vector>
#include <algorithm>
#include <iostream>
#include <limits>
#include <cmath>
using std::cout;
using std::endl;


inline double square_dist(double p1, double p2) {
    double d = p1-p2;
    return d*d;
}


std::vector<int> DP(double* y, double* y_hat, const int m, const int L) {

    std::vector<int> results(L, 0);

    double cost[m][L];

    // compute the matching cost for the first row.
    cost[0][0] = square_dist(y[0], y_hat[0]);
    for (int j = 1; j < L; ++j) {
        cost[0][j] = std::min(cost[0][j-1], square_dist(y[0], y_hat[j]));
    }
    // compute the matching cost of diagonal elements
    for (int i = 1; i < m; ++i) {
        cost[i][i] = cost[i-1][i-1] + square_dist(y[i], y_hat[i]);
    }

    for (int i = 1; i < m; ++i) {
        for (int j = i + 1; j < L; ++j) {
            cost[i][j] = std::min(cost[i][j-1], cost[i-1][j-1] + square_dist(y[i], y_hat[j]));
        }
    }

    int idx = L-1;
    for (int i = m-1; i > -1; --i) {
        while(idx > 0 && cost[i][idx] == cost[i][idx-1] && cost[i][idx] > 0) {
            idx--;
        }
        results[idx] = 1;
        idx--;
    }

    return std::move(results);
}


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    const mxArray *y = prhs[0];
    const mxArray *y_hat = prhs[1];

    const mwSize *y_dim = mxGetDimensions(y);
    const mwSize *y_hat_dim = mxGetDimensions(y_hat);

    const int m = y_dim[0];
    const int L = y_hat_dim[0];

    double *y_ptr = (double*) mxGetData(y);
    double *y_hat_ptr = (double*) mxGetData(y_hat);

    mwSize dims[2];
    dims[0] = 1;
    dims[1] = m;
    plhs[0] = mxCreateNumericArray(2, dims, mxINT32_CLASS, mxREAL);
    int * I = (int*) mxGetData(plhs[0]);

    if (m == L) {
        for (int i = 0; i < m; ++i) {
            I[i] = i+1;
        }
    }
    else if (m > L) {
        printf("Wrong Usage: ");
        exit(-1);
    }
    else if (L > 1000) {
        printf("Input size is too large (> 1000), which requires dynamical allocation of  memory");
        exit(-1);
    }

    else {
        auto results = DP(y_ptr, y_hat_ptr, m, L);

        int b = 0;
        for (int i=0; i < L; ++i) {
            if (results[i] > 0) {
                I[b++] = i+1;
            }
        }
    }
}
