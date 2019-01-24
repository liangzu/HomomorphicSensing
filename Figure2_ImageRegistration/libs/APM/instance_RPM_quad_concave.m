%fish shape as model point set
load model_fish
%Chinese character as model point set
% load model_fu
%X = rand(200, 2)-0.5;

%generate scene point set Y
%Gaussian radial basis function%%%%%%%%%%%%%%%%
sigma=6;%%%width of guassian kernel, smaller, more non-rigid
dif=repmat(permute(X,[1,3,2]),[1,size(X,1),1])- repmat(permute(X,[3,1,2]),[size(X,1),1,1]);
sqrdst=sum(dif.^2,3);
RBF=exp(-sqrdst/(2*(0.1*sigma)^2));%%%%use guassian kernel
%add deformation
beta=3;
Y=X+RBF*randn(size(X))*(0*beta);
%add outliers        
Nou=20; %number of outliers in scene point set
Y=[rand(Nou,size(X,2))-ones(Nou,1)*[0.5 0.5];Y];
%add random rotation
theta=rand* 2*pi; 
%Y=Y*[cos(theta) -sin(theta);sin(theta) cos(theta)]*20+[1,2];
Y= Y* randn(2,2) + [1,2];
%Y=Y(randperm(Nou+98),:);

err_dst=0.1; %\epsilon_d in the paper, related to tolerance error
alpha=0;  %regularization weight, rotation invariant when equal to zero
n1=9; %n1 in the paper, 2^n1 is number of rectangles to be subdivided in each iteration of BnB algorithm

fig=0; %figure number
tic
%aff: 2D or 3D affine transformation
%simi: 2D similarity transformation
% pind=RPM_concave_LAPJV(X,Y,err_dst,'simi',alpha,n1,[],fig); 
[pind, fup]=RPM_concave_LAPJV(X,Y,err_dst,'aff',alpha,n1,[],fig); 

time_=toc

perm=pind-(0:size(X,1)-1)'*size(Y,1);
perm=perm';
[size(perm) size(Y) size(X)]
%display result
match_err=plot_match_result(X,Y,perm,fig)
