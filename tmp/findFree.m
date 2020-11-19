function [n,freeAgents,M1,r1F,r2F,M2,r1B,r2B]=findFree(centers,radii1,radii2)
global rawMean tol

n=0;
nD=length(radii1);
freeAgents=zeros(nD,1);
M1=[];
r1F=[];
r2F=[];
M2=[];
r1B=[];
r2B=[];
for i=1:nD
    if norm(radii1(i)-rawMean(1))<=tol && norm(radii2(i)-rawMean(2))<=tol
        freeAgents(i)=1;
        M1=[M1; centers(i,:)];
        r1F=[r1F; radii1(i)];
        r2F=[r2F; radii2(i)];
        n=n+1;
    else
        M2=[M2; centers(i,:)];
        r1B=[r1B; radii1(i)];
        r2B=[r2B; radii2(i)];
    end 
end
