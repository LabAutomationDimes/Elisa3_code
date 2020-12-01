% for i=1:n
%     figure
%     plot(tseq{i},0.01*ones(1,size(tseq{i},2)),'r')
%     hold on
%     plot(tseq{i},-0.01*ones(1,size(tseq{i},2)),'r')
%     plot(tseq{i},xseq{i}(3,:),'b')
%     plot(tseq{i},xseq{i}(4,:),'m')
%     grid
% end

figure

cond=true;
time=1;
hold on
% xlim([xLimL xLimU]);
ylim([0 0.6]);
xlabel('x [m]');
ylabel('y [m]');
% plot(projection(ell,[[1,0,0]',[0,1,0]']))
for i=1:n
    plot(agents{i}(1,1),agents{i}(2,1),'*r')
    plot(agents{i}(1,:),agents{i}(2,:),'--k')
    circle(xseq{i}(1,time),xseq{i}(2,time),r_robot,'r');
    q1=quiver(xseq{i}(1,time),xseq{i}(2,time),cos(xseq{i}(3,time)),sin(xseq{i}(3,time)));
    set(q1,'AutoScale','on','AutoScaleFactor',1/10,'LineWidth',1.5,'MaxHeadSize',3)
end
waitforbuttonpress
while cond
    cond=false;
    cla reset
    hold on
%     xlim([xLimL xLimU]);
    ylim([0 0.6]);
    xlabel('x [m]');
    ylabel('y [m]');
    for i=1:n
%         plot(projection(ell,[[1,0,0]',[0,1,0]']))
        plot(agents{i}(1,1),agents{i}(2,1),'*r')
        plot(agents{i}(1,:),agents{i}(2,:),'--k')
        if time<=size(xseq{i},2)
            circle(xseq{i}(1,time),xseq{i}(2,time),r_robot,'r');
            circle(xseq{i}(1,time),xseq{i}(2,time),r-r_robot-disturbance(1),'b');
            q1=quiver(xseq{i}(1,time),xseq{i}(2,time),cos(xseq{i}(3,time)),sin(xseq{i}(3,time)));
            set(q1,'AutoScale','on','AutoScaleFactor',1/10,'LineWidth',1.5,'MaxHeadSize',3)
            cond=true;
        else
            circle(xseq{i}(1,end),xseq{i}(2,end),r_robot,'r');
            circle(xseq{i}(1,end),xseq{i}(2,end),r-r_robot-disturbance(1),'b');
            q1=quiver(xseq{i}(1,end),xseq{i}(2,end),cos(xseq{i}(3,end)),sin(xseq{i}(3,end)));
            set(q1,'AutoScale','on','AutoScaleFactor',1/10,'LineWidth',1.5,'MaxHeadSize',3)
        end
    end
    pause(Tc)
    time=time+1;
end

xlabel('x [m]');
ylabel('y [m]');