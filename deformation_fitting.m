function RDSV = deformation_fitting(sv,toplot)
% fit the rate of decay of the SVs

g = fittype('a*exp(b*x)');
x = [1: length(sv)]'; y = sv;
f0 = fit(x,y,g,'Upper', [Inf,-0.000001]); % set the upper bound so that b is not zero

if(toplot)
    figure();
    plot(x,y,'o',x,f0(x),'r-');
    title('fitted RDSV decay curve')
end
RDSV = f0.b;
