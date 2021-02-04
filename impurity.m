function i=impurity(K, impurity_measure)
[F,C]=size(K);
i=zeros(1,C);
n=sum(K,1);

switch impurity_measure
    case 'Entropy'
        for c=1:C
            for f=1:F
                aux=K(f,c)/n(c);
                if aux ~=0 && n(c)~= 0
                    i(c)=i(c)-aux*log2(aux);
                end
            end
        end
        
    case 'Gini'
        for c=1:C
            if n(c)~=0
                aux=K(:,c)/n(c);
                i(c)=0.5*(1-sum(aux.^2));
            else
                i(c)=0;
            end
        end
end
end


