function [trajK2,rawK2,collision]=getPosRGB(imgRGB,trajK1,rawK1)

% trajKx = nAgents x 2

global nAgents rawMean tol

thr=220/255;
[BW1,auxRGB1]=imgThresholdErode(imgRGB,thr,5);

collision=0;

%% find Agents
[centers,radii1,radii2]=findAgents(auxRGB1);
% number of detected agents
nAd = size(centers,1);


%%% Filter
%--------------------------------------------------------------------
indexNotAg=[];
for i=1:nAd
    ratRad=radii1(i)/radii2(i);
    c1=norm(radii1(i)-rawMean(1));
    c2=norm(radii2(i)-rawMean(2));
    if ratRad<0.2 || ratRad>2 ||...
        c1 > tol || c2 > tol
        indexNotAg=[indexNotAg; i];
    end
end
centers(indexNotAg,:)=[];
radii1(indexNotAg)=[];
radii2(indexNotAg)=[];
nAd=nAd-length(indexNotAg);
%--------------------------------------------------------------------

   

%% find Agents
[centers,radii1,radii2]=findAgents(auxRGB1);
% number of detected agents
nAd = size(centers,1);

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
        couple=findCouples(trajK1,centers);
        for i=1:nAgents
            trajK2(i,:) = centers(couple(i),:);
            rawK2(i,:)  = [radii1(couple(i),:) radii2(couple(i),:)];
        end
    elseif nAd<nAgents
        %% collisione
        isAssigned=zeros(1,nAgents);
        [nFA,freeAgents,cAF,r1F,r2F,cAB,r1B,r2B]=findFree(centers,radii1,radii2);
        if nFA>0
            couple=findCouples(trajK1,cAF);
            for i=1:nAgents
                if couple(i)>0
                    trajK2(i,:) = cAF(couple(i),:);
                    rawK2(i,:)  = [r1F(couple(i)) r2F(couple(i))];
                    isAssigned(i)=1;
                end
            end
        end   
% %             isAssigned
        %% resta da assegnare gli altri agenti alle rimanenti componenti
        couple=zeros(nAgents,1);
        D = zeros(nAgents,nAd);
        for i=1:nAgents
            for j=1:nAd
                D(i,j)=norm(trajK1(i,:)-centers(j,:));
            end
        end
        for i=1:nAgents
            minD=min(D(:));
            [r,c]=find(D==minD);
            r=r(1); c=c(1);
            couple(r) = c;
            D(r,:)=inf;
            if freeAgents(c)
                D(:,c)=inf;
            end
        end    
        for i=1:nAgents
            if couple(i)>0 && ~isAssigned(i)
                trajK2(i,:) = centers(couple(i),:);
                rawK2(i,:)  = [radii1(couple(i)) radii2(couple(i))];
            end
        end
    else
        error('Troppe componenti!!!'); 
    end
end
