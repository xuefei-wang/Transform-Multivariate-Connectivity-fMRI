function [Y_hat, T, lambda] = ridge_regression_cross_valid(Y, X)
% wrapper function to calculate the ridge regression and estimate regularization parameters

% using function from tmullen sift implementation
% Y size: N_y, N_s (#voxel_y, #stimuli)
% X size: N_x, N_s (#voxel_x, #stimuli)
% T size: N_y, N_x

% initialize the external package
addpath ('./external/tmullen-sift/')
out = StartSIFT();
assert(out == 1, 'external package SIFT loading error'); % if fails

[T,lambda,~,Y_hat] = ridge_gcv(Y', X'); % linear regression
T = T'; 
Y_hat = Y_hat';
