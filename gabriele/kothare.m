function [Q,K,problem] = kothare(Ad,Bd,u_max,y_max,x0,r)

    nx=size(Ad{1},2);
    nu=size(Bd{1},2);

%     yalmip('clear')
    Q=sdpvar(nx,nx);
    Y=sdpvar(nu,nx,'full');
    X=sdpvar(nu,nu);
    gamma=sdpvar(1);
    R=[1   0
       0   1];
    Q1=eye(nx);
    C=eye(nx);

    FF=(Q>=0);
    
    FF=FF+(Q(1:2,1:2)<=(r^2)*eye(2));
    
    for j=1:nu
        FF=FF+(X(j,j)<=u_max(j)^2);
    end
                    
    FF=FF+([X    Y
            Y'   Q]>=0);

    for i=1:size(Ad,2)
        FF=FF+([Q                           Q*Ad{i}'+Y'*Bd{i}'              Q*sqrtm(Q1)         Y'*sqrtm(R)
                Ad{i}*Q+Bd{i}*Y             Q                               zeros(nx,nx)        zeros(nx,nu)
                sqrtm(Q1)*Q                 zeros(nx,nx)                    gamma*eye(nx)       zeros(nx,nu)
                sqrtm(R)*Y                  zeros(nu,nx)                    zeros(nu,nx)        gamma*eye(nu)] >= 0);
            
        for j=1:size(C,1)
            FF = FF+([Q                       (Ad{i}*Q+Bd{i}*Y)'*C(j,:)' 
                      C(j,:)*(Ad{i}*Q+Bd{i}*Y)        y_max(j,j)^2]>=0);
        end
    end
    
    FF=FF+([1   x0'
            x0  Q] >= 0);

   opt=sdpsettings('solver','mosek','verbose',0);
   %opt=sdpsettings('solver','sedumi','verbose',0); 
   sol=solvesdp(FF,gamma,opt);

    if sol.problem~=0 && sol.problem~=4
        problem=false;
        Q=0;K=0;
        return
    end

    problem=true;
    Q=double(Q);
    K=double(Y)/Q;
end