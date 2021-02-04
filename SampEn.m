function [sampEn]=SampEn(x,m,tau,h,varargin)
%APEN Calculates the ApEn.
%
%   sampleEn=sampleEn(x,m,tau,h,varargin)
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
%h=h.^2;
m=[m,m(end)+1];
%-----------------------------------------------------------------------------
% Compute  Phi(h,m,tau) 
Phi_m  = zeros(length(h),length(m)); 
for i=1:length(m)
    for j=1:length(tau)
        
        [D,n]=distanceMatrix(x,m(i),tau(j),dist);  % Distances Vector     
        D=D+D';
        D=D+1000*eye(size(D));                                 % SampEnt
        for k=1:length(h)
            %Phi_m(k,i,j)=mean(log(mean(D<=h(k),2)));   
%              Phi_m(k,i,j)=mean(log(mean(exp(-D./(h(k).^2)),2)));  
          Phi_m(k,i,j)=sum(sum(D<=h(k),2)./(n-1))./n;      % SampEnt
          % Ver paper de Richman, le quita el log de
          % Phi_m(k,i,j)=sum(log(sum(D<=h(k),2)./(n-1)))./n y  en su lugar 
          % cuenta la cantidad de vectores tales que  dist(x_m(j)-x_m(i))<r
          % y luego obtiene su promedio (para cada i). Luego cuenta y
          % promedia a lo largo de i, obteniendo un número. 
        end
    end
end


%-----------------------------------------------------------------------------
% Compute  ApEn(h,m,tau) 
sampEn=log(Phi_m(:,1:end-1,:)./Phi_m(:,2:end,:));
end
