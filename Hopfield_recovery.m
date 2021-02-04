function y = Hopfield_recovery(x,W,s)
% Y = Hopfield_recovery(X,W)
% Dado un conjunto de patrones X defectuosos o ruidosos, se recupera el
% patrón fundamental asociado en Y.
% s es la forma de actualizar las salidas de las neuronas. Opciones:
% 'sincrono' y 'asincrono'.

flag = true;
epsilon = 1e-4;             % Tolerancia
iter = 0;
IterM = 100000;

if strcmp(s,'sincrono');
    while flag
        e = sign(x*W);
        y=sign(e);
        iter = iter +1;
        if norm(abs(x-y))<epsilon
            flag=false;
        elseif iter == IterM
            flag = false;
            disp(['No converge luego de ', num2str(iter)]);
        else            
            x=sign(y*W);
            y=sign(x*W);
        end
    end
    
else
    
    n=length(x);                % P cantidad de patrones
    iter =0;
    iter_lastchange = 0;
    % Inicializacion
    y = x;
    
    % Iteracion
    while flag
        y_prev = y;
        j = randperm(n,1);      % Selecciono 1 neurona al azar.
        aux=0;
        for i = 1:n
            aux = aux+W(j,i)*y_prev(i);
        end
        y(j)= sign(aux);
        iter = iter+1;
        
        if y~=y_prev
            iter_lastchange = iter;
        end
        if abs(iter-iter_lastchange)>500
            flag = false;
        elseif iter == IterM
            flag = false;
            disp(['No converge luego de ', num2str(iter)]);
        end
    end
end