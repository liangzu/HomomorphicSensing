function [err_background,err_Hausdorff,Xtran]=plot_match_result(X,Y,Pind,fig,Ptruth)
%%%plot matching result
Nx=size(X,1);Ny=size(Y,1);
% 
if isempty(Pind)
    Xtran=X;
else
    Xe=[X ones(Nx,1)];%%homogenous coordinate
    % inv(Xe'*Xe)*(Xe'*Y(Pind,:))
    Xtran=Xe*inv(Xe'*Xe)*(Xe'*Y(Pind,:));%%affinely transformed model point set      match_err=plot_match_result(P,Q,perm,fig);  
end

if nargin==5%~isempty(Ptruth)
    errdif=Xtran-Ptruth*Y;
else
    errdif=Xtran(1:min(Nx,Ny),:)-Y(1:min(Nx,Ny),:);
    %errdif=Xtran(1:min(Nx,Ny),:)-Y(Pind,:);
%    errdif=Xtran(Pind,:)-Y(1:min(Nx,Ny),:);
end
err_background=mean(sqrt(sum(errdif.^2,2)));
if nargout==2
    err_Hausdorff=mean_Hausdorff(Xtran(1:min(Nx,Ny),:),Y(1:min(Nx,Ny),:));
end

Dmax=max([Y;Xtran]);Dmin=min([Y;Xtran]);
center=mean([Dmin;Dmax]);
width=max(Dmax-Dmin);

if nargin<4
    figure;
else
    if fig<=0
        return;
    else
        figure(fig);
    end
end

%%%%%%%%%%plot matching result
switch size(Y,2)
    case 2  %%2D
        set(gca, 'Position',[0,0,1,1]);cla;hold on;
        axis([center(1)-width/2,center(1)+width/2,center(2)-width/2,center(2)+width/2]);
        axis off;

        if Nx<Ny
            plot(Y(1:Nx,1),Y(1:Nx,2),'b+',Y(Nx+1:Ny,1),Y(Nx+1:Ny,2),'b+','LineWidth',3);%%target
        else
            plot(Y(:,1),Y(:,2),'b+','LineWidth',3);
        end
        plot(Xtran(:,1),Xtran(:,2),'r*','LineWidth',3); %%transformed model

        if ~isempty(Pind)
            plot([Xtran(:,1) Y(Pind,1)]',[Xtran(:,2),Y(Pind,2)]','k-','LineWidth',2); %%%%line segments
        end
       
    case 3  %%3D
        %%%%%3d plot

        set(gca, 'Position',[0,0,1,1]);
        cla;        hold on;
        
        plot3(Y(:,1),Y(:,2),Y(:,3),'b+',Xtran(:,1),Xtran(:,2),Xtran(:,3),'ro','linewidth',2);
        
       axis tight            
       axis off
end
drawnow