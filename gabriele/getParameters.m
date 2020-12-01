function [Ad,Bd,rif,xInitial] = getParameters(Tc,path,xInitial,i,i2,r)

%     theta=atan2(path(2,i)-xInitial(2),path(1,i)-xInitial(1));
% 
%     if xInitial(3)<0
%         xInitial(3)=xInitial(3)+2*pi;
%     end
%     if xInitial(3)<theta && theta-xInitial(3)>pi
%         theta=theta-2*pi;
%     elseif xInitial(3)>theta && xInitial(3)-theta>pi
%         xInitial(3)=xInitial(3)-2*pi;
%     end

%     rif=[path(1,i);path(2,i);theta];

    if norm(xInitial(1:2)-path(:,i))<=r && norm(xInitial(1:2)-path(:,i))>norm(xInitial(1:2)-path(:,i+1))
        theta=atan2((path(2,i2)-path(2,i)),(path(1,i2)-path(1,i)));
        
        if xInitial(3)<0
            xInitial(3)=xInitial(3)+2*pi;
        end
        if xInitial(3)<theta && theta-xInitial(3)>pi
            theta=theta-2*pi;
        elseif xInitial(3)>theta && xInitial(3)-theta>pi
            xInitial(3)=xInitial(3)-2*pi;
        end
        rif=[xInitial(1:2);theta];
    else
        theta=atan2((path(2,i)-xInitial(2)),(path(1,i)-xInitial(1)));
        
        if xInitial(3)<0
            xInitial(3)=xInitial(3)+2*pi;
        end
        if xInitial(3)<theta && theta-xInitial(3)>pi
            theta=theta-2*pi;
        elseif xInitial(3)>theta && xInitial(3)-theta>pi
            xInitial(3)=xInitial(3)-2*pi;
        end

        rif=[path(1,i);path(2,i);theta];
    end

    Ad=eye(3);
    Bd=[cos(theta)*Tc   0
        sin(theta)*Tc   0
        0               Tc];
end