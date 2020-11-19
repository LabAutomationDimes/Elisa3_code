%%ending_loop_script.m
for k=1:nR
    elisas3(k).stop();
end

t=0:samplingTime:additiveParameters.Tmax;

outputs.agentsStates=robotsStates;
coutputs.t=t;

vid.stopTrack();
