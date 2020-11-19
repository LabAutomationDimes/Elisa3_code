%% example_script.m
clear all;
close all;
clc;
%% parameters
port='3459';
Tsim=5;
%%


tTot=0;
zTot=[];


portK=ports{k};
elisa=(port);
elisa.resetOdom(0,0,0);



while 1==1
    tic;
    
    
    %% LOOP
    z=zeros(nR,3);
    for k=1:nR
        [x,y,theta]=elisas(k).getOdom();
        z(k,:)=[x y theta];    
    end
    if isempty(zTot)
        zTot=z;
    else
        zTot(:,:,end+1)=z;
    end
    
    for k=1:nR
        portK=ports{k};
        elisas(k).setSpeed(wR,wL,0);
    end

    
    %%
    
    tTot=tTot+toc;
    if tTot>=Tsim
        break;
    end
end

for k=1:nR
     elisas(k).stop();
end

xRob = squeeze(zTot(1,1,:));
yRob = squeeze(zTot(1,2,:));

figure(1);
plot(xRob,yRob); grid;

figure(2);
subplot(211), plot(xRob); grid;
subplot(212), plot(yRob); grid;


