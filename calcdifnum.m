function sfas = calcdifnum(x,dH)

x(1) = 10^((x(1))*(log10(30000/75))+log10(75));

% Vector de Entrada
vecin_atras =     [0 x(1) x(2) x(3) x(4)-dH];
vecin_adelante =  [0 x(1) x(2) x(3) x(4)+dH];

% Calcular valor atras

lvwrite(vecin_atras);
ffatras = lvreadser;
    while(isempty(ffatras) || ffatras(2)==0)
        %disp('error reading');
        lvwrite(vecin_atras);
        ffatras = lvreadser; 
    end
fatras=ffatras(1);

% Calcular valor adiante

lvwrite(vecin_adelante)
ffadelante = lvreadser;
    while(isempty(ffadelante) || ffadelante(2)==0)
        %disp('error reading');
        lvwrite(vecin_adelante);
        ffadelante = lvreadser; 
    end
fadelante=ffadelante(1);

sfas =  (fatras - fadelante)/(2*dH);

end

