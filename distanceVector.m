function [D,Q]=distanceVector(x,m,tau,Tn)
% DISTANCEVECTOR Computes the distances between state vectors.
% 
% [D,Q]= DISTANCEVECTOR(x,m,tau,Tn)
%
% This function returns the squared distance vector used to calculate the 
% U-correlation integral.
% 
% Given a time series of data x(i) i=1,2,...,N. It forms a sequence
% of m-dimensional vectors Vj=[x(j),x(j+tau),...,x(j+(m-1)tau)] where 
% j= 1,2...,N-(m-1)tau.
%
% Then the squared euclidean distance between vectors is calculated excluding 
% the Tn closest neighbors (temporal neighbors).
%
% Inputs:
% - x: Time series.   
% - m: Embedding dimension.
% - tau: Embedding lag.
% - Tn: Number of temporal neighbors to be discard. 
%
% Output:
% - D: Distances vector.  
% - Q: Number of distances between state vectors. 
%
% Copyright Juan Felipe Restrepo, <jrestrepo@bioingenieria.edu.ar>, 2016-10-05  
%-------------------------------------------------------------------------------

if(length(x)<(m-1)*tau)
   error('N<(m-1)*tau'); 
end
[V,L]=stateVec(x,m,tau);
D=zeros((L-Tn)*(L-Tn-1)/2,1);

K=Tn+1:L-1;
ind1=L-K;
ind2=K+1;
ind=[0,cumsum(ind1(1:end))];
% Compute distances
for k=1:L-1-Tn
    D((ind(k)+1:ind(k+1)))=...
        dot(V(1:ind1(k),:)',V(1:ind1(k),:)',1)+...
        dot(V(ind2(k):L,:)',V(ind2(k):L,:)',1)...
        -2*dot(V(1:ind1(k),:)',V(ind2(k):L,:)',1);
end
Q=length(D);
end
