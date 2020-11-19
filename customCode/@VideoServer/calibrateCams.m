function[]=calibrateCams(videoServer)
img=snapshot(videoServer.RGBcam);

h=figure();
while 1==1
    cla;
    imshow(img);
    disp('----------------------------');
    disp('click on P1,...,P3, in the order and double click on P4');
    disp('----------------------------');
    disp('P4-------------------------P3');
    disp('|                          |');
    disp('|                          |');
    disp('|                          |');
    disp('|                          |');
    disp('P1-------------------------P2');
    disp('----------------------------');
    [x,y]=ginput(4);
    Px1=[x(1) y(1)];
    Px2=[x(2) y(2)];
    Px3=[x(3) y(3)];
    Px4=[x(4) y(4)];
    hold on;
    plot(Px1(1),Px1(2),'xr','LineWidth',3);text(Px1(1),Px1(2),'P1','FontSize',20);
    plot(Px2(1),Px2(2),'xr','LineWidth',3);text(Px2(1),Px2(2),'P2','FontSize',20);
    plot(Px3(1),Px3(2),'xr','LineWidth',3);text(Px3(1),Px3(2),'P3','FontSize',20);
    plot(Px4(1),Px4(2),'xr','LineWidth',3);text(Px4(1),Px4(2),'P4','FontSize',20);
    
    choice=input('Selection OK, 1=true, other=false');
    if choice
        break;
    end
end
width=input('insert distance in meters between P1 and P2');
height=input('insert distance in meters between P1 and P4');



close(h);

save('cameraCalibrationParameters.mat','Px1','Px2','Px3','Px4','height','width');
end
           