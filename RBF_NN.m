function [Y,G,dk, W, acc] = RBF_NN(k,X,d)
% function [Yopt, Wopt, acc] = RBF_NN(X,d,graphflag,fig)
% Los datos obtenidos en X se clasifican mediante una red neuronal de base
% radial.

% Adaptación no supervisada de las RBF

[Xk,mu, ~, ~,dk] = kmedias(k,X(:,1:2),...
    'labels',d,'graphflag',0);

G = RBF_gauss(Xk,mu,dk,'S');

[Y, W, acc] = PerceptronSimple(G,dk,0,[]);

end


function G = RBF_gauss(X,mu,d,S)
% S es el parámetro para calcular sigma. Si S=0, utilizo identidad. Si es 1
% lo calculo a partir del clustering realizado por k-medias.
% K es la cantidad de gaussianas que utilizo.


invSigma = cell(2,1);
if strcmp(S,'eye')
    Sigma=eye(2);
    invSigma{1} = inv(Sigma);
    invSigma{2} = invSigma{1};
else
    aux = X(d==1,1:2);
    Sigma=cov(aux); invSigma{1}=inv(Sigma);
    aux = X(d==-1,1:2);
    Sigma=cov(aux); invSigma{2}=inv(Sigma);
end

    
[F,~] = size(X);
G =X(:,1:2);                % Obtengo la dimensión de G y me quedan las
                            % etiquetas en la tercer columna.
                        
for c=1:2;
    for f=1:F
        G(f,c) = ...
            exp(-0.5*(X(f,1:2)-mu{c})*invSigma{c}*(X(f,1:2)-mu{c})');
    end
end


end
