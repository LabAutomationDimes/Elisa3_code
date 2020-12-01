index=maxIndex(agents,X0,1,(r-r_robot-disturbance(1)));
endCond=false;
cond=zeros(1,n);

rifO=zeros(size(X0,1),n);
for i=1:n
    rifO(:,i)=getRifO(agents{i},index,X0(:,i));
end

while ~endCond
    tic
    endCond=true;
    RGB=vid.updateAgents();
    if createVIDEO
        frame = im2frame(RGB);
        writeVideo(writerObj, frame);
    end
    
    X0=vid.getAgentsState()';
    parfor i=1:n
        xseq{i}=[xseq{i} X0(:,i)];
        [u(:,i),cond(i)]=parforOrientate(cond(i),X0(:,i),rifO(:,i),Tc,umax,ymax,r-r_robot,i);
    end
    for i=1:n
        endCond=endCond && cond(i);
    end
    
    clear ans
    Elisa3.setSpeedNRobotsND(elisa,u(1,:),u(2,:),0,0);
    time=toc;
    pause(Tc-time);
end