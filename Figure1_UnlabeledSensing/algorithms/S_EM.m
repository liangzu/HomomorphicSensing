function [x_hat, mle_e] = S_EM(A,y,x_init, num_iter)
[L, n] = size(A);
[m, ~] = size(y);

x_hat = x_init;
y = sort(y);
J = inf;
for i=1:num_iter
    [y_hat, sort_idx] = sort(A*x_hat);

    I = DP_L2(y,y_hat);
    mle_e = norm(y-y_hat(I), 2);

    if J - mle_e < 0.0001
         break;
     end

    if mle_e < J
        J = mle_e;
    end

    A0 = A(sort_idx, :);
    x_hat = A0(I,:) \ y;
end

end
