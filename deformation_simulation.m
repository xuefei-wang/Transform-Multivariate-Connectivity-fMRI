function [Y_sim, Y_hat, lambda, T, T_hat] = deformation_simulation(noise_list, decay_rate_list, X, num_rpt, N_y)
% simulate with Monte Carlo approach


C = {'k','b','r','g','y'}; % Cell array of colros.
ii = 1;
[N_x, N_s] = size(X);
figure;
hold on;


for rate = decay_rate_list
    GOF_mean = []; GOF_std = [];
    RDSV_mean = []; RDSV_std = [];

    for alp = noise_list

        GOF_all = [];
        RDSV_all = [];
        for i  = 1:num_rpt

            T = hlp_simulate_T(rate, N_y, N_x);
            E = hlp_simulate_E(N_y, N_s);

            Y_sim = (1 - alp) * T * X / (norm(T) * norm(X)) + alp * E / norm(E);

            X = zscore(X);
            Y_sim = zscore(Y_sim);
            [Y_hat,T_hat,lambda] = ridge_regression_cross_valid(Y_sim, X);

            % for T_hat:
                GOF = cal_GOF(Y_sim, Y_hat);
                GOF_all = [GOF_all; GOF];

                % sparsity
                threshold_list = [0:0.1:1];
                sv = deformation_decay_curve(T_hat);
                RDSV = deformation_fitting(sv, 0);
                RDSV_all = [RDSV_all; RDSV];

        end
        disp(size(RDSV_all));
        % plot

        GOF_mean = [GOF_mean, mean(GOF_all)]; GOF_std = [GOF_std, std(GOF_all)];
        RDSV_mean = [RDSV_mean, mean(RDSV_all)]; RDSV_std = [RDSV_std, std(RDSV_all)];

        % errorbar(GOF_mean, RDSV_mean, RDSV_std, 'LineStyle','none');
    end

    [sortedX, sortIndex] = sort(GOF_mean);
    sortedY = RDSV_mean(sortIndex);
    plot(GOF_mean, RDSV_mean, 'color',C{ii},'marker','o');
    ii = ii + 1;
end

hold off;
title('Monte Carlo Simulation')

function T = hlp_simulate_T(rate, N_y, N_x)
% standard normal distribution, positions are randomly chosen
% T = zeros(N_y, N_x);
% msize = numel(T);
% vec = randn(1,int8(msize * (1 - sparsity)));
% T(randperm(msize, int8(msize *(1 - sparsity)))) = vec;
%TODO

function E = hlp_simulate_E(N_y, N_s)
% independent Gaussian noise
E = rand(N_y, N_s);
