function [Best_Score,Q] = viterbi(A,B,Pi,X, S)
% q = viterbi(A,B,Pi,X) 
% Obtiene la secuencia de estados más probable a
% partir de la matriz de transiciones A, la matriz de observación B, la
% matriz de inicio Pi, la secuencia de salidas X y el espacio de estados S.

T = length(X);                  % Longitud de la secuencia
[N_p, N_s] = size(B);           % N_p: Cantidad de salidas posibles
                                % N_s: Cantidad de estados posibles
T1 = zeros(N_s,T);
T2 = T1;
Q = zeros(T,1);
Z = zeros(T,1);
auxW = double(strcmp(X,'W'));
auxB = double(strcmp(X,'B'))*2;
auxM = double(strcmp(X,'M'))*3;
Xn = auxW + auxB + auxM;        % Codifico numéricamente las salidas para 
                                % indexado.                       
clear auxW auxB auxM;                                

% Inicializacion
for i=1:N_s
    T1(i,1) = (Pi(i)*B(Xn(1),i));       
    T2(i,1) = 0;
end

% Iteracion
for i=2:T
    for j=1:N_s
        [T1(j,i),T2(j,i)] = max(T1(:,i-1).*A(:,j));
        T1(j,i) = T1(j,i)*B(Xn(i),j);
    end
end

% Terminacion wiki
% [Best_Score,Z(end)] = max(T1(:,end));
% Q(end) = S(Z(end));
% 
% for i=T:-1:2
%     Z(i-1) = T2(Z(i),i);
%     Q(i-1) = S(Z(i-1));
% end

% Terminacion
Best_Score = max(T1(:,end));
[~,Q(end)] = max(T2(:,end));

% Backtracking
for i=T-1:-1:1
    Q(i) = T2(Q(i+1),i+1); 
end

end


