function set_rec=rect_recurse_subdivide(V,rect,dpt)

set_rec=[];
if dpt>0
    
    % decide which dimension to divide
    dif=V.*(rect(:,2)-rect(:,1)).^2;
    [~,ind]=max(dif);
    %new rectangulars
    recti=repmat(rect,[1,1,2]);
    half=mean(rect(ind,:));
    recti(ind,2,1)=half;
    recti(ind,1,2)=half;
    %
    for ii=1:2
%         setrec(end+1).rec=recti(:,:,ii);
%         setrec(end).dpt=dpt+1;
        
        set_rec=[set_rec rect_recurse_subdivide(V,recti(:,:,ii),dpt-1)];
    end    
    
% end
else
    set_rec=rect;
end