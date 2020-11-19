%%routine_loop_script.m
agentsStates=vid.getAgentsState();
robotsStates(:,:,counter)=agentsStates;
counter=counter+1;

for k=1:nR
%     [~,~,~,x_dot_f,y_dot_f,theta_dot_f]=trajectory_trap_3(additiveParameters.Q(:,:,k),additiveParameters.Tmax,tcur,additiveParameters.X0(k,:)');
    
    [~,~,~,x_dot_f,y_dot_f,theta_dot_f]=traj_vec(k).getRef(tcur);
    v=norm([x_dot_f y_dot_f]);
    w=theta_dot_f;
    elisas3(k).setSpeed(v,w,-1,0);
end