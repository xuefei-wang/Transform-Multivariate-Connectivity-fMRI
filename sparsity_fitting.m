function RDD = sparsity_fitting(density_list, threshold_list, toplot)
% fitting the 'threshold-density' curve, and use the coefficient 'b' as RDD

g = fittype('a*exp(b*x)');
x = threshold_list'; y = density_list';
f0 = fit(x,y, g);

if(toplot) % if plot is needed
    figure();
    plot(x,y,'o',x,f0(x),'r-');
    title('fitted density curve')
end
RDD = f0.b;
