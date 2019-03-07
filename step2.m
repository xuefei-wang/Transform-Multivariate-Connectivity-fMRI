function step2(X, Y, GOF, RDD)
% monte carlo simulation and estimate the sparsity
num_rpt = 1;
noise_list = 0.05:0.05:0.6;
sparsity_list = 0.1:0.1:0.9;

[Y_sim_mc, Y_hat_mc, lambda_mc, T_mc, T_hat_mc] = sparsity_simulation(noise_list, sparsity_list, X, num_rpt, Y, GOF, RDD)
