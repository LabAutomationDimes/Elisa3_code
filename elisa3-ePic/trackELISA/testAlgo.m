clc
clear
close all

%% id robot
port={'3430','3459'};
nAgents=length(port);

frames=[];

%% IR cam settings
cam1 = webcam('Microsoft LifeCam HD-3000');
cam1.ExposureMode = 'manual';
cam1.Exposure     = -9;
cam1.Brightness   = 150;
cam1.Resolution   = '640x480';

%% TRUST cam settings
cam2 = webcam('Trust Webcam');
cam2.Brightness = -64;
cam2.Contrast   = 64;

%% robot settings red led, IR open
ePic1=ePicKernel();
[ePic1,result]=connect(ePic1, port(1));

ePic1=set(ePic1,'rgb', [100 0 0]);
ePic1=set(ePic1,'irtx', [1 1]);
ePic1 = update(ePic1);
[ePic1,result] = disconnect(ePic1);

%%
ePic2=ePicKernel();
[ePic2,result]=connect(ePic2, port(2));

ePic2=set(ePic2,'rgb', [0 0 100]);
ePic2=set(ePic2,'irtx', [1 1]);
ePic2 = update(ePic2);
[ePic2,result] = disconnect(ePic2);


%%
preview(cam1);
preview(cam2);

pause

for i=1:10
    img1=snapshot(cam1);
    img2=snapshot(cam2);
    f.rgb = img2;
    f.ir  = img1;
    frames=[frames;f];  
end

closePreview(cam1);
closePreview(cam2);
%%

[ePic1,result]=connect(ePic1, port1);
ePic1=set(ePic1,'rgb', [0 0 0]);
ePic1=set(ePic1,'irtx', [0 0]);
ePic1=update(ePic1);
[ePic1,result] = disconnect(ePic1);

[ePic2,result]=connect(ePic2, port2);
ePic2=set(ePic2,'rgb', [0 0 0]);
ePic2=set(ePic2,'irtx', [0 0]);
ePic2=update(ePic2);
[ePic2,result] = disconnect(ePic2);

delete(cam1);
delete(cam2);

save('datiTest','frames');



