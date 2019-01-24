
function [pind,fup]=RPM_concave_LAPJV(X,Y,err_dst,trans_type,alpha,Nexp,depth0,fig)
Nx=size(X,1);Ny=size(Y,1);


%general implementation, working with any transformation having linear
%coefficients, such as affine and similarity





%use diagnal weight matrix for regularization term
switch trans_type
    case 'simi'
        %similarity 2D
        Jx=[X(:,1) -X(:,2) ones(Nx,1)*[1 0] X(:,2) X(:,1) ones(Nx,1)*[0 1]];%[x -y 1 0;y x 0 1], Jacobian
        Jx=reshape(Jx',[4,2*Nx])';%2*Nx x 4
        weight=alpha*diag([1 1 0 0]);%diagonal weight matrix
        trans0=[1 0 0 0]';%reference transformation

    case 'aff' %for 2D and 3D
        Jx=[];
        for ii=1:size(X,1)
            Jx=[Jx;[kron(eye(size(X,2)),X(ii,:)) eye(size(X,2))]];
        end

        weight=alpha*diag([ones(1,size(X,2)^2) zeros(1,size(X,2))]);
        trans0=[reshape(eye(size(X,2)),[size(X,2)^2,1]); zeros(size(X,2),1)];
end



%%%%%%%%%convert RPM objective to quadratic form
[Asqr,b]=RPM_regu_quadratic(Jx,Y,weight,trans0);



[Aq,Ar,~]=qr(Asqr',0);

[U,V]=eig(Ar*Ar'); 

U=Aq*U;
V=diag(V);

clear Asqr Aq Ar ss Jx; % X Y;


if nargin<7 || isempty(depth0) 
    depth0=inf;
end


err0=Nx*err_dst^2;


[pind,fup]=normal_rectangular_branch_bound_LAPJV_parallel(b,U,V,Nx,Ny,depth0,err0,Nexp,X,Y,fig);

