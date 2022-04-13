function [U,V,D] = NMF_RC(A, varargin)
%NMF - Non-negative matrix factorization
% [U,V] = NMF_RC(A) Factoriza la matriz A en dos matrices no negativas U y
% V.
%
% PARAMETROS OPCIONALES
%
% Parámetro                 Valor
%
% 'k'                       Dimension de columnas de U y filas de V. Valor
%                           por defecto k= min(m,n)/50.
% 'epsilon'                 Criterio de detención. El valor por defecto es
%                           0.01.
%
% 'maxiter'                 Número máximo de iteraciones. Valor por
%                           defecto: 500.
%
% 'annot'                   'Informa por consola algunos aspectos relativos
%                           a la convergencia del método. Por defecto
%                           'off'.
%
% Ramiro Casal


[m,n] = size(A);


% Argumentos por defecto

k = floor(min(m,n)/50);
epsilon = 0.01;
maxiter = 500;
annot = 'off';

% Lectura de argumentos opcionales

if (rem(length(varargin),2)==1)
    error('Los argumentos opcionales deben ser pares');
else
    for i=1:2:(length(varargin)-1)
        switch lower (varargin{i})
            case 'k'
                k = varargin{i+1};
            case 'epsilon'
                epsilon = varargin{i+1};
            case 'annot'
                annot = lower(varargin{i+1});
            case 'maxiter'
                maxiter = varargin{i+1};
            otherwise
                error(['Parámetro' '' varargin{i} '' 'no reconocido']);
        end
    end
end

if strcmp(annot, 'off')
    flag_annot = false;
else
    flag_annot = true;
end

% Inicializo
U = rand(m,k);
V = rand(k,n);

flag = true;
cont = 1;
while flag
    auxU = U;
    auxV = V;
    
    U=auxU.*(A*V')./(auxU*V*V');
    U = U/norm(U);
    V = auxV.*(U'*A)./(U'*U*auxV);
    
    cont=cont+1;
    % Criterio de convergencia
    D = norm(A-U*V,'fro')/sqrt(n*m);
    if D<epsilon
        flag = false;
        if flag_annot
            disp(['Alcanzo convergencialuego de ', ...
                num2str(cont),' iteraciones']);
        end
    elseif cont==maxiter
        flag = false;
        if flag_annot
            disp(['No alcanzo convergencia luego de ', ...
                num2str(maxiter),' iteraciones']);
        end
    end
end

end