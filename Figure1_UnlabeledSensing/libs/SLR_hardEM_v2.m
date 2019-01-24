function [x_hat, mle_e] = SLR_hardEM_v2(A,y,x_init, n_iter)
% Implements the Hard EM algorithm described in Abid et al., arXiv 2018,
% for solving the Shuffled Linear Regression (SLR) problem (A,y).

% OUTPUT
% x: n x 1 solution to the SLR problem
% Pi: corresponding permutation that matches rows of A to y (applied on A)

% initializations
%[m, n] = size(A);
%[~, I] = size(x_init);

% Identity = eye(m);

% sort y in ascending order
[y, idx] = sort(y,1);

tt = 1;
x_hat = x_init;
J = inf;
while (tt <= n_iter)

    y_hat = A * x_hat;

    [y_hat, Pi_I] = sort(y_hat, 1);
    A = A(Pi_I,:);

    mle_e = norm(y - y_hat);

    if J - mle_e < 0.0001
        break;
    end

    if mle_e < J
        J = mle_e;
    end
    x_hat = A \ y;
    tt = tt+1;
end
%disp(sprintf("#iteration: %d", tt));
end
