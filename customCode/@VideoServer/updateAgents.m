function[imgRGB]=updateAgents(videoServer)
parameters;

imgRGB = snapshot(videoServer.RGBcam);

%imgIR  = snapshot(videoServer.IRcam);

[trajK2,rawK2,collision]=VideoServer.getPosRGB(imgRGB,videoServer.trajK1,videoServer.rawK1,videoServer.nAgents,RGB_rawMean,RGB_tol);
%videoServer.orientation=VideoServer.getOrientation(trajK2,rawK2,imgRGB,imgIR,videoServer.nAgents,RGB_rawMean,RGB_tol);


%%
% % % % % %     if ~isempty(videoServer.trajK1)
% % % % % %         currOrientation=zeros(videoServer.nAgents,4);
% % % % % %         for i=1:videoServer.nAgents
% % % % % %             theta=atan2(trajK2(i,2)-videoServer.trajK1(i,2),trajK2(i,1)-videoServer.trajK1(i,1));
% % % % % %             currOrientation(i,:)=[trajK2(i,:) trajK2(i,1)+40*cos(theta) trajK2(i,2)+40*sin(theta)];
% % % % % %         end
% % % % % %         if ~isempty(videoServer.orientation)
% % % % % %             currOrientation = 0.2*currOrientation+0.8*videoServer.orientation;
% % % % % %         end
% % % % % %         videoServer.orientation = currOrientation;
% % % % % %     end

[BW1,auxRGB1]=VideoServer.imgThresholdErode(imgRGB,ErosionThr,0);
r=15;
holes=zeros(videoServer.nAgents,3);
for i=1:videoServer.nAgents
    c=round(trajK2(i,:));
    for i1=c(2)-r:c(2)+r
        for j1=c(1)-r:c(1)+r
            p=uint8(auxRGB1(i1,j1));
            d=norm([j1,i1]-c);
            if d<=r && p==0
                holes(i,1:2)=holes(i,1:2)+[j1 i1];
                holes(i,3)=holes(i,3)+1;
            end 
        end
    end
    holes(i,1:2)=holes(i,1:2)/holes(i,3);
    
    videoServer.orientation(i,:)=[trajK2(i,:) holes(i,1:2)];
end


%%





RGB=imgRGB;
for i=1:videoServer.nAgents
    RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,1)],'LineWidth',2,'Color','blue');
    RGB=insertShape(RGB,'Circle',[trajK2(i,:) rawK2(i,2)],'LineWidth',2,'Color','red');
    RGB=insertText(RGB,trajK2(i,:),num2str(i));
    
    if ~isempty(videoServer.orientation)
        RGB=insertShape(RGB,'Line',videoServer.orientation(i,:),'LineWidth',2,'Color','green');
        RGB=insertShape(RGB,'Circle',[videoServer.orientation(i,3:4) 3],'LineWidth',4,'Color','green');
    end
    
%     if collision
%         RGB=insertText(RGB,[20 20],'Collision...');
%     end
end
videoServer.curFrame=RGB;

if videoServer.enable_preview
    figure(videoServer.preview_figure_handle);
    imshow(videoServer.curFrame);
end
videoServer.trajK1=trajK2;
videoServer.rawK1=rawK2;
end

