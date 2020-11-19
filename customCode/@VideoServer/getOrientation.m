function orientation=getOrientation(trajK2,rawK2,imgRGB,imgIR,nAgents,rawMean,tol)
parameters;

thr=DilationThrOrientation;
[BW1,auxIR1]=VideoServer.imgThresholdDilate(imgIR,thr,1);
offsetIR=[-10 -4];
auxIR1=imtranslate(auxIR1,offsetIR);


[centers,radii1,radii2]=VideoServer.findAgents(auxIR1);

CC  = bwconncomp(auxIR1);
S   = regionprops(CC,'Centroid','Area');
nRd = size(S,1);
centers=zeros(nRd,2);
area=zeros(nRd,1);
for i=1:nRd
    centers(i,:)=S(i).Centroid;
    area(i)=S(i).Area;
end

orientation=zeros(nAgents,4);
D=zeros(nAgents,nRd);
for i=1:nAgents
    for j=1:nRd
        D(i,j)=norm(trajK2(i,:)-centers(j,:));
    end
    [v,c1]=min(D(i,:));
    D(i,c1)=inf;
    [v,c2]=min(D(i,:));
    D(i,c2)=inf;
    [v,c3]=min(D(i,:));
    D(i,c3)=inf;

    s12=norm(centers(c1,:)-centers(c2,:));
    s13=norm(centers(c1,:)-centers(c3,:));
    s23=norm(centers(c2,:)-centers(c3,:));

    if norm(s12-s13)<5
        orientation(i,:)=[centers(c1,:) (centers(c2,:)+centers(c3,:))/2];
    elseif norm(s12-s23)<5
        orientation(i,:)=[centers(c2,:) (centers(c1,:)+centers(c3,:))/2];
    else
        orientation(i,:)=[centers(c3,:) (centers(c1,:)+centers(c2,:))/2];
    end

%         RGB=255*uint8(auxIR1);
%         RGB=insertShape(RGB,'Circle',[trajK2(i,:) 2],'LineWidth',2,'Color','red');
%         RGB=insertShape(RGB,'Circle',[centers(c1,:) 2],'LineWidth',2,'Color','red');
%         RGB=insertShape(RGB,'Circle',[centers(c2,:) 2],'LineWidth',2,'Color','red');
%         RGB=insertShape(RGB,'Circle',[centers(c3,:) 2],'LineWidth',2,'Color','red');
%         RGB=insertShape(RGB,'Line',orientation(i,:),'LineWidth',2,'Color','green');
%         RGB=insertShape(RGB,'Circle',[orientation(i,3:4) 3],'LineWidth',4,'Color','green');
%         figure(1); hold on;
%         imshow(RGB);
%         title(num2str(k));
%         hold off;
%         pause
%         
end

