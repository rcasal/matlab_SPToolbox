function [ApEn]=apen(x,m,tau,h,varargin)
%APEN Calculates the ApEn.
%
%   ApEn = apen(x,m,tau,h,varargin)
%
% This function calculates the U-correlation integral. 
%
% Inputs: 
%  - x:   Time series.
%  - m:   Embedding dimension.
%  - tau: Embedding lag.
%  - h:   Escale.
%
%
% Juan Felipe Restrepo, <jrestrepo@bioingenieria.edu.ar>, 2016-10-05  
%-------------------------------------------------------------------------------
% Default parameters
dist=0;
%-------------------------------------------------------------------------------
% Input parsing
if sum(m<=0)>0
    error('m must be grater than 0');
end

if sum(tau<1)>0
    error('tau must be grater than 0');
end
if sum(h<0)>0
    error('h must be grater than 0');
end
nVarargs = length(varargin);
if nVarargs
    if mod(nVarargs,2)~=0
        error('Optional input without value');
    else
        if strcmp(varargin{1},'dist')
            dist=varargin{2};
        end
    end
end

x=x(:);    
% h=h.^2;
m=[m,m(end)+1];
%-----------------------------------------------------------------------------
% Compute  Phi(h,m,tau) 
for i=1:length(m)
    for j=1:length(tau)
        
        [D,n]=distanceMatrix(x,m(i),tau(j),dist);  % Distances Vector     
        D=D+D';

        for k=1:length(h)       %parfor
            %Phi_m(k,i,j)=mean(log(mean(D<=h(k),2)));   
             Phi_m(k,i,j)=mean(log(mean(exp(-D./(h(k).^2)),2)));  
             
             % El D no esta al cuadrado porque la función distance matrix
             % tiene comentado la linea sqrt.
        end
    end
end
%-----------------------------------------------------------------------------
% Compute  ApEn(h,m,tau) 
ApEn=Phi_m(:,1:end-1,:)-Phi_m(:,2:end,:);
end
