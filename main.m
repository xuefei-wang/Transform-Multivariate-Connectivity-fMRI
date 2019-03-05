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
GOF = cal_GOF(Y, Y_hat);

% sparsity
threshold_list = [0:0.1:1];
density_list = sparsity_density_curve(T, threshold_list);
RDD = sparsity_fitting(density_list, threshold_list,0);
% TODO: monte carlo simulation and estimate the sparsity
num_rpt = 20;
noise_list = 0.2:0.05:0.65;
sparsity_list = 0.5:0.1:0.9;
N_y = size(Y,1);
[Y_sim_mc, Y_hat_mc, lambda_mc, T_mc, T_hat_mc] = sparsity_simulation(noise_list, sparsity_list, X, num_rpt, N_y, GOF, RDD)


sv = deformation_decay_curve(T);
RDSV = deformation_fitting(sv,0);
% TODO: monte carlo simulation and estimate the deformation
