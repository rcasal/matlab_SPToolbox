function [A,B,Pi] = Baum_Welch(x,S)
% [A_BW,B_BW,Pi_BW] = Baum_Welch(S_c)
% Estimación de los parámetros a partir del algoritmo de Baum-Welch. S_c es
% un vector de estados observables de longitud T

N_s = length(S);                % Cantidad de estados posibles
epsilon = 1e-6;
IterMax = 100;
flag = true;
% Codifico numéricamente las salidas para indexado.             
xn = double(strcmp(x,'W')) + double(strcmp(x,'B'))*2 +...
    double(strcmp(x,'M'))*3;
T = length(xn);    
Np = max(xn);
Xn = sparse(xn,1:T,1,Np,T);


% Inicializo parámetros al azar
p11=rand*0.75; p22=rand*0.75;
A = [p11 1-p11; 1-p22 p22]; clear p11 p22;
p1=rand*0.75; Pi = [p1 1-p1]'; clear p;
p11=rand*0.75; p22=rand*0.75; p32=rand*0.75;
B = [p11 1-p11; 1-p22 p22; 1-p32 p32]; clear p11 p22;
B =B';
M = B*Xn;
llh = -inf(1,IterMax);
iter = 1;
while flag
    iter = iter +1;
    p = zeros(1,T); 
    a = zeros(N_s,T);
    a(:,1) = Pi.*M(:,1); 
    p(1) = sum(a(:,1));
    a(:,1) = a(:,1)/p(1);
    for i = 2:T
        a(:,i) = (A'*a(:,i-1)).*M(:,i); 
        p(i)=sum(a(:,i));
        a(:,i) = a(:,i)/p(i);
    end
    b = ones(N_s,T);
    for i = T-1:-1:1
        b(:,i) = A*(b(:,i+1).*M(:,i+1))/p(i+1);   
    end
    g = a.*b;              
    
    llh(iter) = sum(log(p(p>0)));
    if llh(iter)-llh(iter-1) < epsilon*abs(llh(iter-1)); 
        flag = false;
    elseif iter==IterMax
        flag = false;
        disp(['El algoritmo no converge luego de ', num2str(iter),...
            ' iteraciones']);
    else
        A = A.*(a(:,1:T-1)*bsxfun(@times,b(:,2:T).*M(:,2:T),1./p(2:end))');
        A = bsxfun(@times,A,1./(sum(A,1)));
        Pi = g(:,1);                                                                             
        M = bsxfun(@times,g*Xn',1./sum(g,2))*Xn;
    end
    
    

end
A=A';
Pi = Pi';


end