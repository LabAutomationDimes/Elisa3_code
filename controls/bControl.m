function [v,w]=bControl(xR,yR,thetaR,xD,yD,xD1,yD1,b,K1,K2)

nAgents=length(xR);
v=zeros(nAgents,1);
w=zeros(nAgents,1);

for i=1:nAgents
    xB = xR(i)+b*cos(thetaR(i));
    yB = yR(i)+b*sin(thetaR(i));
    
    Vxb = xD1(i)+K1*(xD(i)-xB);
    Vyb = yD1(i)+K2*(yD(i)-yB);
    
    T=[cos(thetaR(i)) sin(thetaR(i)); -sin(thetaR(i))/b cos(thetaR(i))/b];
    aux=T*[Vxb;Vyb];
    
    v(i)=aux(1);
    w(i)=aux(2); 
    
    w(i)=mod(w(i),2*pi);
    if w(i)>pi
        w(i)=w(i)-2*pi;
    end
end






