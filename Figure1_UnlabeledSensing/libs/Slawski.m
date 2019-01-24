function x_hat = Slawski(A,y, noise_ratio, shuffle_ratio, threshold)
% This function implements Slawski19

[m, n] = size(A);
k = m-int64(shuffle_ratio*m);

lambda = 0.2*noise_ratio*sqrt(log(n)/n);

cvx_expert true
cvx_begin quiet
    variables x_hat(n,1) e(m,1);
    minimize(power(2, norm(y-A*x_hat-sqrt(n)*e, 2))+lambda*norm(e,1));
cvx_end
if threshold
    [~, idx] = sort(abs(e));
    y = y(idx,1);
    A = A(idx,:);
    
    %e(idx)
    if shuffle_ratio > 0
        x_hat = A(1:(m-k),:)\y(1:(m-k), 1);
    end    
end

end