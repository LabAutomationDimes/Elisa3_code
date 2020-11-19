%%starting_loop_script.m
nR=length(elisas3);
global vid;
elisas3(1).setColor([1 0 0]);
elisas3(1).turnOnIR(elisas3(1).turnOnIRoptions_All);
elisas3(2).setColor([0 0 1]);
elisas3(2).turnOnIR(elisas3(2).turnOnIRoptions_All);

vid=VideoServer(nR,1);
vid.startTrack();

robotsStates=[];
counter=1;

traj_vec=[];
for k=1:nR
    traj_vec=[traj_vec;TrajectoryTrapGenerator(additiveParameters.Q(:,:,k),additiveParameters.Tmax,additiveParameters.X0(k,:),samplingTime)];
end

