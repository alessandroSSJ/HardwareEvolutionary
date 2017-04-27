clc
clear all

dH = 0.01156;
%dH = 0.01
Sensibilidade1 = [];
atras =     [0 16651.7 36.1   5.3 (-1.32 - dH)];
adelante =  [0 16651.7 36.1   5.3 (-1.32 + dH) ];
for n=1: 100
    lvwrite(atras);
    a = lvreadser;
         while(isempty(a) || a(2)==0)
             lvwrite(atras);
             a = lvreadser; 
         end
    lvwrite(adelante);
    b = lvreadser;
     while(isempty(b) || b(2)==0)
             lvwrite(adelante);
             b = lvreadser; 
         end
    Sensibilidade = (a-b)/(2*dH);
    Sensibilidade1 = [Sensibilidade1 Sensibilidade(1)]
    n = n+1;
    end
    
