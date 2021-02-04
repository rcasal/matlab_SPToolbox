function [Xp,mu, l, acc,d] = kmedias(k,X,varargin)
% [mu, Wopt, acc] = kmedias(k,X)
% Los datos obtenidos en X se agrupan en k-clases de manera no supervisada,
% obteniendo como salidas los centroides mu de cada clase, las etiquetas de
% los datos y la precisión alcanzada. El vector d contiene las etiquetas de
% clase. Este vector sólo se utiliza para evaluar el error que comete el
% algoritmo al clasificar. El método no lo utiliza, ya que es aprendizaje
% no supervisado.
% La salida d contiene las etiquetas de las clases luego de que el vector
% fue desordenado.
%
% PARAMETROS OPCIONALES
%
% Parámetro                 Valor
%
% 'labels'                  Etiquetas correspondientes a los grupos. Se
%                           utilizan únicamente para evaluar el desempeño,  
%                           del agrupamiento, ya que el método es no 
%                           supervisado.
%
% 'graphflag'               Opciones para graficar. 0 para no graficar, 1
%                           para graficar. Valor por defecto, 0.
%
% 
% 'fig'                     Indice de la figura en que se graficará.
%



% Valores de variables opcionales por defecto
d=[];
graphflag=0;
fig=[];                     % Da lo mismo el valor, total si graphflag es 
                            % 0 nunca lo usa
acc=[];                     
                            
                            
% Lectura de argumentos opcionales

if (rem(length(varargin),2)==1)
    error('Los argumentos opcionales deben ser pares');
else
    for i=1:2:(length(varargin)-1)
        switch lower (varargin{i})
            case 'labels'
                d = varargin{i+1};
            case 'graphflag'
                graphflag = varargin{i+1};
            case 'fig'
                fig = varargin{i+1};
                
        end
    end
end

% Defino variables necesarias
[F,~] = size(X);
l = ones(F,1);
mu = cell(k,1);
% Formamos k conjuntos aleatorios
ind =randperm(F);
Xp = X(ind,:);              % Mezclo el vector de datos (anteriormente 
                            % estaban ordenadas).

l(ceil(end/2):end)=-1;      % Agrupo aleatoriamente.
Xp = [Xp,l];

% En caso de que se hayan ingresado las labels
if ~isempty(d)
    d(d==2)=-1;
    d = d(ind);
    acc=sum(l==d)/F*100;
end

c = 1;                      % Inicializo cantidad de asignaciones c~=0
iter = 0;
while c~=0
    % Calculo centroides
    mu{1}=mean(Xp(Xp(:,3)==1,1:2));
    mu{2}=mean(Xp(Xp(:,3)==-1,1:2));
    c = 0; iter=iter+1;
    
    
    % Graficas
    if graphflag==1
        figure(fig);
        scatter(Xp(Xp(:,3)==1,1),Xp(Xp(:,3)==1,2),15,'c','fill'); hold on;
        scatter(Xp(Xp(:,3)==-1,1),Xp(Xp(:,3)==-1,2),15,'m','fill');
        scatter(mu{1}(1),mu{1}(2),40,'b','s','fill');
        scatter(mu{2}(1),mu{2}(2),40,'r','s','fill');
        ylim([0 10]); xlim([-4 8]);        
        drawnow;
        pause(0.5)
    end
    
    
    % Reasigno los elementos al centroide mas cercano
    for i=1:F
        if norm(Xp(i,1:2)-mu{1}) < norm(Xp(i,1:2)-mu{2})
            if Xp(i,3)==-1
                Xp(i,3)=1;
                c = c+1;
            end
        else
            if Xp(i,3)==1
                Xp(i,3)=-1;
                c = c+1;
            end
        end
    end
    
    if ~isempty(d)
        l = Xp(:,3);
        acc = [acc, sum(l==d)/F*100];
    end

end

% Corrijo el error por si tomó las etiquetas al revés
if ~isempty(d)
    if acc(end)<60
        acc = 100-acc;
    end
end
