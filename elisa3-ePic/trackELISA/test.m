clc
clear
close all
global nAgents rawMean tol

% IR     = 1;
% RGB    = 2;
method   = 2;
estOr    = 1;

load dataFrames6;
nAgents = 6;

%% VARS
nFrames = length(frames);
traj    = zeros(nAgents,nFrames,2);
raw     = zeros(nAgents,nFrames,2);
orientation = [];

if method==1
    rawMean = [35 21]; %%IR
    tol     = 5;
elseif method==2
    rawMean = [14 11]; %%RGB   ?
    tol     = 10;
end

trajectories = zeros(nFrames,nAgents,2);

trajK1=[];
rawK1=[];


% vid=VideoWriter('video1');
% open(vid);

for k=1:nFrames
    imgRGB = frames(k).rgb;
    imgIR  = frames(k).ir;
    

    if method==2
        [trajK2,rawK2,collision]=getPosRGB(imgRGB,trajK1,rawK1);
    elseif method==1
        [trajK2,rawK2,collision]=getPosIR(imgIR,trajK1,rawK1);
    end
    
    if estOr
        orientation=getOrientation(trajK2,rawK2,imgRGB,imgIR);
    end


    RGB=imgRGB;
    for i=1:nAgents
        RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,1)],'LineWidth',2,'Color','blue');
        RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,2)],'LineWidth',2,'Color','red');
        RGB=insertText(RGB,trajK2(i,:),num2str(i));
        
        if ~isempty(orientation)
            RGB=insertShape(RGB,'Line',orientation(i,:),'LineWidth',2,'Color','green');
            RGB=insertShape(RGB,'Circle',[orientation(i,3:4) 3],'LineWidth',4,'Color','green');
        end
        
        if collision
            RGB=insertText(RGB,[20 20],'Collision...');
        end
    end
    figure(1); hold on;
    imshow(RGB);
    title(num2str(k));
    hold off;
    
% % % %     frame=getframe;
% % % %     writeVideo(vid,frame);

  
    pause(0.001);

    trajK1=trajK2;
    rawK1=rawK2;
    
end

% close(vid);
