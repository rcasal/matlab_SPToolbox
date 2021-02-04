function [Y,S,U,L] = pca_RC(X)
%PCA - Principal Component Analysis
% [Y,S,U,L] = pca_RC(X)
%
% Y = Datos proyectados
% X = Matriz de datos cuyas filas representan las variables aleatorias y 
% sus columnas representan las observaciones.
% S = Matriz de covarianza de los datos proyectados
% U = Matriz cuyas columnas son los autovectores de S ordenados en forma
% decreciente según sus autovalores asociados.
% L = Matriz diagonal de autovalores.
%
% Ramiro Casal

[D,N] = size(X);
mu = mean(X,2);

S=zeros(D);
for n=1:N
    S = S + (X(:,n)-mu)*(X(:,n)-mu)';
end
S = 1/(N)*S;
[U,L]=eig(S);
[~,I]=sort(diag(L),'descend');
L = L(I,I);
U = U(:,I);
Y = U'*X;


end