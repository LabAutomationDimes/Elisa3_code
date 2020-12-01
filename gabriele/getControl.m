function [u,problem,ell] = getControl(Tc,path,xInitial,index,umax,ymax,r)

    [Ad,Bd,rif,xInitial]=getParameters(Tc,path,xInitial,index);
    [Q,k,problem]=kothare({Ad},{Bd},umax,ymax,xInitial-rif,r);
    
    if ~problem
        u=0; ell=0;
        return
    end
    
    ell=ellipsoid(rif,Q);
    u=k*(xInitial-rif);

end

