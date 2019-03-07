There are three steps to this approach.
First, run step1, to calculate 'GOF', 'RDD', 'RDSV' respectively:
```
[T, GOF, Y_hat, lambda, density_list, RDD, sv, RDSV] =  step1(Y, X, toplot)

Input X Y should be in the format of (#voxels, #stimuli)
toplot = 0: do not plot, 1: plot

please check the fitting curve are correct.

Second, run step2, to obtain the GOF-RDD curve using monte carlo simulation approach, and estimate 'Sparsity':
```
step2(X, Y, GOF, RDD)

You need to specify the parameters in the 'step2.m' file:
num_rpt :number of repeats, 1000 for final result, 100-200 if you'd like to check the result in half an hour.
noise_list, sparsity_list: test and find the appropriate range so that our true GOF/RDD can fall into that range.

Third, run step3, to obtain the GOF-RDSV curve using monte carlo simulation approach, and estimate 'Deformation':
```
step3(X, Y, GOF, RDSV)

the same as step2
