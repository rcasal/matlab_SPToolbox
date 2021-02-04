function [l, acc] = knn_RC(X,d,T,dt,k)
% function [Yopt, Wopt, acc] = knn_RC(X,d,T,dt)
% A partir del conjunto de ejemplos X con sus correspondientes etiquetas d,
% probamos los puntos T. Contamos con las etiquetas dt del conjunto test
% con el objetivo de encontrar la precisión alcanzada.

[Fe,~] = size(X);           % Dimension de los datos de ejemplo
[Ft,~] = size(T);           % Dimension de los datos de testeo
D = zeros(Fe,1);            % Distancias a los elementos
l = zeros(Ft,1);            % Vector de salida con etiquetas
for i=1:Ft
    % Calculo de las distancias de cada punto a los ejemplos
   for j=1:Fe
       D(j) = norm(X(j,1:2)-T(i,1:2))^2;
   end
   % Ordeno el vector de distancias
   [D,ind]= sort(D);
   neighClass = d(ind(1:k));
   
   % Votacion
   if sum(neighClass==1) > sum(neighClass==2);
       l(i)=1;
   else
       l(i)=2;
   end
end

% Calculo el porcentaje de aciertos
acc=sum(l==dt)/Ft*100;
end

