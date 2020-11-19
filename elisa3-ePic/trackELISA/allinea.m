clc
clear
close all

load dataFrames1;
nAgents = 4;

%% VARS
nFrames = length(frames);

imgRGB = frames(1).rgb;
imgIR  = frames(1).ir;

    

thr=220/255;
[BW1,auxRGB1]=imgThresholdErode(imgRGB,thr,1);

thr=100/255;
[BW1,auxIR1]=imgThresholdDilate(imgIR,thr,1);
auxIR1=imtranslate(auxIR1,[-10 -4]);



figure(1), imshow(auxRGB1);
figure(2), imshow(1-auxIR1);

figure(3), hold on; 
imshow((1-auxIR1).*auxRGB1);
hold off

