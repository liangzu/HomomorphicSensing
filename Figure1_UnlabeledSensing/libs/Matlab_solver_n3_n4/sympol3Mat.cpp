//standard headers
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include "mex.h"
#include <eigen3/Eigen/Eigen>
#include <iostream>

void
initRow(
    Eigen::MatrixXd  & M2,
    const Eigen::MatrixXd & M1,
    int row2,
    int row1,
    const int * cols2,
    const int * cols1,
    size_t numberCols )
{
  for( int i = 0; i < numberCols; i++ )
    M2(row2,cols2[i]) = M1(row1,cols1[i]);
}

void
solve( std::vector<double> & vector1, std::vector<double> & vector2, std::vector<double> & vector3, std::vector< Eigen::Matrix<double,3,1>, Eigen::aligned_allocator<Eigen::Matrix<double,3,1> > > & solutions )
{
Eigen::MatrixXd M1(3,20);
M1.fill(0.0);
M1(0,0) = vector3[0]; M1(0,1) = vector3[1]; M1(0,2) = vector3[2]; M1(0,3) = vector3[3]; M1(0,4) = vector3[4]; M1(0,5) = vector3[5]; M1(0,6) = vector3[6]; M1(0,7) = vector3[7]; M1(0,8) = vector3[8]; M1(0,9) = vector3[9]; M1(0,19) = vector3[10]; 
M1(1,10) = vector2[0]; M1(1,11) = vector2[1]; M1(1,12) = vector2[2]; M1(1,13) = vector2[3]; M1(1,14) = vector2[4]; M1(1,15) = vector2[5]; M1(1,19) = vector2[6]; 
M1(2,16) = vector1[0]; M1(2,17) = vector1[1]; M1(2,18) = vector1[2]; M1(2,19) = vector1[3]; 

Eigen::MatrixXd  M2(29,35);
M2.fill(0.0);
static const int ind_2_0 [] = {0,1,5,15};
static const int ind_1_0 [] = {16,17,18,19};
initRow( M2, M1, 0, 2, ind_2_0, ind_1_0, 4  );
static const int ind_2_1 [] = {0,1,2,5,6,9,24};
static const int ind_1_1 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 1, 1, ind_2_1, ind_1_1, 7  );
static const int ind_2_2 [] = {0,1,2,3,5,6,7,9,10,12,28};
static const int ind_1_2 [] = {0,1,2,3,4,5,6,7,8,9,19};
initRow( M2, M1, 2, 0, ind_2_2, ind_1_2, 11  );
static const int ind_2_3 [] = {1,2,6,16};
static const int ind_1_3 [] = {16,17,18,19};
initRow( M2, M1, 3, 2, ind_2_3, ind_1_3, 4  );
static const int ind_2_4 [] = {1,2,3,6,7,10,25};
static const int ind_1_4 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 4, 1, ind_2_4, ind_1_4, 7  );
static const int ind_2_5 [] = {1,2,3,4,6,7,8,10,11,13,32};
static const int ind_1_5 [] = {0,1,2,3,4,5,6,7,8,9,19};
initRow( M2, M1, 5, 0, ind_2_5, ind_1_5, 11  );
static const int ind_2_6 [] = {2,3,7,17};
static const int ind_1_6 [] = {16,17,18,19};
initRow( M2, M1, 6, 2, ind_2_6, ind_1_6, 4  );
static const int ind_2_7 [] = {2,3,4,7,8,11,26};
static const int ind_1_7 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 7, 1, ind_2_7, ind_1_7, 7  );
static const int ind_2_8 [] = {3,4,8,18};
static const int ind_1_8 [] = {16,17,18,19};
initRow( M2, M1, 8, 2, ind_2_8, ind_1_8, 4  );
static const int ind_2_9 [] = {5,6,9,19};
static const int ind_1_9 [] = {16,17,18,19};
initRow( M2, M1, 9, 2, ind_2_9, ind_1_9, 4  );
static const int ind_2_10 [] = {5,6,7,9,10,12,27};
static const int ind_1_10 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 10, 1, ind_2_10, ind_1_10, 7  );
static const int ind_2_11 [] = {5,6,7,8,9,10,11,12,13,14,33};
static const int ind_1_11 [] = {0,1,2,3,4,5,6,7,8,9,19};
initRow( M2, M1, 11, 0, ind_2_11, ind_1_11, 11  );
static const int ind_2_12 [] = {6,7,10,20};
static const int ind_1_12 [] = {16,17,18,19};
initRow( M2, M1, 12, 2, ind_2_12, ind_1_12, 4  );
static const int ind_2_13 [] = {6,7,8,10,11,13,30};
static const int ind_1_13 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 13, 1, ind_2_13, ind_1_13, 7  );
static const int ind_2_14 [] = {9,10,11,12,13,14,31};
static const int ind_1_14 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 14, 1, ind_2_14, ind_1_14, 7  );
static const int ind_2_15 [] = {15,16,19,24};
static const int ind_1_15 [] = {16,17,18,19};
initRow( M2, M1, 15, 2, ind_2_15, ind_1_15, 4  );
static const int ind_2_16 [] = {15,16,17,19,20,22,28};
static const int ind_1_16 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 16, 1, ind_2_16, ind_1_16, 7  );
static const int ind_2_17 [] = {15,16,17,18,19,20,21,22,23,29,34};
static const int ind_1_17 [] = {0,1,2,3,4,5,6,7,8,9,19};
initRow( M2, M1, 17, 0, ind_2_17, ind_1_17, 11  );
static const int ind_2_18 [] = {16,17,20,25};
static const int ind_1_18 [] = {16,17,18,19};
initRow( M2, M1, 18, 2, ind_2_18, ind_1_18, 4  );
static const int ind_2_19 [] = {16,17,18,20,21,23,32};
static const int ind_1_19 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 19, 1, ind_2_19, ind_1_19, 7  );
static const int ind_2_20 [] = {17,18,21,26};
static const int ind_1_20 [] = {16,17,18,19};
initRow( M2, M1, 20, 2, ind_2_20, ind_1_20, 4  );
static const int ind_2_21 [] = {19,20,22,27};
static const int ind_1_21 [] = {16,17,18,19};
initRow( M2, M1, 21, 2, ind_2_21, ind_1_21, 4  );
static const int ind_2_22 [] = {19,20,21,22,23,29,33};
static const int ind_1_22 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 22, 1, ind_2_22, ind_1_22, 7  );
static const int ind_2_23 [] = {20,21,23,30};
static const int ind_1_23 [] = {16,17,18,19};
initRow( M2, M1, 23, 2, ind_2_23, ind_1_23, 4  );
static const int ind_2_24 [] = {24,25,27,28};
static const int ind_1_24 [] = {16,17,18,19};
initRow( M2, M1, 24, 2, ind_2_24, ind_1_24, 4  );
static const int ind_2_25 [] = {24,25,26,27,30,31,34};
static const int ind_1_25 [] = {10,11,12,13,14,15,19};
initRow( M2, M1, 25, 1, ind_2_25, ind_1_25, 7  );
static const int ind_2_26 [] = {25,26,30,32};
static const int ind_1_26 [] = {16,17,18,19};
initRow( M2, M1, 26, 2, ind_2_26, ind_1_26, 4  );
static const int ind_2_27 [] = {27,30,31,33};
static const int ind_1_27 [] = {16,17,18,19};
initRow( M2, M1, 27, 2, ind_2_27, ind_1_27, 4  );
static const int ind_2_28 [] = {28,32,33,34};
static const int ind_1_28 [] = {16,17,18,19};
initRow( M2, M1, 28, 2, ind_2_28, ind_1_28, 4  );

