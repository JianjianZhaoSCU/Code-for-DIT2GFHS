%% 
function Pop = PopGen(Mu,Sigma,PopDim)
    Pop = zeros(1,PopDim);
    for I = 1:PopDim
        Pop(I) = normrnd(Mu(I),Sigma(I));
    end
end
