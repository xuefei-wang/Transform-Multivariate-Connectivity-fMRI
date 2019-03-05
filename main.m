function [T, GOF, Y_hat, lambda, density_list, RDD, sv, RDSV] =  main(Y, X)
% [reference]
% Analysing linear multivariate pattern transformations in neuroimaging data
% Alessio Basti, Marieke Mur, Nikolaus Kriegeskorte, Vittorio Pizzella, Laura Marzetti, Olaf Hauk
% doi: https://doi.org/10.1101/497180


% first Z-normalize  X and Y
X = zscore(X);
Y = zscore(Y);

% get the result of linear regression
[Y_hat, T, lambda] = ridge_regression_cross_valid(Y, X);

% Goodness of fit
GOF = cal_gof(Y, Y_hat);

% sparsity
threshold_list = [0:0.1:1];
density_list = sparsity_density_curve(T, threshold_list);
RDD = sparsity_fitting(density_list, threshold_list);
% TODO: monte carlo simulation and estimate the sparsity



sv = deformation_decay_curve(T);
RDSV = deformation_fitting(sv);
% TODO: monte carlo simulation and estimate the deformation
