function tree = DecisionTreeNum(D,feat,leaf, impurity_measure,root_node)
% tree = DecisionTree(D,feat,leaf, impurity)
% Crece el árbol de decisión a partir de los datos D, las características
% feat y las clases de salida leaf. Utiliza la medida de impureza
% especificada en la variable impurity.

if nargin<5
    root_node='';
end

% Cantidad de elementos de cada clase a priori
F=length(D);
nC = length(leaf.Juega);        % Cantidad de categorías
K = zeros(nC,1);                % Cantidad de elementos de cada categoría

for i = 1:F
    for j =1:nC
        K(j) = K(j) + strcmp(D(i).Juega,leaf.Juega{j});
    end
end
i_tot = impurity(K, impurity_measure);   % Entropía total 

if i_tot>0
    
    Delta_iM = 0;
    feat_name = fieldnames(feat);   % Nombre de características
    nf = length(feat_name);         % Cantidad de características
    
    for i=1:nf
        sub_feat=feat.(char(feat_name(i))); % Subcaracterísticas
        n_sf=length(sub_feat);  % Número de subcaracterísticas
        
        for j = 1:n_sf
            K_sf=zeros(2);      % Contador de elementos. Las dos filas
                                % corresponden a P y N y las columnas a la
                                % rama izquierda y derecha.
            
            
            for k = 1:F              % Recorro el vector de D
                
                if ischar(D(k).(char(feat_name(i))))    % Dato Nominal
                    
                    if strcmp(D(k).(char(feat_name(i))),char(sub_feat(j)))  % Si D en
                        % característica es = a sf(j)
                        
                        if strcmp(D(k).Juega, leaf.Juega{1})     % Si es P
                            K_sf(1,1)=K_sf(1,1)+1;
                        else
                            K_sf(2,1)=K_sf(2,1)+1;               % Si es N
                        end
                    else
                        
                        if strcmp(D(k).Juega, leaf.Juega{1})     % Si es P
                            K_sf(1,2)=K_sf(1,2)+1;
                        else
                            K_sf(2,2)=K_sf(2,2)+1;               % Si es N
                        end
                    end
                    
                elseif isnumeric(D(k).(char(feat_name(i)))) % Dato numérico
                    datos_num=[];
                    for f=1:F
                        D_num=[datos_num,datos(c1).(char(nombres_caracteristicas(n1,1)))];
                    end
                    [datos_num,datos_indice]=sort(datos_num,'ascend');
                    % ordena los valores para cada atributo
                    for c1=1:length(datos_indice)-1
                        % Analizando la impureza del nodo para los diferentes
                        % rangos del atributo
                        acum2=zeros(2);
                        if datos_num(c1+1)>datos_num(c1)
                            num_comparar=(datos_num(c1+1)+datos_num(c1))/2;
                            for c2=1:Cd
                                if datos(datos_indice(c2)).(char(nombres_caracteristicas(n1,1)))...
                                        <=num_comparar
                                    if strcmp(datos(datos_indice(c2)).(char(fieldnames(clase))),...
                                            char(clase.Juega(1)))
                                        acum2(1,1)=acum2(1,1)+1;
                                    else
                                        acum2(1,2)=acum2(1,2)+1;
                                    end
                                else
                                    if strcmp(datos(datos_indice(c2)).(char(fieldnames(clase))),...
                                            char(clase.Juega(1)))
                                        acum2(2,1)=acum2(2,1)+1;
                                    else
                                        acum2(2,2)=acum2(2,2)+1;
                                    end
                                end
                            end
                        end
                        
                        
                        
                        i_sf = impurity(K_sf, impurity_measure);   % Entropía total
                        
                        n_tot=sum(sum(K_sf));
                        n_sf=sum(K_sf,1);
                        Delta_i = i_tot - sum(i_sf.*n_sf)/n_tot;
                        
                        if Delta_iM< Delta_i
                            Delta_iM = Delta_i;
                            feat_M = char(feat_name(i));
                            sub_featM = char(sub_feat(j));
                        end
                    end
                end
            end
            
            % Genero árboles hijos hacia la izquierda (si) y hacia la derecha (no)
    D_si=[]; D_no=[];
    for i=1:F
        if strcmp(D(i).(char(feat_M)),char(sub_featM))
            D_si=[D_si,rmfield(D(i),char(feat_M))];
            % Se remueve este campo porque todos son iguales, por lo tanto
            % dejarlo sólo va a hacer que el algoritmo vaya más lento
        else
            D_no=[D_no,D(i)];
        end
    end
    
    % En forma recursiva, llamo a la misma función para continuar el
    % crecimiento del arbol tanto en las ramas derechas como izquierdas.
    
    tree_si=DecisionTree(D_si,rmfield(feat,char(feat_M)), ...
        leaf, impurity_measure, sub_featM);
    tree_no=DecisionTree(D_no,feat, leaf, impurity_measure, sub_featM);
    
    
    % Construyo el arbol
    tree=[struct('SubFeature',sub_featM,'Feature',feat_M,'si',...
        tree_si(1).SubFeature,'no',tree_no(1).SubFeature,...
        'root_node',root_node);tree_si;tree_no];
    

else            % If I_nodo==0
    
    [~,p]=max(K);
    tree=struct('SubFeature',char(leaf.Juega(p)),'Feature','',...
        'si','','no','','root_node',root_node);
end

end