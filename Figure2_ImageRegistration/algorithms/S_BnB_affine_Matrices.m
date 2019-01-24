function [T_hat, Q_hat, time_used] = S_BnB_affine_Matrices(P, Q, scale, EM_iter, tolerance, trans_type, max_iter, time_budget, verbose)
% This function implements Algorithm-C described in [1].

% P,Q         (numeric) : inputs of the image registration problem.
% scale       (positive): the initial cube will be [-scale/2, scale/2]^n or
%                                                  [-scale/2, scale/2] if scale is a vector
% EM_iter     (integer):  #iterations of the local algorithm.
% tolerance   (positive):
% trans_type  (string):   'linear' or 'affine'
% max_iter    (integer):  #iteration of the branch-and-bound algorithm.
% time_budget (positive): the time (> 0) the algorithm should run.
% verbose     (integer):  print some statistics with frequence "verbose" if verbose>0.

% if you have found this code helpful in your research,
% kindly cite this paper:
% [1] M. C. Tsakiris and L. Peng, Homomorphic sensing, arXiv:1901.07852 [cs.IT], 2019

% Copyright @ L. Peng and M.C. Tsakiris, 2019.


if strcmp(trans_type, 'linear')
    n = 2;
elseif strcmp(trans_type, 'affine')
    n = 3;
    P = [P, ones(length(P),1)];
else
    disp("unknown transformation");
    return;
end

%% construct the initial cube.
center_init = zeros(2*n,1);
if length(scale) == 1
    eps_init = 0.5*scale*ones(2*n, 1);
elseif length(scale) == n
    eps_init = 0.5*[scale; scale];
end

% cube: [T_{1:2n}; eps_{1:2n}; ub; lb]
% cubes: [cube1, cube2, ......]
cubes = [center_init;eps_init; inf; 0];

center_idx = 1:2*n;
eps_idx = 2*n+1:4*n;


%% other neccesary initialization.
min_ub = norm(Q,'fro');

constant = norm(P,'fro');

T_hat = zeros(2*n,1);

ubs = zeros(1,2);

ub_idx = 4*n+1;
lb_idx = 4*n+2;

split_idx = 0;

Qs = permute(repmat(Q,[1,1,length(P)]), [3,2,1]);

iter_count=0;
tic;
while true
    time_used = toc;
    if time_used > time_budget
        break;
    end

    iter_count = iter_count + 1;
    [~, s] = size(cubes);
    if s == 0
        break;
    end

    [min_lb, idx] = min(cubes(lb_idx, :));

     %% alternatively perform depth-first or width-first search.
    if  iter_count < max_iter || rem(iter_count,2) == 0
        idx = 1;
    else
        % exit after running "max_iter" iterations
        break;
    end

    if verbose
        % running statistics for the algorithm
        format shortG
        disp(sprintf("#Iter:%d, #Cubes:%d", iter_count, s))
        disp(sprintf("Best Upper Bound:%f, Lowest lower bound:%f", min_ub, min_lb));
    end

    if min_ub - min_lb < tolerance || min_ub < tolerance
        break;
    end

    %% extract info. from the selected hypercube (idx) and remove that hypercube.
    T0 = cubes(center_idx, idx);
    lb0 = cubes(lb_idx, idx);
    eps2 = cubes(eps_idx, idx);
    eps = eps2;

    split_idx = rem(split_idx, 2*n)+1;
    eps(split_idx, 1) = eps2(split_idx, 1)/2;

    cubes = [cubes(:,1:idx-1), cubes(:,idx+1:end)];

    %% run local algorithm for finding a better upper bound "ub_em"
    [T_em, ub_em] = LAPJV_EM(P, Q, T0, EM_iter);

    if ub_em < min_ub
        min_ub = ub_em;
        T_hat = T_em;
    end

    %% split the cube
    Ts = repmat(T0, 1, 2);
    Ts(split_idx, :) = T0(split_idx, 1) + [eps(split_idx,1), - eps(split_idx,1)];

    %% upper bound and lower bound
    Q1 = P*reshape(Ts(:,1), [n,2]);
    Q2 = P*reshape(Ts(:,2), [n,2]);

    ubs(1,1) = LAPJV_matlab_v2(Q1, Qs, Q);
    ubs(1,2) = LAPJV_matlab_v2(Q2, Qs, Q);

    lbs2 = ubs - norm(eps)*constant;

    lbs = max(lbs2,lb0);

    [potential_min_ub, idx2] = min(ubs);
    if potential_min_ub < min_ub
        min_ub = potential_min_ub;
        T_hat = Ts(:,idx2);
    end
    %% rule out unpromising subcubes.
    idx2 = (lbs < min_ub & ubs-lbs > tolerance);
    Ts = Ts(:,idx2);
    ubs = ubs(:, idx2);
    lbs = lbs(:, idx2);

    %% add new nodes
    [~, sx] = size(Ts);
    Eps = repmat(eps, 1, sx);

    subcubes = [Ts;Eps;ubs;lbs];

    cubes = [cubes(:,cubes(lb_idx,:)<=min_ub), subcubes];
end
T_hat = reshape(T_hat(:,1), [n,2]);
Q_hat = P*T_hat;
end
