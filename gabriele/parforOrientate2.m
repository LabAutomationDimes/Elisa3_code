function [u,cond] = parforOrientate2(cond,X0,rif)

    DX3=atan2(sin(X0(3)-rif(3)),cos(X0(3)-rif(3)));
    if cond || abs(DX3)<=deg2rad(10)
        u=0;
        cond=true;
        return
    end
    cond=true;
    
    if X0(3)<0
        X0(3)=X0(3)+2*pi;
    end
    if X0(3)<rif(3) && rif(3)-X0(3)>pi
        rif(3)=rif(3)-2*pi;
    elseif X0(3)>rif(3) && X0(3)-rif(3)>pi
        X0(3)=X0(3)-2*pi;
    end
    
    DX3=atan2(sin(X0(3)-rif(3)),cos(X0(3)-rif(3)));
    u=DX3/2;
    
    if abs(DX3)>deg2rad(10)
        cond=false;
    end

end

