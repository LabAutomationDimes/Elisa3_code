function [agents] = pathDesign(r,beta,M,agents_0)

    n=size(agents_0,2);
    mu=r;

    syms time
%% Sinusoide
%     rif=[time;0.1*sin(time/0.1)+0.3];
%% 8
    rc=0.2;
    wc=0.3;
    rif=[0.4+rc*cos(wc*time); 0.3+rc*sin(2*wc*time)/2]; 
%% Circonferenza
% rc=0.2;
% wc=0.2;
% rif=[0.4+rc*cos(wc*time); 0.3+rc*sin(wc*time)];
% rp=[-wc*rc*sin(wc*tt); wc*rc*cos(wc*tt)];
%% Cuore
% rif  = [0.4+0.2*sin(time).^3; 0.4+0.15*(cos(time)-cos(time).^4)];
% rp = [0.2*3*(sin(tt).^2).*cos(tt); 0.15*(-sin(tt)+4*(cos(tt).^3).*sin(tt))];
%% Retta
%     rif=[time; 0.3]; %retta
%%
    rif_dot=diff(rif,time);

    tspan=[0:0.001:40];
    [t agents_tot]=ode45(@(t,agents_tot) odeSwarm(t,agents_tot,n,M,beta,mu,rif,rif_dot),tspan,agents_0);
    
    agents={};
    for i=1:n
        agents{i}=[];
    end

    for i=1:size(agents_tot,1)
        agents_i=vec2mat(agents_tot(i,:),2);
        for j=1:n
            agents{j}=[agents{j} agents_i(j,:)'];
        end
    end

end

