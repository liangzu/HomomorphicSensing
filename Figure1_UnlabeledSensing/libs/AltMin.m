function [x_hat, mle_e] = AltMin(A, y, x_init, num_iter)
% this function implements Haghighatshoar18

[m, n] = size(A);
[k, ~] = size(y);

x_hat = x_init;

J = inf;
for i=1:num_iter
    y_hat = A*x_hat;

    I = DP_L2(y,y_hat);

    mle_e = norm(y-y_hat(I), 2);

    if J - mle_e < 0.0001
        break;
    end

    if mle_e < J
        J = mle_e;
    end    

    x_hat = A(I,:) \ y;
end
end