function [rif] = getRifO(agent,index,X0)

    theta=atan2(agent(2,index)-X0(2),agent(1,index)-X0(1));
    if X0(3)<0
        X0(3)=X0(3)+2*pi;
    end
    if X0(3)<theta && theta-X0(3)>pi
        theta=theta-2*pi;
    elseif X0(3)>theta && X0(3)-theta>pi
        X0(3)=X0(3)-2*pi;
    end

    rif=[agent(:,1);theta];
    
end

