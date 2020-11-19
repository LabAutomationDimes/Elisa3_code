%%routine_loop_script.m
for k=1:nR
%     [~,~,~,x_dot_f,y_dot_f,theta_dot_f]=trajectory_trap_3(additiveParameters.Q(:,:,k),additiveParameters.Tmax,tcur,additiveParameters.X0(k,:)');
    [~,~,~,x_dot_f,y_dot_f,theta_dot_f]=traj_vec.getRef(tcur);
    v=norm([x_dot_f y_dot_f]);
    w=theta_dot_f;
    elisas3(k).setSpeed(v,w,-1,0);
end