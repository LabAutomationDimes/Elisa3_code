%% STATIC: setSpeedNRobots(ports,wRvec,wLvec,isRadS,iswRwL);
%
% wR=right wheel speed (m/s or rad/s) OR robot center speed (m/s) 
% wL=left  wheel speed (m/s or rad/s) OR robot rotation speed (rad/s)
% isRadS=1 if wR,wL[=]rad/s, 0 if wR,wL[=]m/s (not used if iswRwL=0
% iswRwL=1(default) if the inputs are right wheel speed and left wheel speed, 
%        0 if the inputs are robot center speed and robot rotation speed
%%

function[]=setSpeedNRobots(elisas,wRvec,wLvec,isRadS,iswRwL)
N=length(elisas);
speedsRL=zeros(N,2);
for i=1:N
    wR=wRvec(i);
    wL=wLvec(i);
    if iswRwL==0
        v=wR;
        w=wL;
        wRwL=Elisa3.M_vw2wRwL*[v;w];
        wR=wRwL(1)*Elisa3.wheelRadius;
        wL=wRwL(2)*Elisa3.wheelRadius;
    else
        if isRadS==1
            wR=wR*Elisa3.wheelRadius;
            wL=wL*Elisa3.wheelRadius;
        end
    end
    %%wR[=]m/s and wL[=]m/s;
    %{
Right, Left motors: speed expressed in 1/5 of mm/s
(i.e. a value of 10 means 50 mm/s);
MSBit indicate direction: 1=forward, 0=backward; values from 0 to 127
    %}
    %from m/s to mm/s
    wR=wR*1000;wL=wL*1000;
    %from mm/s to elisa3 speed format
    wR=round(wR/5);wL=round(wL/5);
    %saturation
    if abs(wR)>127
        wR=sign(wR)*127;
        disp('saturation');
    end
    if abs(wL)>127
        wL=sign(wL)*127;
        disp('saturation');
    end
    speedsRL(i,:)=[wR wL];
end
elisaTMP=Elisa3(elisas(1).port);
elisaTMP.connect();
% Elisa3.connectS(elisaTMP);
elisaTMP.ePic=updateNRobots(elisaTMP.ePic,elisas,speedsRL);
elisaTMP.disconnect();
end