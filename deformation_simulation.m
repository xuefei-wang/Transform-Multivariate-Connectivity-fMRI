function [Y_sim, Y_hat, lambda, T, T_hat] = deformation_simulation(noise_list, decay_rate_list, X, num_rpt, Y, GOF_true, RDSV_true)
% simulate with Monte Carlo approach


C = {'k','b','r','g','y', 'm', [0.5,0.5,0],[0.5,0,0.5],[0,0.5,0.5],[1,0.5,0.5],[0.5,0.5,1],[0.5,1,0.5]}; % Cell array of colros.
ii = 1;
N_y = size(Y,1);
[N_x, N_s] = size(X);


figure(1);
hold on;
% X = zscore(X,1,1);
t = cputime;
for rate = decay_rate_list % for each decay rate level level
    GOF_mean = []; GOF_std = [];
    RDSV_mean = []; RDSV_std = [];

    for alp = noise_list % for each noise level
        e = cputime - t;
        disp(['elapsed time: ', num2str(e), ', deformation: ', num2str(rate), ' ,noise: ', num2str(alp)])
        GOF_all = [];
        RDSV_all = [];
        for i  = 1:num_rpt % simulate num_rpt times, then take the average


            T = hlp_simulate_T(rate, N_y, N_x);
            E = hlp_simulate_E(N_y, N_s);
            % figure;imagesc(T);colorbar;pause;imagesc(E);colorbar;pause;close

            Y_sim = (1 - alp) * T * X / (norm(T) * norm(X)) + alp * E / norm(E);

            Y_sim = zscore(Y_sim,1,1);
            [Y_hat,T_hat,lambda] =  ridge_regression_cross_valid(Y_sim, X);
            % figure;imagesc(Y_sim);colorbar;pause;imagesc(Y_hat);colorbar;pause;close
            % for T_hat:
                GOF = cal_GOF(Y_sim, Y_hat);
                GOF_all = [GOF_all; GOF];

                % deformation

                sv = deformation_decay_curve(T_hat);
                RDSV = deformation_fitting(sv, 0);
                RDSV_all = [RDSV_all; RDSV];

        end
        % disp(GOF_all);
        % plot

        GOF_mean = [GOF_mean, mean(GOF_all)]; GOF_std = [GOF_std, std(GOF_all)];
        RDSV_mean = [RDSV_mean, mean(RDSV_all)]; RDSV_std = [RDSV_std, std(RDSV_all)];

        % errorbar(GOF_mean, RDSV_mean, RDSV_std, 'LineStyle','none');
    end

    [sortedX, sortIndex] = sort(GOF_mean);
    sortedY = RDSV_mean(sortIndex);
    plot(sortedX, sortedY, 'color',C{ii},'marker','o');
    % plot(GOF_mean, RDSV_mean, 'o')
    ii = ii + 1;
end

plot(GOF_true, RDSV_true, 's',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
txt = ['\leftarrow GOF = ', num2str(GOF_true) ', RDSV = ', num2str(RDSV_true)];
text(GOF_true,RDSV_true,txt);

label = arrayfun(@num2str, decay_rate_list, 'UniformOutput', false);
legend(label);

hold off;
title('Monte Carlo Simulation - RDSV')
% savefig('./output/wenjia.fig')
% save('./output/wenjia.mat')


function T = hlp_simulate_T(rate, N_y, N_x)
% standard normal distribution, positions are randomly chosen
M = randn(N_y, N_x);
sv = svd(M);
[U,S,V] = svd(M);
S = padarray(diag(exp(rate * [1:length(sv)])), [N_y - length(sv), N_x - length(sv)], 'post');
T = U*S*V;

function E = hlp_simulate_E(N_y, N_s)
% independent Gaussian noise
E = randn(N_y, N_s);
