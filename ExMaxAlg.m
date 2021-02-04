function [Aprev,Bprev,Piprev]=ExMaxAlg(X,S)
% [A,B,Pi]=ExMaxAlg(X) 
% Implementa el algoritmo de maximización de la
% esperanza para encontrar los parámetros del modelo oculto de Markov que
% generó la secuencia de salida X.

e = 1e-7;                       % Criterio de salida del error
flag = true;
MaxIter = 1000;
iter = 0;

[T,N] = size(X);                % N cantidad de secuencias
                                % T longitud de las secuencias
N_s = length(S);                % Cantidad de estados posibles
N_p = length(unique(X(:,1)));   % Cantidad de salidas posibles

% 1.Inicializo al azar
p11=rand*0.75; p22=rand*0.75;
Aprev = [p11 1-p11; 1-p22 p22]; clear p11 p22;
p1=rand*0.75; Piprev = [p1 1-p1]; clear p;
p11=rand*0.75; p22=rand*0.75; p32=rand*0.75;
Bprev = [p11 1-p11; 1-p22 p22; 1-p32 p32]; clear p11 p22;

% Aprev = [0.69 0.31; 0.41 0.59];
% Bprev = [0.09 0.61; 0.41 0.29; 0.5 0.1];
% Piprev = [0.61 0.39];

while flag
    iter = iter +1;
    % 2. Secuencia más probable
    Q = zeros(T,N);            % Secuencia de estados más probable (Viterbi);
    for i = 1:N
        [~,Q(:,i)] = viterbi(Aprev,Bprev,Piprev,X(:,i),S);
    end
    
    % 3. Estimo A, B y Pi
    [A,B,Pi]=HHM_ParEst(X,Q);
    
    if ( norm(A-Aprev,1) +norm(B-Bprev,1) + norm(Pi-Piprev,1) ) < e 
        flag=false;
    elseif iter==MaxIter
        flag = false;
        disp(['No converge luego de ',num2str(iter)]);
    else
        Aprev = A;
        Bprev = B;
        Piprev = Pi;
    end
        
end
