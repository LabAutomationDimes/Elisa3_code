clear
clc
close all

addpath('.\utilities');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
createVIDEO=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SIMULATION = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

port  = {
%     '3430',...
    '3438',...
%     '3449',...
%     '3459',...
%     '3594',...
%     '3526',...
    };

nAgents = length(port);

elisa = [];
for i=1:nAgents
    elisa=[elisa; Elisa3(port{i})];
end
vid   = VideoServer(nAgents,1,0);

%% Costruzione della traiettoria
disp('Costruzione traiettoria in corso...')

% Start video tracking
vid.startTrack(elisa);

% Initial conditions registerd by rgb cam
vid.updateAgents();
% nAgent x 3 matrix. 1st col x, 2nd y, 3rd theta.
X0 = vid.getAgentsState()';  

r=0.045;
r_robot=0.025;
agents=pathDesign(r,0.5,-0.00004*eye(2),X0(1:2,:)); %(r,beta,M,agents_0)

plotPath
waitforbuttonpress

n=size(agents,2);

umax=[0.02;deg2rad(30)];
disturbance=[0; 0; 0];
ymax=[r-r_robot-disturbance(1)  0                           0
      0                         r-r_robot-disturbance(2)    0
      0                         0                           deg2rad(360)-disturbance(3)];

rEndEll=0.005;

Tc=0.5;
%% Simulazioni
disp('Avvio in corso...')

xseq={};
useq={};
for i=1:n
    xseq{i}=[];
    useq{i}=[];
end

cond=false;
index=1;
i=1;

index=maxIndex(agents,X0,index,(r-r_robot-disturbance(1)));
[k,rif,problem,ell]=getControl(Tc,agents{i},X0(:,i),index,umax,ymax,r-r_robot);

while ~cond
    tic
%     cond=true;
%     vid.updateAgents();
%     X0 = vid.getAgentsState()';
%     if index>1 && ~isinternal(ell,X0)
%         closeAll(elisa,vid)
%         error('errore')
%     end
%     index=maxIndex(agents,X0,index,(r-r_robot-disturbance(1)));
% %     parfor i=1:n
%         xseq{i}=[xseq{i} X0(:,i)];
%         [u(:,i),problem,ell]=getControl(Tc,agents{i},X0(:,i),index,umax,ymax,r-r_robot);
%         useq{i}=[useq{i} u(:,i)];
%         
        if ~problem
            closeAll(elisa,vid)
            error('errore')
        end
%         if norm(X0(1:2,i)-agents{i}(:,end))>rEndEll
%             cond=false;
%         end
%     end

    vid.updateAgents();
    X0 = vid.getAgentsState()';
    xseq{i}=[xseq{i} X0(:,i)];
    u=k*(X0-rif);
    Elisa3.setSpeedNRobots(elisa,u(1,:),u(2,:),0,0);
    time=toc
    pause(Tc-time);
end
closeAll(elisa,vid)