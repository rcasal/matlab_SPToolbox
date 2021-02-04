function X = RandomNumbers(mu, Sigma, N, dim, distribution )
%X = RandomNumbers(mu, sigma, n, dim, distribution) 
% Genera numeros aleatorios de media mu y matriz de covarianza Sigma siendo
% n la cantidad de valores generados, dim y distribution la dimensión y 
% distribución de los datos, respectivamente.

% Verifico orientacion de mu
[F,C]=size(mu);
if F<C
    mu = mu';
end


switch distribution
    case 'Normal'
        x = randn(dim,N);       % Genera 2 vectores aleatorios de long. N
        x = (x - repmat(mean(x,2),1,N))./ repmat(std(x,0,2),1,N);
                                % Me aseguro de que x esté normalizado
        X = zeros(dim,N);
        [V,D] = eig(Sigma);     % devuelve autovectores en V y autovalores 
                                % en matriz diagonal D. V representa un 
                                % nuevo sistema coordenado cuyos ejes se 
                                % corresponden con la orientación de la 
                                % elipse. La raíz cuadrada de los 
                                % autovalores representan los radios de la
                                % elipse.
        for i=1:N
            X(:,i) = V'*(D.^0.5*x(:,i))+mu;
                                % Se realiza la transformación de las 
                                % señales independientes, multiplicándolas 
                                % por el desvío estándar y sumándole la 
                                % media.
        end
        
        
        
end




end