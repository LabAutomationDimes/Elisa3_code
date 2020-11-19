function[outputs]=loop(elisas3,startingScript,routineScript,endingScript,TMax,additiveParameters)
parameters;

if isempty(startingScript)==0
    startingScript();
end

outputs=[];

nR=length(elisas3);
disp(['starting Routine Loop with ' num2str(nR) ' elisa3']);

tcur=0;
while tcur<=TMax
    t1=tic;
    routineScript();
    T=toc;
    if T<samplingTime
        pause(samplingTime-T);
    end
    tcur=tcur+samplingTime;
end

if isempty(endingScript)==0
    endingScript();
end
end