Eigen::PartialPivLU<Eigen::MatrixXd> lu(M2.block(0,0,29,29));
Eigen::MatrixXd M3 = lu.solve(M2.block(0,29,29,6));
Eigen::Matrix<double,6,6> Action = Eigen::Matrix<double,6,6>::Zero();
Action.row(0) -= M3.block(14,0,1,6);
Action.row(1) -= M3.block(23,0,1,6);
Action(2,0) = 1.0;
Action(3,1) = 1.0;
Action(4,2) = 1.0;
Action(5,4) = 1.0;
//columns of Action mean:
// x_3^3 x_2*x_3 x_3^2 x_2 x_3 1

  Eigen::EigenSolver< Eigen::Matrix<double,6,6> > Eig(Action,true);
  Eigen::Matrix<std::complex<double>,6,1> D = Eig.eigenvalues();
  Eigen::Matrix<std::complex<double>,6,6> V = Eig.eigenvectors();

  for( int c = 0; c < 6; c++ )
  {
    std::complex<double> eigValue = D[c];

    //if( fabs(eigValue.imag()) < 0.0001 )
  //  {
      Eigen::Matrix<double,3,1> sol;

      std::complex<double> temp;
      temp = V(6,c) / V(5,c);
      sol(0,0) = temp.real();
      temp = V(3,c) / V(5,c);
      sol(1,0) = temp.real();
      temp = V(4,c) / V(5,c);
      sol(2,0) = temp.real();
      solutions.push_back(sol);
   // }
  }
}

