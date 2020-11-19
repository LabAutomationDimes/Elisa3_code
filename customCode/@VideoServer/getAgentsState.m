function[agentsState]=getAgentsState(videoServer)
nAgents=videoServer.nAgents;
agentsState=zeros(nAgents,3);
for k=1:nAgents
    center=videoServer.trajK1(k,:);
    if isempty(videoServer.orientation)
        theta=0;
    else
        segment=videoServer.orientation(k,:);
        s1=videoServer.f_px2pos(segment(1:2));
        s2=videoServer.f_px2pos(segment(3:4));
        theta=atan2(s2(2)-s1(2),s2(1)-s1(1));
    end
    P=videoServer.f_px2pos(center);
    
    agentsState(k,:)=[P(:)' theta];
end
end