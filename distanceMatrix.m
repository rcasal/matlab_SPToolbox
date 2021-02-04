function [D,n]=distanceMatrix(x,m,tau,dist)
% distanceMatrix
%
% Distance Matrix 
%
% This function returns the distance matrix used to calculate the 
% correlation integral.
% 
% Given a time series of data x(i) i=1,2,...,N. It forms a sequence
% of vectors Y_{j}, j= 1,2...,(N-m)/tau, each of this vectors has m 
% length and is spaced tau units from the previous vector.
%
% Then the distance between all vectors is calculated to form an nxn
% matrix (n=(N-m0)/tau). This is a symmetric matrix, for that reason
% it could be represented by a upper triangular matrix.   
%
% This algorithm uses the inf norm to calculate the distance between
% vectors.
%
% Input:
% ^^^^^^
% . x               Time series.   
% . m               Embedding dimension.
% . tau             Embedding lag.
% . dist            Distance: 0 for Inf. Distance
%                             1 for Euclidean Distance.
%
% Output:
% ^^^^^^^
% . D               Distance matrix.  
% . n               Number of rows in the distance matrix. 
%
%-----------------------------------------------------------------------------------
% Juan Felipe Restrepo. 
% jrestrepo@bioingenieria.edu.ar
% 2014-02-24  
%-----------------------------------------------------------------------------------

[y,n]=stateVec(x,m,tau);
D=zeros(n);

for k=0:n-1
    z = distance(y(1:n-k,:)',y(k+1:n,:)',dist);
    i = (1:n-k)';
    j = i+k;
    D(sub2ind([n n],i,j))=z;
end

end
%=================================================================================
% Calculate Distance 
%=================================================================================
function z=distance(y1,y2,dist)
if (dist)
    z = dot(y1,y1,1)+dot(y2,y2,1)-2*dot(y1,y2,1);
    % z = sqrt(z);
else
    z = max(abs(y1-y2),[],1)';    % Inf distance.
end
end

