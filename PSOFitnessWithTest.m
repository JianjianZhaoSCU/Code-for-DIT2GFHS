%% 
function [Fitness, err_test, STD, NDEI, sMAPE, MAE] = PSOFitnessWithTest(X)
    %% 
    global ntrain ntest XTrain XTest InputDim
    %% 
    K = X(1:6);
    D = X(7:12);
    S = X(13:14);
    %% 
    ytsum = 0;
    std = 0;
    temp_smape = 0;
    et = 0.1;
    epnum = 60;
    y = XTrain(:,end);
    yt = XTest(:,end);
    %% 
    Layer = 1;
    XLayer1 = zeros(ntrain, InputDim - 2*Layer);
    [XLayer1(:,1),p11_o,q11_ol,q11_ou] = IT2GFHS(XTrain(:,1:3),y,K,D,S,et,epnum);
    [XLayer1(:,2),p12_o,q12_ol,q12_ou] = IT2GFHS(XTrain(:,2:4),y,K,D,S,et,epnum);
    [XLayer1(:,3),p13_o,q13_ol,q13_ou] = IT2GFHS(XTrain(:,3:5),y,K,D,S,et,epnum);

    Layer = Layer+1;
    XLayer2 = zeros(ntrain, InputDim - 2*Layer);
    [XLayer2(:,1),p21_o,q21_ol,q21_ou] = IT2GFHS(XLayer1(:,1:3),y,K,D,S,et,epnum);
    %% testing stage
    Layer = 1;
    XTLayer1 = zeros(ntest, InputDim - 2*Layer);
    XTLayer1(:,1) = IT2GFHS_TEST(XTest(:,1:3),p11_o,q11_ol,q11_ou,K,D,S);
    XTLayer1(:,2) = IT2GFHS_TEST(XTest(:,2:4),p12_o,q12_ol,q12_ou,K,D,S);
    XTLayer1(:,3) = IT2GFHS_TEST(XTest(:,3:5),p13_o,q13_ol,q13_ou,K,D,S);
  

    Layer = Layer+1;
    XTLayer2 = zeros(ntest, InputDim - 2*Layer);
    XTLayer2(:,1) = IT2GFHS_TEST(XTLayer1(:,1:3),p21_o,q21_ol,q21_ou,K,D,S);
    %% 
    err_train = sqrt(sum((y - XLayer2).^2)/(ntrain));
    err_test  = sqrt(sum((yt - XTLayer2).^2)/(ntest));
    
    ytsum = sum(yt);
    ytmean = ytsum/(ntest);
    
    for i=1:ntest
        std = std+(XTLayer2(i)-ytmean)^2;
    end
    STD = sqrt(std/ntest);
    NDEI = err_test/STD;
    
    for i=1:ntest
        mae(i)=abs(yt(i)-XTLayer2(i));
    end
    MAE=sum(mae)/(ntest);
    
    for i=1:ntest
        temp_smape=temp_smape+2*abs(yt(i)-XTLayer2(i))/(abs(yt(i))+abs(XTLayer2(i)));
    end
    sMAPE=temp_smape/(ntest);

  
    %% 
    Fitness = err_train;
end