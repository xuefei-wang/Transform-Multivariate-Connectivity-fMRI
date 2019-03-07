function step3(X, Y, GOF, RDSV)
% monte carlo simulation and estimate the deformation degree
num_rpt = 2;
noise_list = 0.05:0.05:0.6;
decay_rate_list = 0.1:0.1:0.9;

[Y_sim_mc, Y_hat_mc, lambda_mc, T_mc, T_hat_mc] = deformation_simulation(noise_list, decay_rate_list, X, num_rpt, Y, GOF, RDSV);
