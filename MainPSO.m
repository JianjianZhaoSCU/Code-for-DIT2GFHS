clc;clear;close all
%% 
global ntrain ntest InputDim XTrain XTest
%% 
rng(0)
load('del.mat');
[ntrain,DataDim] = size(deltaaileronstrain);
[ntest,~] = size(deltaaileronstest);
InputDim = DataDim - 1;
%% 
XTrain = deltaaileronstrain;
XTest = deltaaileronstest;
%% 
PopDim = 14;
Maxgen = 2;
PopSize = 10;
C1 = 2.0;
C2 = 2.0;
W = 0.1;
Vmax = 2;
Vmin = -2;
PopValueMax = 8;
PopValueMin = 1e-5;
Pop = zeros(PopSize,PopDim);
V = zeros(PopSize,PopDim);
Fitness = zeros(PopSize,1);
Trace = zeros(Maxgen,1);
%% 
Mu = [0.1, 0.2, 0.2, -0.5, 0.1, 0.7, 0.1, 0.8, 0.8, 0.5, 0.6, 0.6, 0.7, 5.0];
Sigma = [1.0, 1.0, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, 0.5, 0.5, 0.5];
%% 
for I = 1:PopSize
    Pop(I,:) = PopGen(Mu,Sigma,PopDim);
    Fitness(I) = PSOFitness(Pop(I,:));
end
%% 
[bestfitness,bestindex] = min(Fitness);
Gbest = Pop(bestindex,:);
fitnessGbest = bestfitness;
Pbest = Pop;
fitnessPbest = Fitness;
%% 
for i = 1:Maxgen
    disp(['---------The  ' num2str(i) '  Iteration---------']);
    %% 
    for j = 1:PopSize
        V(j,:) = W*V(j,:)+C1*rand*(Pbest(j,:)-Pop(j,:))+ C2*rand*(Gbest-Pop(j,:));
        V(j,V(j,:) > Vmax) = Vmax;
        V(j,V(j,:) < Vmin) = Vmin;
        Pop(j,:) = Pop(j,:)+V(j,:);
        Pop(j,Pop(j,:) > PopValueMax) = PopValueMax;
        Pop(j,Pop(j,:) < PopValueMin) = PopValueMin;
        Fitness(j) = PSOFitness(Pop(j,:));
    end
    %% 
    for j = 1:PopSize
        if Fitness(j) < fitnessPbest(j) 
            Pbest(j,:)  = Pop(j,:);
            fitnessPbest(j) = Fitness(j);
        end
        if Fitness(j) < fitnessGbest
            Gbest = Pop(j,:);
            fitnessGbest = Fitness(j);
        end
    end
    Trace(i) = fitnessGbest;
    disp(['fitnessGbest is ' num2str(fitnessGbest)]);
end
%% 
[Fitness, err_test, STD, NDEI, sMAPE, MAE] = PSOFitnessWithTest(Gbest)

