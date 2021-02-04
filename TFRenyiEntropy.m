function [tfre] = TFRenyiEntropy_RC(p,q)

[N,M] = size(p);

p = p/sum(sum(p));

if q==1         % Shannon (solo si p no toma valores negativos)
        tfre = -sum(p(p>0)*log2(p(p>0))');
else
        tfre = 1/(1-q)* log2(sum(sum(p.^q)));
end
    
%     
% else                % continuous
%     [p,c] = ksdensity(x,'NumPoints',npoints); 
%     dx = c(end)-c(end-1);
%     if q==1         % Entropía diferencial de Shannon
%         tfre = -sum(p(p>0)*log(p(p>0))'*dx);
%     else
%         tfre = 1/(1-q)* log(sum(p.^q)*dx);
%     end
% end
