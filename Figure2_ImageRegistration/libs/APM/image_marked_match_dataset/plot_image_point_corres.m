function plot_image_point_corres(imX,imY,X,Y,pind,fig)



if size(imX,1)<size(imY,1)
scale=size(imX,1)/size(imY,1);
imY=imresize(imY,scale);
Y=Y*scale;
else %if size(imX,1)<size(imY,1)
    scale=size(imY,1)/size(imX,1);
imX=imresize(imX,scale);
X=X*scale;
end


P=sparse(pind,1,1,size(X,1)*size(Y,1),1);
P=reshape(P,size(Y,1),size(X,1))';

imX=rgb2gray(imX);
imY=rgb2gray(imY);

sz=max([size(imX);
    size(imY)]);
imZ=zeros(sz(1),size(imX,2)+size(imY,2));
imZ(1:size(imX,1),1:size(imX,2))=imX;
imZ(1:size(imY,1),size(imX,2)+1:end)=imY;

if nargin>5 && ~isempty(fig)
    figure(fig)
else
    figure;
end
cla
imdisp(imZ);




% imshow(imZ,[])
hold on;
plot(X(:,1),X(:,2),'ro')
plot(Y(:,1)+size(imX,2),Y(:,2),'g*');
PY=P*Y;


ind=logical(diag(P));

plot([X(ind,1) PY(ind,1)+size(imX,2)]', [X(ind,2) PY(ind,2)]','b');
plot([X(~ind,1) PY(~ind,1)+size(imX,2)]', [X(~ind,2) PY(~ind,2)]','r');


drawnow
