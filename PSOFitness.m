%% 
function Fitness = PSOFitness(X)
    %% 
    global ntrain XTrain InputDim
    %% 
    K = X(1:6);
    D = X(7:12);
    S = X(13:14);
    %% 
    et = 0.1;
    epnum = 50;
    y = XTrain(:,end);
    %% 
    Layer = 1;
    XLayer1 = zeros(ntrain, InputDim - 2*Layer);
    [XLayer1(:,1),~,~,~] = IT2GFHS(XTrain(:,1:3),y,K,D,S,et,epnum);
    [XLayer1(:,2),~,~,~] = IT2GFHS(XTrain(:,2:4),y,K,D,S,et,epnum);
    [XLayer1(:,3),~,~,~] = IT2GFHS(XTrain(:,3:5),y,K,D,S,et,epnum);

    Layer = Layer+1;
    XLayer2 = zeros(ntrain, InputDim - 2*Layer);
    [XLayer2(:,1),~,~,~] = IT2GFHS(XLayer1(:,1:3),y,K,D,S,et,epnum);
    %% 
    err_train = sqrt(sum((y - XLayer2).^2)/ntrain);
    %% 
    Fitness = err_train;
end