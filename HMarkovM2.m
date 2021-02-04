function [X,Q] = HMarkovM2(A,B,Pi,n)
%X = HMarkovM(A,B,Pi,n) genera n secuencias de salidas a partir del
%modelo generativo basado en modelos ocultos de Markov, cuya matriz
%de transición es A, la matriz de emisiones es B y la probabilidad de 
% estado inicial es Pi. 

Q = zeros(n,1);                 % Secuencias
X = cell(n,1);

% Inicializacion
p = rand;
if p<= Pi(1)                    % 0.6 Lluvioso
    Q(1) = 1;                   
else                            % 0.4 Soleado
    Q(1) = 2;                   
end

p=rand;             % Primera emisión
if p<=B(1,Q(1))
    X{1} = 'W';                         % Walk
elseif p<=(B(2,Q(1))+B(1,Q(1))) && p>=B(1,Q(1))
    X{1} = 'B';                         % Buy
else
    X{1} = 'M';                         % Museum
end

% Generación de estados
for i=1:n-1
    p=rand;
    if p <= A(Q(i),1)
        Q(i+1)=1;               % f1: 0.7 Lluvioso; f2: 0.4 Lluvioso
    else
        Q(i+1)=2;               % f1: 0.3 Soleado; f2: 0.6 Soleado
    end
    
    p=rand;
    if p<B(1,Q(i+1))
        X{i+1} = 'W';
    elseif p<=(B(2,Q(i+1))+B(1,Q(i+1))) && p>=B(1,Q(i+1))
        X{i+1} = 'B';
    else
        X{i+1} = 'M';
    end
end