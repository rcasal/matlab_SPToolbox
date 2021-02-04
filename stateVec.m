function [V,N,M]=stateVec(x,m,tau)
% stateVec  
%
% Constructs the state vectors used to calculate the distance matrix for
% the correlation sum.
%  
% Input:
% ^^^^^^
% . x:      Time series.
% . m:      Embedding dimension.
% . tau     Embedding lag.
%
% Output:
% ^^^^^^^
% . V:      Matrix on NxM, each row is a state vector.     
% . N:      Number of state vectors.
% . M       Embedding dimension.
%
%% Author: Juan Felipe Restrepo
N=length(x)-(m-1)*tau;
M=m;
V=zeros(N,M);
k=(m-1)*tau;
for i=1:N
    V(i,:)=x(i:tau:i+k);
end
end









