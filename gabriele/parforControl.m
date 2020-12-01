function [u,cond] = parforControl(cond,Tc,agent,X0,index,index2,umax,ymax,r,rEndEll,disturbance)

    if cond
        u=[0;0];
        k=0;
        return
    end
    cond=true;
% cond=false
    
    [Ad,Bd,rif,X0]=getParameters(Tc,agent,X0,index,index2,r-disturbance);
    DX3=atan2(sin(X0(3)-rif(3)),cos(X0(3)-rif(3)));
    DX=X0-rif;DX(3)=DX3;
    [~,k,problem]=kothare({Ad},{Bd},umax,ymax,DX,r);
    
    if ~problem
        u=0;
        k=0;
         closeAll(elisa,vid)
        error('errore')
    end
    
    u=k*DX;
    
    if abs(size(agent,2)-index)>10 || norm(X0(1:2)-agent(:,end))>rEndEll
        cond=false;
    end
end

