function [pind,flin,fval]=rect_underestimator_LAPJV_parallel(b,U,V,rect,Nx,Ny)
%Fast implementation, realized by not taking into account the rectangular
%bounding constraint. The result is still correct due to the concavity of
%the objective function 

Nz=size(rect,3);

pind=[];flin=[];

finput=repmat(b,1,Nz)-U*(repmat(V,1,Nz).*permute(sum(rect,2),[1,3,2]));
%change here to parfor for multi-core CPU parallel implementation 
for ii=1:Nz
    [pind(:,ii),flin(ii)]=assign_prog(finput(:,ii),Nx,Ny);
end

flin=flin+V'*permute(prod(rect,2),[1,3,2]);


u=[]; cst=[];
for jj=1:Nz
    u(:,jj)=sum(U(pind(:,jj),:),1);
    cst(:,jj)=sum(b(pind(:,jj)));
end
fval=cst-V'*u.^2;
