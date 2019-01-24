function [ub, J] = LAPJV_matlab_v2(Q_hat, Qs, Q)
    [m, ~] = size(Q_hat);
    L = length(Q);
    Qs_hat = repmat(Q_hat,[1,1,L]);

    cost_mat = squeeze(sum(abs(Qs_hat - Qs).^2, 2));    
    cost_mat = [cost_mat; zeros(L-m, L)];

    [J,ub]=lapjv2(cost_mat);
    
    ub = norm(Q_hat-Q(J(1:m),:), 'fro');
    % rmse = mean(sqrt(sum(diff.^2,2)));
end