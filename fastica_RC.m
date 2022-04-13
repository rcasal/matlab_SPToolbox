function [W1,W, S_ica,Z] = fastica_RC(X, varargin)
%FastICA - Fast Independent Component Analysis
% [W] = fastica_RC(X) Obtiene los componentes independientes de las mezclas
% X. 
%
% X = Matriz de datos cuyas filas representan las señales observadas.
%
% Z = Matriz de datos blanqueados, luego de hacer z=Q*x.
%
% W = Matriz W tal que ŝ = W*z, siendo z los datos blanqueados.
%
% W1 = Es la matriz obtenida al multiplicar W*Q, siendo Q la matriz de
% blanqueo de datos tal que z=Q*x. Idealmente W1^(-1)*A = W*Q*A = P*D,
% siendo P una matriz de permutación y D una matriz de escalado.
% Si no se realiza blanqueo, W1 = W*Q = W*I = W.
%
% PARAMETROS OPCIONALES
%
% Parámetro                 Valor
%
% 'ic'                      Número de componentes independientes a estimar.
%                           El valor por defecto es la dimensión de los
%                           datos.
%
% 'epsilon'                 Criterio de detención. El valor por defecto es
%                           0.00001.
%
% 'approach'                  Método de ortogonalización utilizado.
%                           Este puede ser ortogonalización deflacionaria
%                           ('defl') o simétrica ('symm'). Por defecto se
%                           utiliza ortogonalización deflacionaria.
%
% 'g'                       Función no lineal utilizada. 
%                           Valor de 'g':      Función utilizada:
%                           'cosh' (default)   g(u)=1/a log cosh(a1*u)
%                           'exp'              g(u)=-exp(-(u).^2 / 2)
%                           'pow3'             g(u)=u^3
%                           'skew'             g(u)=u^2
%
% 'whitening'               Opciones de blanqueo. 'on' y 'off'.
%
% 'maxiter'                 Número máximo de iteraciones. Valor por
%                           defecto: 1000.
%
% 'annot'                   'Informa por consola algunos aspectos relativos
%                           a la convergencia del método. Por defecto
%                           'off'.
%
% Ramiro Casal


[D,N] = size(X);


% Argumentos por defecto

m = D;
epsilon = 0.00001;
approach = 'defl';
func = 'tanh';
whitening = 'on';
maxiter = 1000;
annot = 'off';

% Lectura de argumentos opcionales

if (rem(length(varargin),2)==1)
    error('Los argumentos opcionales deben ser pares');
else
    for i=1:2:(length(varargin)-1)
        switch lower (varargin{i})
            case 'ic'
                m = varargin{i+1};
            case 'epsilon'
                epsilon = varargin{i+1};
            case 'approach'
                approach = lower (varargin{i+1});
            case 'g'
                func = lower(varargin{i+1});
            case 'whitening'
                whitening = lower(varargin{i+1});
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

% Verificación de la orientación de los datos

if D>N
    fprintf('La matriz X puede estar orientada en forma incorrecta.\n')
end


% Whitening de los datos

if strcmp(whitening, 'off')
    Z = X;
    Q = eye(D);
elseif strcmp(whitening,'on')

    % Centering
    
    mu = mean(X,2);
    X = X-repmat(mu,1,N);
    
    % Whitening
    S=zeros(D);
    for n=1:N
        S = S + X(:,n)*X(:,n)';
    end
    S = 1/(N)*S;
    [U,L]=eig(S);
    Q = L^(-0.5)*U';
    Z = Q*X;
end


if strcmp(approach, 'defl')
    
    % ICA deflacionario
    
    for p =1:m
        W(:,p) = rand(D,1);
        W(:,p) = W(:,p)/norm(W(:,p));           % Valor inicial ||wp|| = 1
        flag = true;
        cont = 1;
        while flag
            waux = W(:,p);
            [~,g,dg]=eval_g(W(:,p)'*Z,func);
            W(:,p) = mean(dg)*W(:,p)-mean(Z*diag(g),2);
            % Ortogonalizacion
            for j=1:p-1
                W(:,p)= W(:,p) - (W(:,p)'*W(:,j))*W(:,j);
            end
            W(:,p) = W(:,p)/norm(W(:,p));
            
            cont=cont+1;
            % Criterio de convergencia
            if norm(W(:,p)-waux) < epsilon || norm(W(:,p)+waux) < epsilon
                flag = false;
                if flag_annot
                    disp(['Componente ', num2str(p),...
                        ' satisface tolerancia']);
                end
            elseif cont==maxiter
                flag = false;
                if flag_annot
                    disp(['Componente ', num2str(p), ' alcanzo ',...
                    num2str(maxiter), ' iteraciones']);
                end
            end
        end
    end
	W=W';
    W1 = W*Q; 
    S_ica = W*Z;
    
elseif strcmp(approach, 'symm')
    W = rand(m);
    for p=1:m
        W(:,p) = W(:,p)/norm(W(:,p));           % Valor inicial ||wp|| = 1
    end
    flag = true;
    cont = 1;
    while flag
        Waux = W;
        for p=1:m
            [~,g,dg]=eval_g(W(:,p)'*Z,func);
            W(:,p) = mean(dg)*W(:,p)-mean(Z*diag(g),2);
        end
        % Ortogonalizacion
        W = sqrtm(W*W')\W;
        cont=cont+1;
        % Criterio de convergencia
        if norm(W-Waux) < epsilon || norm(W+Waux) < epsilon
            flag = false;
            if flag_annot
                disp('La matriz W satisface tolerancia');
            end
        elseif cont==maxiter
            flag = false;
            if flag_annot
                disp(['No se alcanzo la tolerancia luego de ',...
                    num2str(maxiter), ' iteraciones']);
            end
        end
    end
    W=W';
    W1 = W*Q; 
    S_ica = W*Z;
else
    printf('Metodo cargado incorrecto.')
end
    
    
end