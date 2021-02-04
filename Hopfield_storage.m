function W = Hopfield_storage(X)
%W = Hopfield_storage(X)
% Se almacenan en una red de Hopfield las memorias fundamentales X.

[m, n]=size(X);             % m cantidad de memorias fundamentales
                            % n dimensión de memorias fundamentales
    
W=zeros(n);
for i = 1:m
    W = W + X(i,:)'*X(i,:);
    W = W - eye(n);         % Al ser variables binarias, xk*xk = 1. 
                            % Restando 1 a los elementos de la diagonal
                            % aseguro que wij = 0 cuando i = j.
end
W = 1/m*W;

% Lo mismo calculado elemento a elemento
% for k=1:m
%     for i=1:n
%         for j=1:n
%             if i~=j
%                 W(i,j) = W(i,j) + 1/m *X(k,i)*X(k,j);
%             end
%         end
%     end
% end

% Capacidad del sistema
[N,~] = size(W);
P_max = N/(2*log(N));
disp(['La capacidad de almacemiento del sistema es ',...
    num2str(floor(P_max))]);