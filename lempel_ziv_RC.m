function [cN,c] = lempel_ziv_RC(x,thr)
%function [complexity] = lempel_ziv(data)
% Recibe los datos y los convierte en una secuencia numérica de t valores.
% Luego calcula la complejidad de LZ.

n = length(x);

% Ordeno umbrales
thr = sort(thr);

% Secuencia simbólica
P = x;  % P = cell(size(x));
A = 65;                     % Codigo para 'A'
j = 1;

P(x<thr(1)) = char(A);
for i=2:length(thr)
    P(x>=thr(i-1) & x<thr(i)) = char(A+j);
    j=j+1;
end
P(x>=thr(end)) = char(A+j);
clear j A i;

        % figure; plot(x); hold on; plot([1 n], [thr(1) thr(1)],'r'); plot([1 n], [thr(2) thr(2)],'r');
        % plot([1 n], [thr(3) thr(3)],'r')
        % plot(double(P)-66);


        
% Inicializacion
c = 1;                      % Indice de complejidad
S = P(1);
Q = P(2);

% Iteracion
i=1;
r=1;
while r+i < n
    SQpi = [S Q(1:end-1)];
    if isempty(strfind(SQpi,Q))     % Q no pertenece a v(SQpi) 
        c = c+1;
        S = P(1:r+i);
        Q = P(r+i+1);
        r = r+i;
        i=1;
    else                                % Q pertenece a v(SQpi)
        i = i+1;
        Q = P(r+1:r+i);
    end
end
c = c + 1;
b = n/(log(n)/log(length(thr)+1));
cN = c / b;

end









% r=1;
% while r < n 
%     SQpi = [S Q(1:end-1)];
%     if isempty(strfind(SQpi,Q))     % Q no pertenece a v(SQpi) 
%         c = c+1;
%         S = P(1:r+1);
%         r = r+1;
%         Q = P(r+1);
%     else                            % Q pertenece a v(SQpi) -> actualizo Q
%         r=r+1;
%         Q = P(r+1);
%     end 
% end
% 
% b = n/(log(n)/log(length(thr)+1));
% c = c / b;
