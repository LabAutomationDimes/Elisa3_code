%%starting_loop_script.m
nR=length(elisas3);
traj_vec=[];
for k=1:nR
    traj_vec=[traj_vec;TrajectoryTrapGenerator(additiveParameters.Q(:,:,k),additiveParameters.Tmax,additiveParameters.X0(k,:),samplingTime)];
end