void
completeSolver( Eigen::MatrixXd & A, Eigen::MatrixXd & y,
    std::vector< Eigen::Matrix<double,3,1>, Eigen::aligned_allocator< Eigen::Matrix<double,3,1> > > & solutions )
{
  //extract the polynomial coefficients
  std::vector<double> vector1; vector1.reserve(4);  for( size_t j = 0; j < 4;  j++ ) vector1.push_back(0.0);
  std::vector<double> vector2; vector2.reserve(7);  for( size_t j = 0; j < 7;  j++ ) vector2.push_back(0.0);
  std::vector<double> vector3; vector3.reserve(11); for( size_t j = 0; j < 11; j++ ) vector3.push_back(0.0);

  for( size_t ind = 0; ind < A.rows(); ind++ )
  {
    Eigen::Matrix<double,1,3> tempVec1; tempVec1 << A(ind,0), A(ind,1), A(ind,2);
    Eigen::Matrix<double,1,6> tempVec2; tempVec2 << pow(A(ind,0),2), 2*A(ind,1)*A(ind,0), pow(A(ind,1),2), 2*A(ind,2)*A(ind,0), 2*A(ind,2)*A(ind,1), pow(A(ind,2),2);
    Eigen::Matrix<double,1,10> tempVec3; tempVec3 << pow(A(ind,0),3), 3*A(ind,1)*pow(A(ind,0),2), 3*pow(A(ind,1),2)*A(ind,0), pow(A(ind,1),3), 3*A(ind,2)*pow(A(ind,0),2), 6*A(ind,2)*A(ind,1)*A(ind,0), 3*A(ind,2)*pow(A(ind,1),2), 3*pow(A(ind,2),2)*A(ind,0), 3*pow(A(ind,2),2)*A(ind,1), pow(A(ind,2),3);

    for( int j = 0; j < 3; j++ )
      vector1[j] += tempVec1(0,j);
    vector1[3] -= y(ind,0);

    for( int j = 0; j < 6; j++ )
      vector2[j] += tempVec2(0,j);
    vector2[6] -= pow(y(ind,0),2);

    for( int j = 0; j < 10; j++ )
      vector3[j] += tempVec3(0,j);
    vector3[10] -= pow(y(ind,0),3);
  }
  
  solve( vector1, vector2, vector3, solutions );

  //and correct for the first element
  for( int j = 0; j < solutions.size(); j++ )
    solutions[j](0,0) = -(vector1[1]*solutions[j](1,0)+vector1[2]*solutions[j](2,0)+vector1[3]) / vector1[0];
}


// The main mex-function
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  // Check if right number of arguments
  if( nrhs != 2 )
  {
    mexPrintf("sympol3: bad usage\n");
    return;
  }

  //get pointers and dimensions
  const mxArray *Amat = prhs[0];
  const mxArray *ymat = prhs[1];
  int ndimensions1 = mxGetNumberOfDimensions(Amat);
  int ndimensions2 = mxGetNumberOfDimensions(ymat);
  const mwSize *Adim = mxGetDimensions(Amat);
  const mwSize *ydim = mxGetDimensions(ymat);

  // Now check them
  if( ndimensions1 != 2 || ndimensions2 != 2 || ydim[1] != 1 ||
      Adim[0] != ydim[0] || Adim[1] != 3 || Adim[0] < 4 )
  {
    mexPrintf("sympol3: bad usage\n");
    return;
  }

  //get the data
  int m = Adim[0];
  Eigen::MatrixXd A(m,3);
  Eigen::MatrixXd y(m,1);

  double * Aptr = (double*) mxGetData(Amat);
  double * yptr = (double*) mxGetData(ymat);

  for( int r = 0; r < m; r++ )
  {
    for( int c = 0; c < 3; c++ )
      A(r,c) = Aptr[c*m+r];
    
    y(r,0) = yptr[r];
  }


  //add some dummy function here to check everythings right til here
  std::vector< Eigen::Matrix<double,3,1>, Eigen::aligned_allocator< Eigen::Matrix<double,3,1> > > solutions;
  completeSolver( A, y, solutions );

  long unsigned int dims[2];
  dims[0] = solutions.size();
  dims[1] = 3;
  plhs[0] = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);
  double * xptr = (double*) mxGetData(plhs[0]);

  int numberSolutions = solutions.size();

  for( int i=0; i < numberSolutions; i++ )
    xptr[i] = solutions[i](0,0);

  for( int i=0; i < numberSolutions; i++ )
    xptr[i+numberSolutions] = solutions[i](1,0);

  for( int i=0; i < numberSolutions; i++ )
    xptr[i+2*numberSolutions] = solutions[i](2,0);
}
