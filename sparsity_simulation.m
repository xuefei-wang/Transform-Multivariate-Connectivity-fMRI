function [Y_sim, Y_hat, lambda, T, T_hat] = sparsity_simulation(noise_list, sparsity_list, X, num_rpt, Y, GOF_true, RDD_true)
% simulate with Monte Carlo approach


C = {'k','b','r','g','y', 'm', [0.5,0.5,0],[0.5,0,0.5],[0,0.5,0.5],[1,0.5,0.5],[0.5,0.5,1],[0.5,1,0.5]}; % Cell array of colros.
ii = 1;
N_y = size(Y,1);
[N_x, N_s] = size(X);


figure(1);
hold on;
% X = zscore(X,1,1);
t = cputime;
for sparsity = sparsity_list % for each sparsity level
    GOF_mean = []; GOF_std = [];
    RDD_mean = []; RDD_std = [];

    for alp = noise_list % for each noise level
        e = cputime - t;
        disp(['elapsed time: ', num2str(e), ', sparsity: ', num2str(sparsity), ' ,noise: ', num2str(alp)])
        GOF_all = [];
        RDD_all = [];
        for i  = 1:num_rpt % simulate num_rpt times, then take the average

            %
            T = hlp_simulate_T(sparsity, N_y, N_x);
            E = hlp_simulate_E(N_y, N_s);
            % figure;imagesc(T);colorbar;pause;imagesc(E);colorbar;pause;close

            Y_sim = (1 - alp) * T * X / (norm(T) * norm(X)) + alp * E / norm(E);


            Y_sim = zscore(Y_sim,1,1);
            [Y_hat,T_hat,lambda] =  ridge_regression_cross_valid(Y_sim, X);
            % figure;imagesc(Y_sim);colorbar;pause;imagesc(Y_hat);colorbar;pause;close
            % for T_hat:
                GOF = cal_GOF(Y_sim, Y_hat);
                GOF_all = [GOF_all; GOF];

                % sparsity
                threshold_list = [0:0.1:1];
                density_list = sparsity_density_curve(T_hat, threshold_list);
                RDD = sparsity_fitting(density_list, threshold_list, 0);
                RDD_all = [RDD_all; RDD];

        end
        % disp(GOF_all);
        % plot

        GOF_mean = [GOF_mean, mean(GOF_all)]; GOF_std = [GOF_std, std(GOF_all)];
        RDD_mean = [RDD_mean, mean(RDD_all)]; RDD_std = [RDD_std, std(RDD_all)];

        % errorbar(GOF_mean, RDD_mean, RDD_std, 'LineStyle','none');
    end

    [sortedX, sortIndex] = sort(GOF_mean);
    sortedY = RDD_mean(sortIndex);
    plot(sortedX, sortedY, 'color',C{ii},'marker','o');
    % plot(GOF_mean, RDD_mean, 'o')
    ii = ii + 1;
end

plot(GOF_true, RDD_true, 's',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
txt = ['\leftarrow GOF = ', num2str(GOF_true) ', RDD = ', num2str(RDD_true)];
text(GOF_true,RDD_true,txt);

label = arrayfun(@num2str, sparsity_list, 'UniformOutput', false);
legend(label);

hold off;
title('Monte Carlo Simulation - RDD')
% savefig('./output/wenjia.fig')
% save('./output/wenjia.mat')


function T = hlp_simulate_T(sparsity, N_y, N_x)
% standard normal distribution, positions are randomly chosen
T = zeros(N_y, N_x);
msize = numel(T);
vec = randn(1,round(msize * (1 - sparsity)));
T(randperm(msize, round(msize *(1 - sparsity)))) = vec;


function E = hlp_simulate_E(N_y, N_s)
% independent Gaussian noise
E = randn(N_y, N_s);
