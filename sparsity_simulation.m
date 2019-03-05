function [Y_sim, Y_hat, lambda, T, T_hat] = sparsity_simulation(noise_list, sparsity_list, X, num_rpt, N_y, GOF_true, RDD_true)
% simulate with Monte Carlo approach


C = {'k','b','r','g','y', 'm'}; % Cell array of colros.
ii = 1;
[N_x, N_s] = size(X);
figure;
hold on;
X = zscore(X);

for sparsity = sparsity_list
    GOF_mean = []; GOF_std = [];
    RDD_mean = []; RDD_std = [];

    for alp = noise_list

        GOF_all = [];
        RDD_all = [];
        for i  = 1:num_rpt

            T = hlp_simulate_T(sparsity, N_y, N_x);
            E = hlp_simulate_E(N_y, N_s);

            Y_sim = (1 - alp) * T * X / (norm(T) * norm(X)) + alp * E / norm(E);


            Y_sim = zscore(Y_sim);
            [Y_hat,T_hat,lambda] = ridge_regression_cross_valid(Y_sim, X);

            % for T_hat:
                GOF = cal_GOF(Y_sim, Y_hat);
                GOF_all = [GOF_all; GOF];

                % sparsity
                threshold_list = [0:0.1:1];
                density_list = sparsity_density_curve(T_hat, threshold_list);
                RDD = sparsity_fitting(density_list, threshold_list, 0);
                RDD_all = [RDD_all; RDD];

        end
        disp(size(RDD_all));
        % plot

        GOF_mean = [GOF_mean, mean(GOF_all)]; GOF_std = [GOF_std, std(GOF_all)];
        RDD_mean = [RDD_mean, mean(RDD_all)]; RDD_std = [RDD_std, std(RDD_all)];

        % errorbar(GOF_mean, RDD_mean, RDD_std, 'LineStyle','none');
    end

    [sortedX, sortIndex] = sort(GOF_mean);
    sortedY = RDD_mean(sortIndex);
    plot(sortedX, sortedY, 'color',C{ii},'marker','o');
    ii = ii + 1;
end

plot(GOF_true, RDD_true, 's',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
txt = ['\leftarrow GOF = ', num2str(GOF_true) ', RDD = ', num2str(RDD_true)];
text(GOF_true,RDD_true,txt);

hold off;
title('Monte Carlo Simulation')
% savefig('./output/wenjia.fig')
% save('./output/wenjia.mat')


function T = hlp_simulate_T(sparsity, N_y, N_x)
% standard normal distribution, positions are randomly chosen
T = zeros(N_y, N_x);
msize = numel(T);
vec = randn(1,int8(msize * (1 - sparsity)));
T(randperm(msize, int8(msize *(1 - sparsity)))) = vec;


function E = hlp_simulate_E(N_y, N_s)
% independent Gaussian noise
E = rand(N_y, N_s);
