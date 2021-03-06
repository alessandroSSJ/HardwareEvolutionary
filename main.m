clc
clear all
warning off
instrreset()
tic

% Frequencia - DC AC Campo ...

lim_inf = [75       0       1    -2 75       0       1    -2];   %  Limites originais
lim_sup = [30000    100     30    +2 30000    100     30    +2];

Lb_Data1 =[0      0     1    -2  0      0     1    -2];    % frec, bias, oe, level current 
Ub_Data1 =[1     100    30    +2  1     100    30    +2];    

% esc = [299250 10000 1 2/2.89e-3];            %Factor de Modifica��o dos limites
esc = [1 1 1 1 1 1 1 1];

Lb_Data = Lb_Data1.*esc;        % Limites Modificados
Ub_Data = Ub_Data1.*esc;

numInputVariables_Data = 8;     % Numero de variais do sistema
DH = 0.7;
N = 15;
SensWeight = 0.9;
TolS = 5;   % chute a vera

% ALGORITMO GENETICO

% Par�metros GA                 %Par�metros modific�veis do ga
PopulationSize_Data = 10; % tava 5
EliteCount_Data = 3;    % tava 3
Generations_Data = 100;   % tava 10
StallGenLimit_Data = 10; %tava 10
TolFun_Data = 1e-4;
StallTimeLimit_Data = 1e100000;
CrossoverFraction_Data = 0.8;
Mutation_rate=0.05;
Crossover_type = 2;

Generations_1 = 0;
Generations_2 = 0;
Generations_3 = 0;
% GA
% Start with the default options
options = gaoptimset;
options = gaoptimset('CreationFcn', @gacreationuniform);%@gacreationuniform,@gacreationlinearfeasible,
options = gaoptimset('PopInitRange', [0 20 1 -1.6  0 20 1 -1.6; 0.5 50 10 -1.2 0.5 50 10 -1.2]);
options = gaoptimset(options,'CrossoverFcn', {@crossoverheuristic , 2});%@crossoverheuristic | {@crossoverscattered} | {@crossoverintermediate}* | @crossoversinglepoint | @crossovertwopoint | @crossoverarithmetic
options = gaoptimset(options,'SelectionFcn', @selectiontournament);%@selectionremainder | @selectionuniform | {@selectionstochunif} | @selectionroulette | @selectiontournament
options = gaoptimset(options,'CrossoverFraction', CrossoverFraction_Data);
options = gaoptimset(options,'Display', 'diagnose');%'off','iter','diagnose','fina'
options = gaoptimset(options,'EliteCount', EliteCount_Data);%0.05*ParamsGA.population_size
options = gaoptimset(options,'Generations', Generations_Data);
options = gaoptimset(options,'MutationFcn', @mutationadaptfeasible);%,{@mutationgaussian} for ga, {@mutationadaptfeasible}* for gamultiobj | @mutationuniform |
options = gaoptimset(options,'PlotFcns', @gaplotbestf);% @gaplotbestindiv});%@gaplotbestf | @gaplotbestindiv | @gaplotdistance | @gaplotexpectation | @gaplotgenealogy | @gaplotmaxconstr | @gaplotrange | @gaplotselection | @gaplotscorediversity | @gaplotscores | @gaplotstopping | {[]}
options = gaoptimset(options,'PopulationSize', PopulationSize_Data);
options = gaoptimset(options,'PopulationType', 'doubleVector');%'bitstring' | 'custom' | {'doubleVector'}
options = gaoptimset(options,'StallGenLimit', StallGenLimit_Data);
options = gaoptimset(options,'TolFun',TolFun_Data);
%options = gaoptimset(options,'OutputFcns' ,@showpopulation); %@showpopulation- Show Population --- @savepopulation -Salva population e scores - add line total_medicoes2 = sortrows(horzcat(total_population,total_scores),5); % Resultado total dos testes
 
 % Fun��o de avalia��o
fitnessFunction=@(x)(- calcdifnum(x,DH,N,SensWeight,TolS) );           %Fun��o de Evalua��o forma anonima

[x,fval,exitflag,output,state,scores] = ...
    ga1(fitnessFunction,numInputVariables_Data,[],[],[],[],Lb_Data,Ub_Data,[],[],options); % Evalu�ao do GA

Generations_1 = output.generations;                     %Gera�oes para Convergir

toc
tempo = (toc/3600);

Config_GA = [0 Crossover_type PopulationSize_Data Generations_Data...
            Generations_1 Generations_2 Generations_3 EliteCount_Data  StallGenLimit_Data...  %Parametros do GA
            TolFun_Data   CrossoverFraction_Data  Mutation_rate tempo lim_inf lim_sup];  
        
x(1) = 10^((x(1))*(log10(30000/75))+log10(75)); 
x(5) = 10^((x(5))*(log10(30000/75))+log10(75)); 

xfin = x
lvwrite([0 xfin DH 1 ]);                    % Stop LabView and write the best ind no LabView
pause(1);
lvwrite1(Config_GA);    
% Write configura��o do GA

fprintf('\n *** Algoritmo Gen�tico ***\n\n');
fprintf('N�mero de Gera��es: %d\n', output.generations);
fprintf('Popula��o: %d\n', PopulationSize_Data);
fprintf('N�mero de Avalia��es: %d\n', output.funccount);
fprintf('Valor �timo: %g\n',fval);
fprintf('FITA 1 - Frequ�ncia da corrente de condicionamento (KHz): %10.0f\n',x(1));
fprintf('FITA 1 - N�vel CC da corrente de condicionamento (mA): %6.4f\n',x(2));
fprintf('FITA 1 - Amplitude da Corrente (mA): %6.4f\n',x(3));
fprintf('FITA 1 - Campo magn�tico externo (Oe): %8.4f\n',x(4));
fprintf('FITA 2 - Frequ�ncia da corrente de condicionamento (KHz): %10.0f\n',x(5));
fprintf('FITA 2 - N�vel CC da corrente de condicionamento (mA): %6.4f\n',x(6));
fprintf('FITA 2 - Amplitude da Corrente (mA): %6.4f\n',x(7));
fprintf('FITA 2 - Campo magn�tico externo (Oe): %8.4f\n',x(8));