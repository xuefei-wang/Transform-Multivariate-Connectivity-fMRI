function GOF = cal_GOF(Y, Y_hat)
% caulculate the percentage goodness of fit
% GOF := 100(1-A(lambda)/(N_s * N_y))

[N_s, N_y] = size(Y);
A  = sum(sum((Y - Y_hat).^2)); % A is the sum of squared residuals
GOF = 100 * (1 - A/(N_s* N_y));
