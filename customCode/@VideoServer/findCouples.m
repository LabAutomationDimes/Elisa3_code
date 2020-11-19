function [couple]=findCouples(M1,M2)

n1 = size(M1,1);
n2 = size(M2,1);

couple=zeros(n1,1);

D = zeros(n1,n2);
for i=1:n1
    for j=1:n2
        D(i,j)=norm(M1(i,:)-M2(j,:));
    end
end
for i=1:n1
    minD=min(D(:));
    [r,c]=find(D==minD);
    r=r(1); c=c(1);
    couple(r) = c;
    D(r,:)=inf;
    D(:,c)=inf;
end              