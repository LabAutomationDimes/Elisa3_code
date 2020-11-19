function[v,w]=linearized_error_model_control2(x,y,theta,xref,yref,thetaref,xdotref,ydotref,thetadotref,zeta,a)
k1=2*zeta*a;k3=k1;
wr=thetadotref;
vr=sqrt(xdotref^2+ydotref^2);
R=[
    cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0 0 1];

e1=xref-x;
e2=yref-y;
dt=thetaref-theta;
e3=atan2(sin(dt),cos(dt));
ee=R*[e1;e2;e3];
e1=ee(1);
e2=ee(2);
e3=ee(3);


if abs(vr)<=0.001    
    u1=0;
    u2=0;
else
    k2=(a^2-wr^2)/vr;
    u1=-k1*e1;
    u2=-k2*e2-k3*e3;
end


v=vr*cos(e3)-u1;
w=wr-u2;

end