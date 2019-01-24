function [pindopt,fup]=normal_rectangular_branch_bound_LAPJV_parallel(b,U,V,Nx,Ny,depth0,err0,Nexp,X,Y,fig)
assert(size(U,2)==size(V,1));

%%%bounding rectangle
fup=inf;
rect=zeros(size(U,2),2);
for ii=1:size(U,2)
    [pind,rect(ii,1)]=assign_prog(U(:,ii),Nx,Ny);

    fval=sum(b(pind))-sum(U(pind,:)).^2*V;

    if fval<fup
        fup=fval;
        pindopt=pind;
    end
    
    [pind,rect(ii,2)]=assign_prog(-U(:,ii),Nx,Ny);

    rect(ii,2)=-rect(ii,2);%max  

    fval=sum(b(pind))-sum(U(pind,:)).^2*V;
    
    if fval<fup
        fup=fval;
        pindopt=pind;
    end
end

%%%

% disp('begin brach and bound algorithm')

set_rec=rect_recurse_subdivide(V,rect,Nexp); %size Nt x (2*2^expo) with every two columns as a rectangle
size(set_rec);

setrec=[];
for ii=1:size(set_rec,2)/2
    setrec(ii).rec=set_rec(:,2*(ii-1)+1:2*ii);
    setrec(ii).dpt=0;
end
setind=1:length(setrec); %indices of active rectangles

depth=0;

Npara=2^(Nexp); %-1); %number of rectangles considered for subdivision in each iteration
while depth<=depth0%11%4,8

    rect=[setrec(setind).rec];    
    rect=reshape(rect,size(rect,1),2,[]);
    [pind,flin,fval]=rect_underestimator_LAPJV_parallel(b,U,V,rect,Nx,Ny);%fast implementation for getting upper and lower bounds

        
    iter=0;
    for ii=setind
        iter=iter+1;
        setrec(ii).lb=flin(iter);%update lower bound 
        if fval(iter)<fup
            fup=fval(iter);%update upper bound
            pindopt=pind(:,iter);%update solution
            %
            if fig>0
                perm=pindopt-(0:Nx-1)'*Ny;
                match_err=plot_match_result(X,Y,perm,fig);
            end
        end
    end
    


    setrec=setrec([setrec(:).lb]<fup-err0); %prune unlikely rectangles
    
    if isempty(setrec)
        break;
    end
    
%     assert(~(length(setrec(:))-length([setrec(:).lb])))

    
    [~,indst]=sort([setrec(:).lb]);
    
    
    Ndiv=min(length(indst),Npara);
    splitset=indst(1:Ndiv);
    
    
    setind=[];
    for indlow=splitset
        rect=setrec(indlow).rec;
        depth=setrec(indlow).dpt;
        
        %decide which dimension to split
        dif=V.*(rect(:,2)-rect(:,1)).^2;
        [~,ind]=max(dif);
        %new rectangulars
        recti=repmat(rect,[1,1,2]);
        half=mean(rect(ind,:));
        recti(ind,2,1)=half;
        recti(ind,1,2)=half;
        %        
        for ii=1:2
            setrec(end+1).rec=recti(:,:,ii);
            %         setrec(end).lb=inf;
            setrec(end).dpt=depth+1;
            
            setind=[setind, length(setrec)];
        end
    end
    
    setrec(splitset)=[];%eliminate parent rectangle
    setind=setind-Ndiv;

end

depth;


