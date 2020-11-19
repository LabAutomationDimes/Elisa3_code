%% function[]=turnOnIR(elisa3,turnOnIRoptions_flag)
%%turnOnIRoptions_flag = turnOnIRoptions_FrontTwo;
%                        turnOnIRoptions_RearOne;
%                        turnOnIRoptions_All;
%                        turnOnIRoptions_turnOff
%
function[]=turnOnIR(elisa3,turnOnIRoptions_flag)
switch turnOnIRoptions_flag
    case elisa3.turnOnIRoptions_FrontTwo
        v=[0 1];
    case elisa3.turnOnIRoptions_RearOne
        v=[1 0];
    case elisa3.turnOnIRoptions_All
        v=[1 1];
    case elisa3.turnOnIRoptions_turnOff
        v=[0 0];
end
elisa3.connect();
elisa3.ePic=set(elisa3.ePic,'irtx',v);
elisa3.ePic=update(elisa3.ePic);
elisa3.disconnect();
end