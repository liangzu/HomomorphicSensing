function plot_image_point_corres_vert(imX,imY,X,Y,pind,fig)



if size(imX,2)<size(imY,2)
scale=size(imX,2)/size(imY,2);
imY=imresize(imY,scale);
Y=Y*scale;
else %if size(imX,1)<size(imY,1)
    scale=size(imY,2)/size(imX,2);
imX=imresize(imX,scale);
X=X*scale;
end


P=sparse(pind,1,1,size(X,1)*size(Y,1),1);
P=reshape(P,size(Y,1),size(X,1))';

imX=rgb2gray(imX);
imY=rgb2gray(imY);

sz=max([size(imX);
    size(imY)]);
imZ=zeros(size(imX,1)+size(imY,1),sz(2));
imZ(1:size(imX,1),1:size(imX,2))=imX;
imZ(size(imX,1)+1:end,1:size(imY,2))=imY;

if nargin>5 && ~isempty(fig)
    figure(fig)
else
    figure;
end
cla
imdisp(imZ);


hold on;
plot(X(:,1),X(:,2),'ro')
plot(Y(:,1),Y(:,2)+size(imX,1),'g*');
PY=P*Y;



ind=logical(diag(P));

plot([X(ind,1) PY(ind,1)]', [X(ind,2) PY(ind,2)+size(imX,1)]','b');
plot([X(~ind,1) PY(~ind,1)]', [X(~ind,2) PY(~ind,2)+size(imX,1)]','r');

drawnow