%% add paths
setup

% to compile the cpp file (which implements the linear assignment algorithm),
% uncomment the following line if you are not on Linux
% cd libs/APM; mex lapjv2.cpp; cd ..; cd ..;

%% generate data
n = 2;
m = 100;
k = 80;
sigma = 0.01;

P = randn(k, n);
P0 = [P; randn(m-k, n)]; % add outliers


T = randn(3,2); % random affine transformation
Q = P0*T(1:2,:)+ T(3,:);
P = P + sigma*randn(k, n);

%% algorithm parameters (the example file for Unlabeled Sensing has given detailed comments on these parameters)
EM_iter = 20;
scale = 6;
max_iter = 10000;
time_budget = 20;
tolerance = 1e-10;
trans_type = 'affine';
verbose = true;

%% run the algorithm
tic;
[T_hat, Q_hat] = S_BnB_affine_Matrices(P, Q, scale, EM_iter, tolerance, trans_type, max_iter, time_budget, verbose);
toc;

diff = Q_hat - Q(1:k,:);

disp(sprintf("Registration Error:%.5f, Estimation Error:%.5f", ...
    mean(sqrt(sum(diff.^2,2))), norm(T_hat-T,'fro')/norm(T, 'fro')))