%% function[]=setSpeed(elisa3,wR,wL,isRadS,iswRwL)
%
% wR=right wheel speed (m/s or rad/s) OR robot center speed (m/s) 
% wL=left  wheel speed (m/s or rad/s) OR robot rotation speed (rad/s)
% isRadS=1 if wR,wL[=]rad/s, 0 if wR,wL[=]m/s (not used if iswRwL=0)
% iswRwL=1(default) if the inputs are right wheel speed and left wheel speed, 
%        0 if the inputs are robot center speed and robot rotation speed
%%

function[]=setSpeed(elisa3,wR,wL,isRadS,iswRwL)
if nargin==4
    iswRwL=1;
end
if iswRwL==0
    v=wR;
    w=wL;
    wRwL=elisa3.M_vw2wRwL*[v;w];
    wR=wRwL(1)*elisa3.wheelRadius;
    wL=wRwL(2)*elisa3.wheelRadius;
else
    if isRadS==1
       wR=wR*elisa3.wheelRadius;
       wL=wL*elisa3.wheelRadius;
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
%
elisa3.connect();
elisa3.ePic=set(elisa3.ePic,'speed',[wL wR]);
elisa3.ePic=update(elisa3.ePic);
elisa3.disconnect();
end