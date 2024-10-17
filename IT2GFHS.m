function [y,p_o,q_ol,q_ou] = IT2GFHS(u,yd,K,D,S,et,epnum)
%% 获得参数
k11 = K(1);
k12 = K(2);
k21 = K(3);
k22 = K(4);
k31 = K(5);
k32 = K(6);
d11 = D(1);
d12 = D(2);
d21 = D(3);
d22 = D(4);
d31 = D(5);
d32 = D(6);
s_l = S(1);
s_u = S(2);
%% 获得参数
p  = 0;
s = size(u);
q_lower = zeros(1,6);
q_upper = zeros(1,6);
K = [k11,k12,k21,k22,k31,k32]; 
d = [d11;d12;d21;d22;d31;d32];
sigma_lower = s_l;
sigma_upper = s_u;
eta = et;
M = [0 0 0 0 0 0 0 0 0 0 0 0 0]';
V = [0 0 0 0 0 0 0 0 0 0 0 0 0]';
beta1 = 0.9;
beta2 = 0.999999;
%% 训练
Y_IT2GFHS  =  zeros(s(1,1),1);
e_IT2GFHS  =  zeros(s(1,1),1);
for epoch  =  1:epnum
    for i  =  1:s(1,1)
        j  =  1;
        u_IT2GFHS  =  [u(i,j);u(i,j); u(i,j+1);u(i,j+1); u(i,j+2);u(i,j+2)];
        Y_IT2GFHS(i)  =  (p(i) + q_lower(i,:)*tanh(diag(K(1,:))*(u_IT2GFHS - d(:,1))/(sigma_lower)^2)+q_upper(i,:)*tanh(diag(K(1,:))*(u_IT2GFHS-d(:,1))/(sigma_upper)^2));
        e_IT2GFHS(i)  =  yd(i,j) - Y_IT2GFHS(i);
        g  =  [e_IT2GFHS(i),(e_IT2GFHS(i))*tanh(diag(K(1,:))*(u_IT2GFHS-d(:,1))/(sigma_lower)^2)',(e_IT2GFHS(i))*tanh(diag(K(1,:))*(u_IT2GFHS-d(:,1))/(sigma_upper)^2)']';
        M  =  beta1*M+(1-beta1)*g;
        V  =  beta2*V+(1-beta2)*g.^2;
        Mhat  =  M/(1-beta1^i);
        Vhat  =  V/(1-beta2^i);
        temp  =  eta./(sqrt(Vhat)+eps).*Mhat;
        p(i+1)  =  p(i) + temp(1);
        q_lower(i+1,:)  =  q_lower(i,:) + temp(2:7)';
        q_upper(i+1,:)  =  q_upper(i,:) + temp(8:13)';
        y  =  Y_IT2GFHS;
        p_o  =  p(i+1);
        q_ol  =  q_lower(i+1,:);
        q_ou  =  q_upper(i+1,:);
    end
end
