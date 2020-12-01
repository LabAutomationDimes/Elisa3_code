figure
hold on
for i=1:size(agents,2)
    plot(agents{i}(1,:),agents{i}(2,:),'k')
    plot(agents{i}(1,1),agents{i}(2,1),'*r')
end