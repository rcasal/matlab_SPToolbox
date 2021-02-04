function [S, S_c] = AutObservMarkov(A,Pi,n)
%[S, S_c] = AutObservMarkov(A,Pi,n) genera n secuencias de salidas a partir del
%modelo generativo basado en autómatas observables de Markov, cuya matriz
%de transición es A y la probabilidad de estado inicial es Pi. Las
%secuencias de salidas se dan codificadas numéricamente y en char.

S = zeros(n,1);                 % Secuencias
S_c = cell(n,1);
% Inicializacion
p = rand;
if p<= Pi(1)
    S(1) = 1;                   % 0.6 Lluvioso
    S_c{1} = 'L';
else
    S(1) = 2;                   % 0.4 Soleado
    S_c{1} = 'S';
end

% Generación de estados

for i=1:n-1
    p=rand;
    if p <= A(S(i),1)
        S(i+1)=1;               % f1: 0.7 Lluvioso; f2: 0.4 Lluvioso
        S_c{i+1} = 'L';
    else
        S(i+1)=2;               % f1: 0.3 Soleado; f2: 0.6 Soleado
        S_c{i+1} = 'S';
    end
end

