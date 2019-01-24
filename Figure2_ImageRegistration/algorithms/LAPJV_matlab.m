function [ub, J] = LAPJV_matlab(Q_hat, Q)
    [m, ~] = size(Q_hat);
    [L, ~] = size(Q);
    Qs_hat = repmat(Q_hat,[1,1,L]);
    Qs = permute(repmat(Q,[1,1,m]), [3,2,1]); 
        
    cost_mat = squeeze(sum(abs(Qs_hat - Qs).^2, 2));
    cost_mat = [cost_mat; zeros(L-m, L)];

    [J,ub]=lapjv2(cost_mat);
    
    ub = norm(Q_hat-Q(J(1:m),:), 'fro');
end