function [T, GOF, Y_hat, lambda, density_list, RDD, sv, RDSV] =  step1(Y, X, toplot)
% Y, X should be in the form of (#voxels, #stimuli)
% toplot = 0

% [reference]
% Analysing linear multivariate pattern transformations in neuroimaging data
% Alessio Basti, Marieke Mur, Nikolaus Kriegeskorte, Vittorio Pizzella, Laura Marzetti, Olaf Hauk
% doi: https://doi.org/10.1101/497180


% first Z-normalize  X and Y across voxels for each stimulus
X = zscore(X,1,1);
Y = zscore(Y,1,1);

% get the result of linear regression
[Y_hat, T, lambda] = ridge_regression_cross_valid(Y, X);

% %% Goodness of fit
GOF = cal_GOF(Y, Y_hat);
%
% %% Sparsity
threshold_list = [0:0.1:1];
density_list = sparsity_density_curve(T, threshold_list);
RDD = sparsity_fitting(density_list, threshold_list, toplot);

%% Deformation
sv = deformation_decay_curve(T);
RDSV = deformation_fitting(sv,toplot);
% TODO: monte carlo simulation and estimate the deformation
