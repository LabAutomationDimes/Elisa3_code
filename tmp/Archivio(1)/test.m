clc
clear
close all
global nAgents rawMean tol

% load dataFrames2;
load('C:\Users\Luigi\Desktop\dataFrames1.mat');
%% VARS
nFrames = length(frames);
nAgents = 4;
traj    = zeros(nAgents,nFrames,2);
raw     = zeros(nAgents,nFrames,2);
rawMean = [35 21];
tol     = 5;

trajectories = zeros(nFrames,nAgents,2);

trajK1=[];
rawK1=[];
for k=1:nFrames
    imgRGB = frames(k).rgb;
    imgIR  = frames(k).ir;

    [trajK2,rawK2]=getPosAgents(imgIR,trajK1,rawK1);
    
    
    
    
 %     if ~collision
        RGB=imgRGB;
    %     RGB=uint8(auxIR1)*256;
%         RGB=uint8(auxIR2)*256;
        for i=1:nAgents
            RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,1)],'LineWidth',2,'Color','blue');
            RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,2)],'LineWidth',2,'Color','red');
            RGB=insertText(RGB,trajK2(i,:),num2str(i));
        end

        figure(1); hold on;
        imshow(RGB);
        hold off;
%     end   
    
    pause(0.001);
    
    trajK1=trajK2;
    rawK1=rawK2;
    
end