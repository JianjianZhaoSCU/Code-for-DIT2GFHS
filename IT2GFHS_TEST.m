function [Y_IT2GFHS]=IT2GFHS_TEST(u,p_i,q_il,q_iu,K,D,S)
%% 
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
%% 
s = size(u);
p  = p_i;
q_lower = q_il;
q_upper = q_iu;
K = [k11,k12,k21,k22,k31,k32]; 
d = [d11;d12;d21;d22;d31;d32];
sigma_lower = s_l;
sigma_upper = s_u;
%% 
Y_IT2GFHS = zeros(s(1,1),1);
for i = 1:s(1,1)
    j = 1;
    u_IT2GFHS = [u(i,j);u(i,j); u(i,j+1);u(i,j+1); u(i,j+2);u(i,j+2)];
    Y_IT2GFHS(i) = (p(j) + q_lower(j,:)*tanh(diag(K(1,:))*(u_IT2GFHS - d(:,1))/(sigma_lower)^2)+q_upper(j,:)*tanh(diag(K(1,:))*(u_IT2GFHS-d(:,1))/(sigma_upper)^2));
end
