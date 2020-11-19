function[x,y,theta,up]=getOdom(elisa3)
elisa3.connect();
elisa3.ePic=update(elisa3.ePic);
% [pos,up]=get(elisa3.ePic,'pos');
[pos,up]=get(elisa3.ePic,'odom');
elisa3.disconnect();
x=pos(1)/1000; 
y=pos(2)/1000;
theta=mod(pos(3),360);
theta=theta*pi/180;
if theta>pi
    theta=theta-2*pi;
end
if theta<-pi
    theta=theta+2*pi;
end
end