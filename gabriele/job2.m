disp('job2')

index=maxIndex(agents,X0,index,(r-r_robot-disturbance(1)));
parfor i=1:n
    [k(i),cond(i),rif(:,i)]=parforControl(cond(i),Tc,agents{i},X0(:,i),index,umax,ymax,r-r_robot,rEndEll,elisa,vid);
end