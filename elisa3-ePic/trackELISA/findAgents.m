function [centers,radii1,radii2]=findAgents(I)

CC = bwconncomp(I);
S  = regionprops(CC,'Centroid','MajorAxisLength','MinorAxisLength');
n  = size(S,1);
    
centers=zeros(n,2);
radii1=zeros(n,1);
radii2=zeros(n,1);
for i=1:n
    centers(i,:)=S(i).Centroid;
    radii1(i)=S(i).MajorAxisLength/2;
    radii2(i)=S(i).MinorAxisLength/2;
end
