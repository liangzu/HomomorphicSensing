% add MATLAB paths
addpath('algorithms');


% to compile the cpp file (which implements the dynamic programming algorithm),
% uncomment the following line if you are not on Linux
% cd algorithms; mex DP_L2.cpp; cd ..

%% generate data
n = 3;
m = 100;

k = 80;
sigma = 0.01;

x = randn(n, 1);
A = randn(m, n);

y = A*x+sigma*randn(m,1);
y = y(randperm(m), 1);
y = y(1:k,1);


%% algorithm parameters
EM_iter = 50;              % #iterations of the local algorithm
max_iter = inf;            % #iterations of the branch-and-bound algorithm
time_budget = inf;         % the time (> 0) the algorithm should run.
scale = 6;                 % the initial cube will be [-scale/2, scale/2]^n.

depth = 6;                 % stop splitting when the largest diagonal of a
                           %    (sub-)hypercube is less than 2^{-depth}*(the largest dinagonal of the initial hypercube).
                           %    depth depends on the desired accuracy and the scale of the initial cube.
                           %    recommended value (for scale=6): 5,6.
                           %    also try depth=1-4 to see what happens.

tolerance = 0.0001;
verbose = 1000;            % print some statistics with frequence "verbose" if verbose>0.
                           %   recommended value: 0-1000

%% run the algorithms
tic;

% running our branch-and-bound algorithm
x_hat = S_BnB_v2(A, y, scale, EM_iter, tolerance, max_iter, depth, time_budget, verbose);

% running our Elhami17
%[x_hat, e_hat, GR_time] = GeometricReconstruction(A, y);
toc;

err = norm(x_hat-x)/norm(x);
disp(sprintf("Estimation Error: %.5f", err))
