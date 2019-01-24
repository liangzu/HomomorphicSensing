
%display ground truth matching between marked points in images

clear



objects={'motobike',
    'car'
    'eiffel'
    'revolver'
    };



ind_img={[3 6 8 13 14 15]
    [2 5 7 9 19 11]   %11
    [0 1 3 4 7 20] %6
    [0 4  6 7 9 21] %2 3 5
    };
%%%%%%





cate0=1;
indy0=2;



%2-6
for cate=cate0:length(ind_img)
    
    load([objects{cate},'/data_',objects{cate},'_match']);
    
    indx=1;
    eval(['X=X',num2str(ind_img{cate}(indx)),';']);
    
    
    
    
    if cate>cate0
        indy00=2;
    else
        indy00=indy0;
    end
    
    
    cate
    for indy=indy00:length(ind_img{cate})
        indy
        
        
        
        
        eval(['Y=X',num2str(ind_img{cate}(indy)),';']);
        
        
        imX=imread([objects{cate},'/', num2str(ind_img{cate}(indx)),'.jpg']);
        imY=imread([objects{cate},'/', num2str(ind_img{cate}(indy)),'.jpg']);
        
        P=eye(size(X,1),size(Y,1)); %ground truth point matching matrix
        pind=find(reshape(P',[],1));
        
        if cate==3
            plot_image_point_corres(imX,imY,X,Y,pind,1)
        else
            plot_image_point_corres_vert(imX,imY,X,Y,pind,1)
        end
        

        
        pause(1)     
        
        
        
    end
end