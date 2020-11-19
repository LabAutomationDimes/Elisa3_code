clc
clear
close all
rawMean = [14 11]; %%RGB 
tol     = 10;


load dataFrames1;

delay=[0 0];


nAgents = 4;
nFrames = length(frames);

for k=1:1
    imgRGB = frames(k).rgb;
    imgIR  = frames(k).ir;

    thr=220/255;
    [BW1,auxRGB1]=imgThresholdErode(imgRGB,thr,5);
    [centersRGB,radiiRGB1,radiiRGB2]=findAgents(auxRGB1);

    thr=40/255;
    [BW1,auxIR1]=imgThresholdDilate(imgIR,thr,15);
    [cIR,radiiIR1,radiiIR2]=findAgents(auxIR1);
    nAd=length(radiiIR1);
    
    %%% Filter
    %--------------------------------------------------------------------
    nAd=size(centersRGB,1);
    indexNotAg=[];
    for i=1:nAd
        ratRad=radiiRGB1(i)/radiiRGB2(i);
        c1=norm(radiiRGB1(i)-rawMean(1));
        c2=norm(radiiRGB2(i)-rawMean(2));
        if ratRad<0.2 || ratRad>2 ||...
            c1 > tol || c2 > tol
            indexNotAg=[indexNotAg; i];
        end
    end
    centersRGB(indexNotAg,:)=[];
    radiiRGB1(indexNotAg)=[];
    radiiRGB2(indexNotAg)=[];

    
    
    couple=findCouples(centersRGB,cIR);
    for i=1:nAgents
        centersIR(i,:)=cIR(couple(i),:)+delay;
    end
    
    RGB=imgIR;
    for i=1:nAgents
%         RGB=insertShape(RGB,'Circle',[centersRGB(i,:) radiiRGB1(i)],'LineWidth',2,'Color','blue');
%         RGB=insertShape(RGB,'Circle',[centersRGB(i,:) radiiRGB2(i)],'LineWidth',2,'Color','red');
        RGB=insertShape(RGB,'Circle',[centersRGB(i,:) 1],'LineWidth',2,'Color','red');
        RGB=insertShape(RGB,'Circle',[centersIR(i,:) 1],'LineWidth',2,'Color','blue');
    end
    
    figure(1); hold on;
    imshow(RGB);
    title(num2str(k));
    hold off;
    
    figure(2), imshow(imgRGB);
    
end

