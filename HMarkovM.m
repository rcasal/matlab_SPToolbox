function X = HMarkovM(A,B,Pi,n)
%X = HMarkovM(A,B,Pi,n) genera n secuencias de salidas a partir del
%modelo generativo basado en modelos ocultos de Markov, cuya matriz
%de transición es A, la matriz de emisiones es B y la probabilidad de 
% estado inicial es Pi. 

Q = zeros(n,1);                 % Secuencias
X = cell(n,1);
% Inicializacion
p = rand;
if p<= Pi(1)
    Q(1) = 1;                   % 0.6 Lluvioso
    p = rand;
    if p<=B(1,1)
        X{1} = 'L';
    else
        X{1} = 'S';
    end
else
    Q(1) = 2;                   % 0.4 Soleado
    p = rand;
    if p<=B(1,2)
        X{1} = 'L';
    else
        X{1} = 'S';
    end
end

% Generación de estados

for i=1:n-1
    p=rand;
    if p <= A(Q(i),1)
        Q(i+1)=1;               % f1: 0.7 Lluvioso; f2: 0.4 Lluvioso
        p=rand;
        if p<B(1,Q(i))
            X{i+1} = 'L';
        else
            X{i+1} = 'S';
        end

    else
        Q(i+1)=2;               % f1: 0.3 Soleado; f2: 0.6 Soleado
        p=rand;
        if p<B(1,Q(i))
            X{i+1} = 'L';
        else
            X{i+1} = 'S';
        end
    end
end
