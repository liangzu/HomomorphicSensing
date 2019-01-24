function [Asqr,b]=RPM_regu_quadratic(Jx,Y,Wgt,trans0)
%formulate the objective of RPM problem as concave quadratic function
%matrix weight is semipositive definite
%Wgt: weighting symmetric matrix

Nd=size(Y,2);%point dimension
Nx=size(Jx,1)/Nd;
Ny=size(Y,1);

% Ye=reshape(Y',[size(Y,2)*Ny,1]);
Ye=Y';
Ye=Ye(:);%Nd*Ny x 1

tmp=[];
myeye=eye(Nd);
for ii=1:Nd
    tmp=[tmp;kron(speye(Ny),myeye(:,ii))];
end
stru=kron(speye(Nx),tmp);
% stru=kron(speye(Nx),[kron(speye(Ny),[1;0]);kron(speye(Ny),[0;1])]);%Nx*4*Ny x Nx*Ny

Cent=inv(Jx'*Jx+Wgt);
upper=chol(Cent);%upper'*upper=original
Asqr=kron(upper*Jx',Ye')*stru;%the square term

b=-2*kron(trans0'*Wgt*Cent*Jx',Ye')*stru...
    +kron(ones(1,Nx),sum(Y.^2,2)');%Nx*Ny x 1, linear term
b=b';