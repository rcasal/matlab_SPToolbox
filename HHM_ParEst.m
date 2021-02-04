function [A,B,Pi]=HHM_ParEst(X,Q)
% [A,Pi]=HHM_ParEst(S
% A partir de las secuencias de estados Q y las secuencias de salida X se 
% estiman los parámetros A, B y Pi del modelo oculto de Markov que generó 
% las secuencias.

[T,N]=size(X);                  % L longitud de secuencias
                                % N cantidad de secuencias.

% N_p = length(unique(X));   % Cantidad de salidas posibles                        
% N_s = length(unique(Q));   % Cantidad de estados posibles
N_p = 3;
N_s = 2;
A = zeros(N_s);                        
Pi = zeros(1,N_s);
B = zeros(N_p,N_s);

% Estimo Pi
for i=1:N_s
    Pi(i) = sum( Q(1,:)==i)/N;
end

% Estimo A
for i=1:N
    for j = 2:T         
        if Q(j-1,i)==1 && Q(j,i) ==1;
            A(1,1) = A(1,1)+1;
        elseif Q(j-1,i)==1 && Q(j,i) ==2;
            A(1,2) = A(1,2)+1;
        elseif Q(j-1,i)==2 && Q(j,i) ==1;
            A(2,1) = A(2,1)+1;
        elseif Q(j-1,i)==2 && Q(j,i) ==2;
            A(2,2) = A(2,2)+1;
        end
    end
end
G1 = sum(sum(Q(1:T-1,:)==1));    % Cantidad de veces que estuvo en estado 1
G2 = sum(sum(Q(1:T-1,:)==2));    % Cantidad de veces que estuvo en estado 2

if G1~=0
    A(1,1) = A(1,1) / G1;
    A(1,2) = A(1,2) / G1;
end
if G2~=0
    A(2,1) = A(2,1) / G2;
    A(2,2) = A(2,2) / G2;
end

% Estimo B

for i=1:N
    for j=1:T
        if strcmp(X{j,i},'W') && Q(j,i) == 1
            B(1,1) = B(1,1)+1;
        elseif strcmp(X{j,i},'B') && Q(j,i) == 1
            B(2,1) = B(2,1)+1;
        elseif strcmp(X{j,i},'M') && Q(j,i) == 1
            B(3,1) = B(3,1)+1;
        elseif strcmp(X{j,i},'W') && Q(j,i) == 2
            B(1,2) = B(1,2)+1;
        elseif strcmp(X{j,i},'B') && Q(j,i) == 2
            B(2,2) = B(2,2)+1;
        elseif strcmp(X{j,i},'M') && Q(j,i) == 2
            B(3,2) = B(3,2)+1;
        end
    end
end

G1 = sum(sum(Q==1));    % Cantidad de veces que estuvo en estado 1
G2 = sum(sum(Q==2));    % Cantidad de veces que estuvo en estado 2
if G1~=0
    B(1,1) = B(1,1) / G1;
    B(2,1) = B(2,1) / G1;
    B(3,1) = B(3,1) / G1;
end
if G2~=0
    B(1,2) = B(1,2) / G2;
    B(2,2) = B(2,2) / G2;
    B(3,2) = B(3,2) / G2;
end

end