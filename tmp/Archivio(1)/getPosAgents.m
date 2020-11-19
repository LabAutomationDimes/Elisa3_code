function [trajK2,rawK2]=getPosAgents(imgIR,trajK1,rawK1)

% trajKx = nAgents x 2

global nAgents rawMean tol

thr=40/255;
[BW1,auxIR1]=imgThresholdDilate(imgIR,thr,15);

%% find Agents
[centers,radii1,radii2]=findAgents(auxIR1);
% number of detected agents
nAd = size(centers,1);

collision = 0;
if isempty(trajK1) 
    if nAd==nAgents
        for i=1:nAgents
            trajK2(i,:) = centers(i,:);
            rawK2(i,:)  = [radii1(i,:) radii2(i,:)];
        end
    else
        error('Collisions exist in initial framework!');
    end
else
     if nAd==nAgents
        collision = 0;

        D=zeros(nAgents); 
        for i=1:nAgents
            for j=1:nAgents
                D(i,j)=norm(centers(i,:)-trajK1(j,:));
            end
        end
        for i=1:nAgents
            minD=min(D(:));
            [r,c]=find(D==minD);
            r=r(1); c=c(1);
            trajK2(c,:) = centers(r,:);
            rawK2(c,:)  = [radii1(r,:) radii2(r,:)];
            D(r,:)=inf;
            D(:,c)=inf;
        end                           
     else
        collision = 1;
%         disp(['Collision detected. Number of collided agents: ',num2str(nAgents-nAd+1)]);

        freeAgent = zeros(1,nAgents);
        collBlob  = ones(1,nAd);
        for i=1:nAd
            if norm(radii1(i)-rawMean(1))<=tol && norm(radii2(i)-rawMean(2))<=tol
                % is an agent
                distMin = inf;
                jMin    = 0;
                for j=1:nAgents
                    dij = norm(centers(i,:)-trajK1(j,:));
                    if dij < distMin
                        distMin = dij;
                        jMin = j;
                    end
                end
                freeAgent(jMin)=1;
                collBlob(i)=0;
                trajK2(jMin,:) = centers(i,:);
                rawK2(jMin,:)  = [radii1(i,:) radii2(i,:)]; 
            end
        end    
        for i=1:nAgents
            if ~freeAgent(i)
                distMin = inf;
                jMin    = 0;                    
                for j=1:nAd
                    if collBlob(j)
                        dij = norm(centers(j,:)-trajK1(i,:));
                        if dij < distMin
                            distMin = dij;
                            jMin = j;
                        end
                    end
                end           
                trajK2(i,:)=centers(jMin,:);
                rawK2(i,:)=rawK1(i,:);
            end
        end
     end
end
