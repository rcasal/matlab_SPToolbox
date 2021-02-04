function [A,Pi]=AutObservMarkov_Est(S)
% [A_est,Pi_est]=AutObservMarkov_Est(S)
% A partir de la secuencia S de estados se estiman los parámetros A y Pi
% del modelo observable de Markov.

[L,N]=size(S);          % L longitud de secuencias
                        % N cantidad de secuencias.
                        

A = zeros(2,2);                        
Pi = zeros(1,2);

% Estimo Pi
Pi(1) = sum( S(1,:)==1)/N;
Pi(2) = sum( S(1,:)==2)/N;

% Estimo A
g = A;                  % Contador de transiciones de un estado a otro
for i=1:N
    for j = 2:L         
        if S(j-1,i)==1 && S(j,i) ==1;
            g(1,1) = g(1,1)+1;
        elseif S(j-1,i)==1 && S(j,i) ==2;
            g(1,2) = g(1,2)+1;
        elseif S(j-1,i)==2 && S(j,i) ==1;
            g(2,1) = g(2,1)+1;
        elseif S(j-1,i)==2 && S(j,i) ==2;
            g(2,2) = g(2,2)+1;
        end
    end
end
G1 = sum(sum(S(1:L-1,:)==1));    % Cantidad de veces que estuvo en estado 1
G2 = sum(sum(S(1:L-1,:)==2));    % Cantidad de veces que estuvo en estado 2

A(1,1) = g(1,1) / G1;
A(1,2) = g(1,2) / G1;
A(2,1) = g(2,1) / G2;
A(2,2) = g(2,2) / G2;        