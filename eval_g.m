function [G,g,dg] = eval_g(val,func,a)
% [G,g,dg] = eval_g(val,g)
% Evalúa la función de contraste g.
%
% Parámetro                 Valor
%
% 'g'                       Función no lineal utilizada. 
%                           Valor de 'g':      Función utilizada:
%                           'cosh' (default)   g(u)=1/a log cosh(a1*u)
%                           'exp'              g(u)=-exp(-(u).^2 / 2)
%                           'pow3'             g(u)=u^3
%                           'skew'             g(u)=u^2

if nargin==1
    func = 'cosh';                          % g por defecto
    a = 1;
elseif nargin ==2
    a = 1;                                  % a por defecto
end


% Lectura de argumentos opcionales
switch func
    case 'cosh'
        G = 1/a*log(cosh(a*val));
        g=tanh(a*val);
        dg=a*(1-tanh(a*val).^2);
    case 'exp'
        G=-exp(-(val).^2/2);
        g=(val).*exp(-(val).^2/2);
        dg=(1-(val).^2).*exp(-(val).^2/2);
    case 'pow3'
        G = val^3;
        g = 3*val^2;
        dg= 6*val;
    case 'skew'
        G = val^2;
        func = 2*val;
        dg= 2;
    otherwise
        error(['Parámetro' '' func '' 'no reconocido']);
end
        
end

