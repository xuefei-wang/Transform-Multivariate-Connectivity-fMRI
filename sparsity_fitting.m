function RDD = sparsity_fitting(density_list, threshold_list, toplot)
g = fittype('a*exp(b*x)');
x = threshold_list'; y = density_list';
f0 = fit(x,y, g);

if(toplot)
    figure();
    plot(x,y,'o',x,f0(x),'r-');
    title('fitted density curve')
end
RDD = f0.b;
