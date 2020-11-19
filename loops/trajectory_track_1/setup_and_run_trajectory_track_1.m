%% setup_and_run_trajectory_track_1.m
clear all;
close all;
clc;
%%
addpath('.\loops\trajectory_track_1');
addpath('.\utilities');
%% parameters
ports={
    '3438';
    '3459'
    };
X0(1,:)=[0 0 0];
Q(:,:,1)=[
    0 0;
    0.25 0;
    0.25 0.25;
    0 0;
    ];
X0(2,:)=[0 0 0];
Q(:,:,2)=[
    0 0;
    0.25 0;
    0.25 0.25;
    0 0;
    ];
Tmax=100;

%%
additiveParameters.Q=Q;
additiveParameters.Tmax=Tmax;
additiveParameters.X0=X0;

elisas=[];
for k=1:length(ports)
    elisas=[elisas;Elisa3(ports{k})];
end
Elisa3.loop(elisas,@starting_loop_script,@routine_loop_script,@ending_loop_script,Tmax,additiveParameters);

agentsStates=outputs.agentsStates;
for k=1:length(ports)
    h=figure(k);hold on;
    x=agentsStates(k,1,:);
    y=agentsStates(k,2,:);
    theta=agentsStates(k,3,:);
    for i=1:length(x)
        plotRobot([x(i);y(i);theta(i)],1,h);
    end
    
    
end

%           (elisas3,startingScript,      routineScript,        endingScript,      TMax,additiveParameters)
