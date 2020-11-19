%% function[]=setColor(elisa3,rgbColor)
% rgbColor = three elements vector, each element is in [0,1];
%
function[]=setColor(elisa3,rgbColor)
rgbColor=rgbColor(:)'*100;
elisa3.connect();
elisa3.ePic=set(elisa3.ePic,'rgb', rgbColor);
elisa3.ePic=update(elisa3.ePic);
elisa3.disconnect();
end