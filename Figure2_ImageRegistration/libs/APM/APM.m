function [match_err, T_hat, time_] = APM(P, Q)
% P: Mx2
% Q: Lx2
% L >= M

err_dst=0.1; %\epsilon_d in the paper, related to tolerance error
alpha=0;  %regularization weight, rotation invariant when equal to zero
n1=9; %n1 in the paper, 2^n1 is number of rectangles to be subdivided in each iteration of BnB algorithm

fig=0; %figure number
tic
%aff: 2D or 3D affine transformation
%simi: 2D similarity transformation
% pind=RPM_concave_LAPJV(X,Y,err_dst,'simi',alpha,n1,[],fig); 

pind=RPM_concave_LAPJV(P,Q,err_dst,'aff',alpha,n1,[],fig); 
time_=toc;

perm=pind-(0:size(P,1)-1)'*size(Q,1);
perm=perm';

%[size(perm) size(Y) size(X)]
%display result
match_err=plot_match_result(P,Q,perm,fig);
P_homo = [P, ones(length(P),1)];
T_hat = inv(P_homo'*P_homo)*(P_homo'*Q(perm,:));
end