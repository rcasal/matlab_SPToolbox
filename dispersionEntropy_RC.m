function [de,nde,hist] = dispersionEntropy_RC(x,m,d,c)
%function [de,nde,hist] = dispersionEntropy_RC(x,m,d,c)
% Se calcula la entropía de dispersion para una dimensión de inmersión m, 
% con tiempo de retardo d y c clases de la serie temporal x. 
% 
% d es el paso que se da entre los elementos consecutivos del subconjunto
% formado. Ej para m=3: X_i = {X(i),x(i+L), x(i+L*2) }
%
% Ref. Rostaghi y Azami. Dispersion Entropy: A Measure for Time Series 
% Analysis

n = length(x);

sigma_x=std(x);
mu_x=mean(x);
y=normcdf(x,mu_x,sigma_x);
z= round(c*y+0.5);

dispPattern= permn(1:c,m);
nPermut = length(dispPattern);
hist(1:nPermut)=0;

for i=1:n-d*(m-1)
    Z_i = z( i:d:i+d*(m-1) );
    ind=sum(abs(repmat(Z_i,size(dispPattern,1),1)-dispPattern),2)...
        ==0;                % Da 1 en la fila que coincide, 0 en las demás
    hist(ind) = hist(ind) +1;
end

p = hist/(sum(hist));
% p = p(p~=0);
p(p==0)=1;
de = -sum(p.*log(p));

if isnan(de)
    de=0;           % Si da NaN es porque la señal es cte, por que la 
                    % función y es igual a 1 en todos sus elementos,
                    % entonces la función z da igual a c+1. Al comparar los
                    % patrones no encuentra ninguno, porque no está dentro
                    % de los patrones posibles y da NaN. Así lo soluciono.
end

nde = de/log(c^m);
