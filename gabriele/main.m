clear
clc
close all

%addpath('.\utilities');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
createVIDEO=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% c = parcluster('local');
% j = createJob(c);
% j.AutoAttachFiles = true;

port  = {
%    '3430',... %1
%     '3438',... %2
     '3449',... %3
%     '3459',... %4
%   '3526',... %5
%   '3594',... %6
    };

if createVIDEO
    writerObj = VideoWriter('videoSWARMBlack.avi');
    open(writerObj);
end

nAgents = length(port);

elisa=[];
for i=1:nAgents
    elisa=[elisa; Elisa3(port{i})];
end
vid=VideoServer(nAgents,0,0);

%% Costruzione della traiettoria
disp('Costruzione traiettoria in corso...')

% Start video tracking
vid.startTrack(elisa);

% Initial conditions registerd by rgb cam
vid.updateAgents();
% nAgent x 3 matrix. 1st col x, 2nd y, 3rd theta.
X0 = vid.getAgentsState()';  

r_robot=0.025;
r=r_robot+0.03;
M=-0.00004*eye(2);%[0.000001 0; 0 1];
tic
agents=pathDesign(r,0.9,M,X0(1:2,:)); %(r,beta,M,agents_0)
t=toc
% load path8

plotPath
waitforbuttonpress

n=size(agents,2);

umax=[0.01;deg2rad(30)];
disturbance=[0.01; 0.01; deg2rad(0)];
ymax=[r-r_robot-disturbance(1)  0                           0
      0                         r-r_robot-disturbance(2)    0
      0                         0                           deg2rad(360)-disturbance(3)];

rEndEll=0.005;

Tc=0.5;
%% Tracking

xseq={};
useq={};
for i=1:n
    xseq{i}=[];
    useq{i}=[];
end  
if length(elisa)>1
 disp('Orientamento in corso...')
orientate
end

disp('Tracking avviato...')
endCond=false;
cond=zeros(1,n);
loopsTime=zeros(1,2000); loopsCounter=1;
sendTime=zeros(1,2000); 
index=1;
i=1;
while ~endCond
    tic
    endCond=true;
    RGB=vid.updateAgents();
    X0=vid.getAgentsState()';
    if createVIDEO
        frame=im2frame(RGB);
        writeVideo(writerObj, frame);
    end
    
    index=maxIndex(agents,X0,index,(r-r_robot-norm(disturbance(1:2))));
    X02=getX0(agents,index);
    index2=maxIndex(agents,X02,index,(r-r_robot-norm(disturbance(1:2))));
    parfor i=1:n
        xseq{i}=[xseq{i} X0(:,i)];
        [u(:,i),cond(i)]=parforControl(cond(i),Tc,agents{i},X0(:,i),index,index2,umax,ymax,r-r_robot,rEndEll,norm(disturbance(1:2)));
        useq{i}=[useq{i} u(:,i)];
    end
    for i=1:n
        endCond=endCond && cond(i);
    end
    if length(elisa)>1
        toc1=toc;
        Elisa3.setSpeedNRobotsND(elisa,u(1,:),u(2,:),0,0);
        sendTime(loopsCounter)=toc-toc1;
    else
        toc1=toc;
        elisa(1).setSpeed(u(1,:),u(2,:),0,0);
        sendTime(loopsCounter)=toc-toc1;
    end
     loopsCounter=loopsCounter+1;
    
%     clear ans
%     time(size(time,2)+1)=toc;
% %     time(end)
%     if(time(end)>Tc)
%         [time(end) toc2-toc1]
% %         toc2-toc1
% %         break
%     end

    loopsTime(loopsCounter)=toc;
    
    if Tc-loopsTime(loopsCounter)>0
        pause(Tc-loopsTime(loopsCounter));
    end
    
end
global elisaTMP;
elisaTMP.disconnect();
closeAll(elisa,vid)
if createVIDEO
    close(writerObj);
end

figure
stairs(loopsTime); grid on;

plotPath; hold on; grid on;
for i=1:nAgents
    plot(xseq{i}(1,:),xseq{i}(2,:)); 
end