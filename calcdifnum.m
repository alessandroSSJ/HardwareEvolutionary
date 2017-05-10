function sfas = calcdifnum(x,DH,N,SensWeight,TolS)

    hPoints(1) = (x(4)-DH)/2:DH/(N-1):(x(4)+DH)/2;
    hPoints(2) = (x(8)-DH)/2:DH/(N-1):(x(8)+DH)/2; 

    x(1) = 10^((x(1))*(log10(30000/75))+log10(75));
    x(5) = 10^((x(5))*(log10(30000/75))+log10(75));

    % Vector de Entrada
    vecin = [];
    for j = 1:2
        for i = 1:N
            vecin = [vecin;
                      0 x(1+(j-1)*4) x(2+(j-1)*4) x(3+(j-1)*4) hPoints(j,i)]; 
        end
    end

    % Calcular valores
    Phi = [];
    for fita = 1:2
        for hField = 1:N
            vecin_actual = vecin(hField + (fita-1)*N,:);
            lvwrite(vecin_actual);
            ffatras = lvreadser;
                while(isempty(ffatras) || ffatras(2)==0)
                    lvwrite(vecin_actual);
                    ffatras = lvreadser; 
                end
            Phi = [Phi ffatras(1)];
        end
        % Troca fita labview
    end

    Phi_fita1 = Phi(1:N);
    H_fita1 = hPoints(1);

    Phi_fita2 = Phi((N+1):2*N);
    H_fita2 = hPoints(2);

    Fit_fita1 = polyfit(H_fita1,Phi_fita1,1);
    Fit_fita2 = polyfit(H_fita2,Phi_fita2,1);

    S1 = Fit_fita1(1);
    S2 = Fit_fita2(1);

    intercept1 = Fit_fita1(2);
    intercept2 = Fit_fita2(2);

    residFita1 = Phi_fita1 - (S1*H_fita1 + intercept1);
    residFita2 = Phi_fita2 - (S2*H_fita2 + intercept2);

    E1 = sqrt(sum(residFita1.^2)/N);
    E2 = sqrt(sum(residFita2.^2)/N);

    sfas = -(1-SensWeight)*(E1+E2)+SensWeight*(abs(S1)+abs(S2));
    if( abs(S1-S2) >= TolS )
        sfas = -99999;
    end
end

