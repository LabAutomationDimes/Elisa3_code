disp('job3')

for i=1:n
    endCond=endCond && cond(i);
    u(:,i)=k(i)*(X0(:,i)-rif(:,i));
end