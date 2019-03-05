function density_list = sparsity_density_curve(T, threshold_list)
% calculate the density curve
% threshold_list, an array of values to be tested as threshold [0, 1]

T_norm = T ./ max(max(abs(T))); % normalize T by its maximum absolute value

[N_y, N_x] = size(T);

density_list = [];
for threshold = threshold_list
    d = sum(sum(T_norm > threshold)) / (N_x * N_y);
    density_list = [density_list, d];
end
%
% figure();
% plot(threshold_list, density_list, '-o');
% title('density curve');
