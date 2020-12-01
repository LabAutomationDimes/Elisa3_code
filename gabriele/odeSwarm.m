function [agents_dot] = odeSwarm(t,agents,n,M,beta,mu,r,r_dot)
    syms time
    r_dot=vpa(subs(r_dot,time,t));
    r=double(subs(r,time,t));
    agents_dot=zeros(size(r,1),n);
    agents=vec2mat(agents,size(r,1))';
    c=zeros(size(r,1),1);
    for i=1:n
        c=c+(1/n)*agents(:,i);
    end
    xi=zeros(size(r,1),1);
    for i=1:size(r,1)
        xi(i)=sign(c(i)-r(i))*abs(c(i)-r(i))^beta;
    end
    for i=1:n
        interaction=zeros(size(r,1),1);
        for j=1:n
            interaction=interaction+M*(agents(:,i)-agents(:,j))/(norm(agents(:,i)-agents(:,j))^2-4*mu^2)^2;
        end
        agents_dot(:,i)=-agents(:,i)-(1/n)*interaction+r+r_dot-xi;
    end
    agents_dot=agents_dot(:);
end