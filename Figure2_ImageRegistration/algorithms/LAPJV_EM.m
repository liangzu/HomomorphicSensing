function [T_em,ub_em] = LAPJV_EM(P, Q, T0, EM_iter)
    [m, n] = size(P);
    [L, ~] = size(Q);        
    
    T_em = reshape(T0, [n, 2]);
        
    J = inf;
    
    
    % alternatively solve the linear assignment and least square problem
    for i=1:EM_iter  
        Q_hat = P*T_em;         
        [ub_em, I] = LAPJV_matlab(Q_hat, Q);
        
        if J - ub_em < 0.0001
            break;
        end
        
        if ub_em < J
            J = ub_em;
        end
        
        T_em = P\Q(I(1:m),:);
    end
    T_em = reshape(T_em,[2*n,1]);
end