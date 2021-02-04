function [Yopt, Wopt, acc] = PerceptronSimple(X,d,graphflag,fig)
% [Yopt, Wopt, acc] = PerceptronSimple(X,d)
% A partir del vector de características X y la salida deseada d, se
% obtiene la salida del perceptrón simple Yopt, el vector de pesos Wopt y 
% la precisión con que se realizó la clasificación. 

% Defino variables necesarias

[F,~] = size(X);
mu = 0.01;              % Tasa de aprendizaje
W = rand(3,1)-0.5;       % Inicialización de los coeficientes w. 
                        % W = [w1,w2,w0]
                        
max_iter = 100;        % Maximo numero de epocas permitido

d(d==2)=-1;             % Modifico los vectores deseados acorde a la salida     
                        % de la función de activación.
Y = zeros(F,1);                        
X = [X,ones(F,1)];      % Agrego vector de entradas x0=-1;
e = zeros(1,F);
acc = [];               % Error por epoca

max_prev=0;             % Inicializo la maxima precisión alcanzada
for iter=1:max_iter
    for i=randperm(F)
        x = X(i,:)';
        v = W'*x;               % Variable lineal
        Y(i) = sign(v);         % Salida con funcion de activación sign(v)
        e(i) = d(i)-Y(i);
        W = W + 2*mu*e(i)*x;
    end
    acc = [acc, length(find(e==0))/length(e)*100];
    
    
    % Grafico
    if graphflag==1 && iter < 6
        figure(fig)
        scatter(X(d==1,1),X(d==1,2),'b','fill'); hold on;
        scatter(X(d==-1,1),X(d==-1,2),'r','fill');
        t = [min(X(:,1)), max(X(:,1))];
        plot(t, -W(1)/W(2)*t-W(3)/W(2),'LineWidth',2); hold off;
        ylim([0 10]); xlim([-4 8]);
        drawnow;
        pause(0.5)
    end
    
    if max(acc)>max_prev
        Yopt = Y;
        Wopt = W;
    end
end


end


