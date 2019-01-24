function [pind,cost]=assign_prog(b,Nx,Ny)

cst=min(b);%b is a vector


B=reshape(b-cst,Ny,Nx)';%convert B to matrix

% fprintf('sparseness of B =%f\n',sum(sum(B<0.1))/(size(B,1)*size(B,2)))

% Jonker-Volgenant algorithm, fastest for linear sum assign problem
if Ny>Nx
    B=[B;zeros(Ny-Nx,Ny)];
elseif  Ny<Nx
    B=[B zeros(Nx,Nx-Ny)];
    disp('# of model points > # of data points!!!!');
end
[pind,cost]=lapjv2(B);
pind=pind(1:Nx);


pind=pind+(0:Nx-1)'*Ny;%convert to vector index
cost=cost+cst*Nx;