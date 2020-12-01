function [u,cond] = parforOrientate(cond,X0,rif,Tc,umax,ymax,r,i)

    DX3=atan2(sin(X0(3)-rif(3)),cos(X0(3)-rif(3)));
    if cond || abs(DX3)<=deg2rad(10)
        u=[0;0];
        cond=true;
        return
    end
    cond=true;
    
%     theta=atan2(agent(2,index)-X0(2),agent(1,index)-X0(1));
    if X0(3)<0
        X0(3)=X0(3)+2*pi;
    end
    if X0(3)<rif(3) && rif(3)-X0(3)>pi
        rif(3)=rif(3)-2*pi;
    elseif X0(3)>rif(3) && X0(3)-rif(3)>pi
        X0(3)=X0(3)-2*pi;
    end
% 
    rif=[X0(1:2);rif(3)];

    Ad=eye(3);
    Bd=[cos(rif(3))*Tc   0
        sin(rif(3))*Tc   0
        0               Tc];
    
    DX3=atan2(sin(X0(3)-rif(3)),cos(X0(3)-rif(3)));
    DX=X0-rif;DX(3)=DX3;
    [~,k,problem]=kothare({Ad},{Bd},umax,ymax,DX,r);
    u=k*DX;
%     if abs(DX3)>deg2rad(10)
%         [i abs(DX3)>deg2rad(10) rad2deg(DX3) rad2deg(X0(3)) rad2deg(rif(3))]
%     end
    if abs(DX3)>deg2rad(10) %|| norm(X0(1:2)-rif(1:2))>0.005
        cond=false;
    end

end