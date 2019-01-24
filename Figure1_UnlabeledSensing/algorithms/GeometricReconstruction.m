function [x_hat, e_hat, time_] = GeometricReconstruction(A, y)
% This function implements Algorithm-B described in [1].

% if you have found this code helpful in your research,
% kindly cite this paper:
% [1] M. C. Tsakiris and L. Peng, Homomorphic sensing, arXiv:1901.07852 [cs.IT], 2019

% Copyright @ L. Peng and M.C. Tsakiris, 2019.

    y_sorted = sort(y);
    [m, n] = size(A);

    sample_idx = sort(datasample(1:m, n, 'Replace', false));
    y_subset = y(sample_idx, 1);

    e_hat = inf;

    c_indices = nchoosek(1:m, n);
    [c_num, ~] = size(c_indices);

    tic;
    for c=1:c_num  % for all selections
        perm_indices = perms(c_indices(c,:));
        [p_num, ~] = size(perm_indices);
        for p=1:p_num % for all permutations of one selection

            xp = A(perm_indices(p,:),:)\y_subset;
            % ep = norm(y_sorted-sort(A*xp));

            [y_hat, ~] = sort(A*xp);
            I = DP_L2(y_sorted,y_hat);
            ep = norm(y_sorted-y_hat(I), 2);

            if ep < e_hat
                e_hat = ep;
                x_hat = xp;
            end
        end
    end
    time_ = toc;
end
