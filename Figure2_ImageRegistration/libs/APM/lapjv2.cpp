#include "mex.h"
#include "math.h"
#include "lap.h"
void mexFunction
(int nl, mxArray *pl[], int nr, const mxArray *pr[])
{
    if (nr == 1 )    
    {
        double *distMatrix=mxGetPr(pr[0]);
        int N=mxGetM(pr[0]);
        int Ny=mxGetN(pr[0]);
        if (Ny!=N){
            printf("err, not square matrix\n");
            return;
        }
        
        
        double **distpt=new double*[N];
//                 (double **)malloc(sizeof(double *)*N);//pointer to distMatrix
        
        for (int i=0;i<N;i++)
            distpt[i]=distMatrix+i*N;
        

        pl[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
        double *assignment=mxGetPr(pl[0]);
        
        pl[1]=mxCreateDoubleScalar(0);
        double *cost=mxGetPr(pl[1]);
        
        
        int *rowsol = new int[N];
        int *colsol = new int[N];
        double *u = new double[N];
        double *v = new double[N];
        
        //run LAPJV!:
        cost[0] = lap(N,distpt,rowsol,colsol,u,v);
        for (int i=0;i<N;i++)
            assignment[i]=double(colsol[i]+1);
        delete [] rowsol;
        delete [] colsol;
        delete [] u;
        delete [] v;
        delete [] distpt;           
    }
}
