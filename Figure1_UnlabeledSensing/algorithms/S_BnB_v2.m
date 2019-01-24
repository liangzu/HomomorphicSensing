function [x_hat, time_] = S_BnB_v2(A, y, scale, EM_iter, tolerance, max_iter, depth, time_budget, verbose)
% This function implements Algorithm-A described in [1].

% A, y        (numeric) : inputs of the unlabeled sensing problem.
% scale       (positive): the initial cube will be [-scale/2, scale/2]^n.
% EM_iter     (integer):  #iterations of the local algorithm.
% tolerance   (positive):
% max_iter    (integer):  #iteration of the branch-and-bound algorithm.
% depth       (integer):  stopp splitting when the largest diagonal of a
%                            (sub-)hypercube is less than 2^{-depth}*(the largest dinagonal of the initial hypercube).
% time_budget (positive): the time (> 0) the algorithm should run.
% verbose     (integer):  print some statistics with frequence "verbose" if verbose>0.

% if you have found this code helpful in your research,
% kindly cite this paper:
% [1] M. C. Tsakiris and L. Peng, Homomorphic sensing, arXiv:1901.07852 [cs.IT], 2019

% Copyright @ L. Peng and M.C. Tsakiris, 2019.


[m, n] = size(A);
k = length(y);
if k > m
    disp(sprintf("Wrong input: the size of A is %dx%d and the size of y is %d, but %d>%d", m, n, k, k, m));
    return;
end

y= sort(y);

%% construct the initial cube.
center_init = zeros(n, 1);
eps_init = 0.5*scale*ones(n, 1);

% cube: [x_{1:n}; eps_{1:n}; ub; lb]
% cubes: [cube1, cube2, ......]
cubes = [center_init; eps_init;inf;0];

center_idx = 1:n;
eps_idx = n+1:2*n;

%% other neccesary initialization.
min_ub = norm(y);
x_hat = zeros(n,1);

constant = norm(A, 2);

% backup hypercubes
%       because operating on a very long list of cubes is very slow.
backup = false;
cubes_backup = [];
num_active = 100;
capacity_backup = 100000;

lb_idx = 2*n+2;

split_idx = 0;

iter_count=0;
tic;

% splitting scheme for the hypercube.
n_split_cubes = 4;
if n <= n_split_cubes
    num_subcubes = 2^n;
else
    num_subcubes = 2;
end

ubs = zeros(1,num_subcubes);
lbs = zeros(1,num_subcubes);

tic;
while true
    time_ = toc;
    if time_ > time_budget
        break;
    end
    iter_count = iter_count + 1;

    [~, s] = size(cubes);
    [~, s_backup] = size(cubes_backup);


    if s == 0
        %% use the backup cubes when running out of current list of cubes.
        if backup && s_backup>0
            num_c = min(num_active, s_backup);
            cubes = cubes_backup(:,1:num_c);
            [~, s] = size(cubes);

            cubes_backup=cubes_backup(:,num_c+1:end);
            [~, s_backup] = size(cubes_backup);
            capacity_backup = max(capacity_backup-num_active, num_active);
        else
            break;
        end
    end

    if s == 0
        break;
    end

    %% hypercube index with lowest lower bound.
    [min_lb, idx] = min(cubes(lb_idx, :));

    if s_backup > 0
        min_lb = min(min_lb, min(cubes_backup(lb_idx,:)));
    end
    %% alternatively perform depth-first or width-first search.
    if iter_count < max_iter || rem(iter_count,2) == 0
        idx = 1;
    else
        % exit after running "max_iter" iterations
        break;
    end

    if verbose>0 && rem(iter_count, verbose) == 0
        % running statistics for the algorithm
        num_pruned = iter_count*num_subcubes-s-s_backup-iter_count;
        disp(sprintf("#Cubes (#visited,#active,#inactive,#remaining,#pruned)=(%d,%d,%d,%d,%d)", iter_count, s-1, s_backup, s-1+s_backup, num_pruned))
        disp(sprintf("Best Upper Bound:%f, Lowest lower bound:%f", min_ub, min_lb));
    end

    if min_ub - min_lb < tolerance || min_ub < tolerance
        break;
    end

    %% extract info. from the selected hypercube (idx) and remove that hypercube.
    x0 = cubes(center_idx, idx);
    lb0 = cubes(lb_idx, idx);
    eps2 = cubes(eps_idx, idx);
    cubes = [cubes(:,1:idx-1), cubes(:,idx+1:end)];

    %% run local algorithm for finding a better upper bound "e_em"
    [x_em, e_em] = S_EM(A,y,x0, EM_iter);

    if e_em < min_ub
        min_ub = e_em;
        x_hat = x_em;
    end

    if max(eps2)/max(eps_init) < 2^(-depth)
        % stop splitting
        continue;
    end

    %% split the cube
    if n <= n_split_cubes
        eps = eps2/2;

        EPS = shifts(n, eps);
        xs = x0 + EPS;
    else
        eps = eps2;
        split_idx = rem(split_idx, n)+1;
        eps(split_idx, 1) = eps(split_idx, 1)/2;

        xs = repmat(x0, 1, 2);
        xs(split_idx, :) = x0(split_idx, 1) + [eps(split_idx,1), - eps(split_idx,1)];
    end

    %% compute upper bound and lower bound
    ys_hat = sort(A*xs, 1);
    for i=1:num_subcubes
        y_hat = ys_hat(:,i);
        I = DP_L2(y, y_hat).';
        ubs(1,i) = norm(y-y_hat(I), 2);

        % the lower bound should be the maximum of the lower bounding
        % function and the lower bound of its parent node.
        lbs(1,i) = max(ubs(1,i) - norm(eps)*constant, lb0);
    end
    %% update the lowest upper bound
    [potential_min_ub, idx2] = min(ubs);
    if potential_min_ub < min_ub
        min_ub = potential_min_ub;
        x_hat = xs(:,idx2);
    end

    %% rule out unpromising subcubes.
    idx2 = (lbs < min_ub & ubs-lbs > tolerance);
    xs = xs(:,idx2);
    ubs = ubs(:, idx2);
    lbs = lbs(:, idx2);

    %% add new subcubes
    [~, sx] = size(xs);
    Eps = repmat(eps, 1, sx);
    subcubes = [xs;Eps;ubs;lbs];

    %% because operating on a very long list of cubes is very slow.
    if s > num_active
        backup = true;
    end

    if backup && s_backup < capacity_backup
        if isempty(cubes_backup)
            cubes_backup = subcubes;
        else
            cubes_backup = [cubes_backup(:,cubes_backup(lb_idx,:)<=min_ub), subcubes];
        end

        cubes = cubes(:,cubes(lb_idx,:)<=min_ub);
    else
        cubes = [cubes(:,cubes(lb_idx,:)<=min_ub), subcubes];
    end
end
time_ = toc;

end

function EPS = shifts(n, eps)
    one = ones(n, 1);
    ONEs = zeros(n, 2^n);
    ONEs(:, 1) = one;
    begin_idx = 1;

    for i=1:n
        one(i,1)=-1;
        end_idx = begin_idx + nchoosek(n,i);
        ONEs(:, begin_idx+1:end_idx) = unique(perms(one),'rows').';
        begin_idx = end_idx;
    end
    EPS = eps.*ONEs;
end
