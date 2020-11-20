%% function[]=startTrack(videoServer,colors)
function[]=startTrack(videoServer,elisas)
%% per permettere alle telecamere di avviarsi
pause(5);

manualPos=zeros(videoServer.nAgents,2);
%% inizializzazione

for i=1:videoServer.nAgents
    elisas(i).setColor([0 0 0]);
end
pause(0.5);

h=figure(1);

% simple test to know the time taken by the snapshot command 
% images=cell(1,100);
% timesElapsed = zeros(1,100);
% for i=1:100
%     tic
%     images(i) = {snapshot(videoServer.RGBcam)};
%     timesElapsed(i) = toc;
% end

for i=1:videoServer.nAgents
    
    elisas(i).setColor([0.1 0 0]);
    pause(1);
    imgRGB = snapshot(videoServer.RGBcam); % time taken less than 4 ms
    imgRGB = imcrop(imgRGB,videoServer.rectCrop);

    figure(h);imshow(imgRGB);
    title(['Robot: ' num2str(i) ' - Port: ' elisas(i).port]);
    
    [xPos,yPos]=ginput(1);
    manualPos(i,:)=[xPos yPos];
    
    elisas(i).setColor([0 0 0]);
end

% for i=1:videoServer.nAgents
%     elisas(i).setColor([1 1 1]);
% %     elisa(i).turnOnIR(Elisa3.turnOnIRoptions_All);
% end
close(h);
pause(0.5);






if videoServer.enable_preview
    videoServer.preview_figure_handle=figure('name','video server preview');
end


videoServer.updateAgents();



%% find Agents
r1=20;
r2=10;
centers=videoServer.trajK1;

couple=VideoServer.findCouples(centers,manualPos);
tmpOr=videoServer.orientation;
oldRawK1=videoServer.rawK1;
for i=1:videoServer.nAgents
%     videoServer.trajK1(i,:) = centers(couple(i),:);
%     videoServer.rawK1(i,:) =  oldRawK1(couple(i),:);
%     videoServer.orientation(i,:) =  tmpOr(couple(i),:);
    
    videoServer.trajK1(couple(i),:) = centers(i,:);
    videoServer.rawK1(couple(i),:) =  oldRawK1(i,:);
    videoServer.orientation(couple(i),:) =  tmpOr(i,:);
end
%%




if videoServer.enable_auto_update
    start(videoServer.timerCam);
end
end