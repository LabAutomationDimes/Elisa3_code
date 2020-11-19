classdef TrajectoryTrapGenerator < handle
    
    properties (Access=public)
        Q;
        X0;
        Tmax;
        Ts;
        
        theta_single;
        
        xRef_vec;
        yRef_vec;
        thetaRef_vec;
        xdotRef_vec;
        ydotRef_vec;
        thetadotRef_vec;
    end
    
    methods (Access=public)
        function[obj]=TrajectoryTrapGenerator(Q,Tmax,X0,Ts,theta_single)
            if nargin==4
                theta_single=pi/4;
            end
            
            obj.Q=Q;
            obj.X0=X0(:);
            obj.Tmax=Tmax;
            obj.Ts=Ts;
            
            
            obj.theta_single=theta_single;
            
            obj.xRef_vec=[];
            obj.yRef_vec=[];
            obj.thetaRef_vec=[];
            obj.xdotRef_vec=[];
            obj.ydotRef_vec=[];
            obj.thetadotRef_vec=[];
            
            for t=0:obj.Ts:Tmax
                [x_ref,y_ref,theta_ref,x_dot_ref,y_dot_ref,theta_dot_ref]=TrajectoryTrapGenerator.trajectory_trap_3(obj.Q,obj.Tmax,t,obj.X0,obj.theta_single);
                obj.xRef_vec=[obj.xRef_vec;x_ref t];
                obj.yRef_vec=[obj.yRef_vec;y_ref t];
                obj.thetaRef_vec=[obj.thetaRef_vec;theta_ref t];
                obj.xdotRef_vec=[obj.xdotRef_vec;x_dot_ref t];
                obj.ydotRef_vec=[obj.ydotRef_vec;y_dot_ref t];
                obj.thetadotRef_vec=[obj.thetadotRef_vec;theta_dot_ref t];
            end
            
        end
        function[x,y,theta,xdot,ydot,thetadot]=getRef(obj,t)
            x=interp1(obj.xRef_vec(:,2),obj.xRef_vec(:,1),t);
            y=interp1(obj.yRef_vec(:,2),obj.yRef_vec(:,1),t);
            theta=interp1(obj.thetaRef_vec(:,2),obj.thetaRef_vec(:,1),t);
            xdot=interp1(obj.xdotRef_vec(:,2),obj.xdotRef_vec(:,1),t);
            ydot=interp1(obj.ydotRef_vec(:,2),obj.ydotRef_vec(:,1),t);
            thetadot=interp1(obj.thetadotRef_vec(:,2),obj.thetadotRef_vec(:,1),t);
        end
    end
    methods (Static)
        function[x_ref,y_ref,theta_ref,x_dot_f,y_dot_f,theta_dot_f]=trajectory_trap_3(Q,Tmax,t,X0,theta_single)
            if nargin==4
                theta_single=pi/4;
            end
            
            persistent Tin Tfin tempoPercorrenza tempoOrientamento nPcount faseOrientamento angoliInSequenza x y theta x_dot y_dot theta_dot
            %velocità di avanzamento lineare media (al più)=4cm/sec
            vmax=0.05;%0.7;%
            %all'istante iniziale della traiettoria calcolo i tempi dedicati
            %all'orientamento ed ad ogni singolo tratto
            if t==0
                %struttura dati per mantenere l'orientamento dei vari tratti di retta
                orientamento=zeros(1,size(Q,1)-1);
                %angolo formato tra i vari tratti di retta (il minimo angolo da sommare algebricamente)
                %all'orientamento della retta precedente per arrivare a quello della
                %retta successiv
                alphaO=zeros(1,size(Q,1)-1);
                %successione degli spostamenti angolari necessari per orientarsi prima
                %di percorrere ogni tratto
                angoliInSequenza=zeros(1,size(Q,1));
                for i=1:size(Q,1)-1
                    %caso particolare: nel caso in cui un punto sia duplicato uscirebbe
                    %sicuramente una retta con orientamento 0 per come è fatta la
                    %funzione atan2, in realtà invece la sua orientazione deve essere
                    %la stessa del tratto precedente. Se non esiste un tratto
                    %precedente allora deve essere uguale all'orientamento iniziale
                    if(abs(Q(i+1,2)-Q(i,2))<0.001&&abs(Q(i+1,1)-Q(i,1))<0.001)
                        if i>1
                            orientamento(i)=orientamento(i-1);
                        else
                            orientamento(i)=X0(3);
                        end
                    else
                        orientamento(i)=atan2(Q(i+1,2)-Q(i,2),Q(i+1,1)-Q(i,1));
                    end
                    
                    %calcolo la differenza angolare tra i tratti di retta successiva
                    
                    %alpha1=orientamento tratto successivo
                    %alpha2=orientamento tratto precedente
                    alpha2=orientamento(i);
                    if i==1
                        %se nn c'è un tratto precedente prendo la condizione iniziale
                        alpha1=X0(3);
                        angoliInSequenza(i)=alpha1;
                    else
                        alpha1=orientamento(i-1);
                    end
                    
                    %calcolo la differenza angolare tra le due rette e ricerco lo
                    %spostamento angolare minimo  andando ad osservare se l'angolo
                    %formato è maggiore o minore rispettivamente di pi e -pi. Nel caso
                    %la differenza sia maggiore prendo l'angolo complementare
                    diffAngolare=alpha2-alpha1;
                    if diffAngolare>0&&diffAngolare>pi
                        alphaO(i)=-(2*pi-diffAngolare);
                    elseif diffAngolare<0&&diffAngolare<-pi
                        alphaO(i)=(2*pi+diffAngolare);
                    else
                        alphaO(i)=diffAngolare;
                    end
                    %salvo la successione di spostamenti angolari necessari per
                    %orientarsi correttamente prima di muoversi
                    angoliInSequenza(i+1)=angoliInSequenza(i)+alphaO(i);
                    
                end
                
                %calcolo il tempo dedicato agli orientamenti( totale)
                tempoOrientamento=zeros(1,size(Q,1)-1);
                for i=1:size(Q,1)-1
                    
                    t_single=1;
                    %theta_single:t_single=alphaO(i):durata
                    tempoOrientamento(i)=(abs(alphaO(i))*t_single)/theta_single;
                end
                
                %sottraggo al tempo totale quello necessario agli orientamenti per
                %sapere il tempo da dedicare allo spostamento
                T_rimanente=Tmax-sum(tempoOrientamento);
                if T_rimanente<0
                    error('tempo insufficiente a compiere il percorso')
                end
                spazioDaPercorrere=0;
                for i=1:size(Q,1)-1
                    spazioDaPercorrere=spazioDaPercorrere+sqrt((Q(i+1,2)-Q(i,2))^2+(Q(i+1,1)-Q(i,1))^2);
                end
                
                if(vmax*T_rimanente<spazioDaPercorrere)
                    error('tempo insufficiente a compiere il percorso')
                end
                
                %calcolo il tempo di percorrenza per ogni tratto
                tempoPercorrenza=zeros(1,size(Q,1)-1);
                for i=1:size(Q,1)-1
                    %spazioDaPercorrere:T_rimanente=tratto:durataTratto
                    tempoPercorrenza(i)=(T_rimanente*sqrt((Q(i+1,2)-Q(i,2))^2+(Q(i+1,1)-Q(i,1))^2))/spazioDaPercorrere;
                end
                
                
                %suppongo inizialmente di dover fare una rotazione e di essere al
                %primo tratto
                
                %tiene il riferimento al tratto che correntemente si sta percorrendo
                nPcount=0;
                %istante nel quale ho iniziato il tratto nPCount o la rotazione a
                %nPCount
                Tin=0;
                %istante nel quale finisce il tratto nPCount o la rotazione a nPCount
                Tfin=0;
                x=X0(1);
                y=X0(2);
                %orientamento iniziale
                theta=X0(3);
                %variabile che indica se correntemente dobbiamo fare una rotazione o una traslazione
                faseOrientamento=false;
                
                %       Tin
                %       Tfin
                %       nPcount
                %       tempoOrientamento
                %       tempoPercorrenza
                %       orientamento
                %       alphaO
                %       angoliInSequenza
                %       Tmax
                %       T_rimanente
                
            end
            
            if t>=Tmax
                %in tale caso nn faccio niente in quanto il tempo è finito( teoricamente non dovrebbe
                %mai essere possibile questo caso se giustamente invocata la trajectory)
            else
                
                %% versione all case
                %cerco uno spostamento o una rotazione valida nel momento in cui il tratto
                %o la rotazione corrente è terminata. Questo serve ad eliminare ed evitare
                %eventuali spostamenti o rotazioni nulle. Questo può accadere o quando si
                %duplica uno stesso punto in Q o quando si concatenano due segmenti in
                %realtà già orientati nello stesso modo. Quello che fa è far avanzare
                %nPcount fino a quando non trova una rotazione o uno spostamento di durata
                %non nulla
                if t>=Tfin
                    cerca_valida=true;
                else
                    cerca_valida=false;
                end
                
                while(cerca_valida)
                    if faseOrientamento==true
                        Tin=Tfin;
                        Tfin=Tin+tempoPercorrenza(nPcount);
                        if Tin~=Tfin
                            cerca_valida=false;
                            faseOrientamento=false;
                        else
                            faseOrientamento=false;
                            nPcount=nPcount+1;
                        end
                    else
                        nPcount=nPcount+1;
                        Tin=Tfin;
                        Tfin=Tin+tempoOrientamento(nPcount);
                        if Tin~=Tfin
                            cerca_valida=false;
                            faseOrientamento=true;
                        else
                            faseOrientamento=true;
                        end
                    end
                end
                
                if faseOrientamento==true
                    %effettuo la rotazione
                    x_dot=0;
                    y_dot=0;
                    %        x=Q(nPcount,1);
                    %        y=Q(nPcount,2);
                    
                    [theta theta_dot]=TrajectoryTrapGenerator.trajectory_trap_general(t,Tin,Tfin,angoliInSequenza(nPcount),angoliInSequenza(nPcount+1));
                else
                    [x x_dot]=TrajectoryTrapGenerator.trajectory_trap_general(t,Tin,Tfin,Q(nPcount,1),Q(nPcount+1,1));
                    [y y_dot]=TrajectoryTrapGenerator.trajectory_trap_general(t,Tin,Tfin,Q(nPcount,2),Q(nPcount+1,2));
                    %   theta=theta_k;
                    theta_dot=0;
                end
                
                
                %% fine all case
                
                
                
                
                % fatta_prima=false;
                %
                % if faseOrientamento==true
                %    if(t>=Tfin)
                %        %passo alla fase successiva di spostamento
                %        faseOrientamento=false;
                %        Tin=Tfin;
                %        Tfin=Tin+tempoPercorrenza(nPcount);
                %    else
                %        fatta_prima=true;
                %        %effettuo la rotazione
                %        x_dot=0;
                %        y_dot=0;
                % %        x=Q(nPcount,1);
                % %        y=Q(nPcount,2);
                %
                %        [theta theta_dot]=trajectory_trap_general(t,Tin,Tfin,angoliInSequenza(nPcount),angoliInSequenza(nPcount+1));
                %    end
                % end
                %
                % if faseOrientamento==false
                %     display('entro nell''alternativa')
                %     if(t>=Tfin)
                %        %passo alla fase successiva di spostamento
                %        faseOrientamento=true;
                %        nPcount=nPcount+1;
                %        Tin=Tfin;
                %        Tfin=Tin+tempoOrientamento(nPcount);
                %
                %     else
                %         [x x_dot]=trajectory_trap_general(t,Tin,Tfin,Q(nPcount,1),Q(nPcount+1,1));
                %         [y y_dot]=trajectory_trap_general(t,Tin,Tfin,Q(nPcount,2),Q(nPcount+1,2));
                % %         theta=theta_k;
                %         theta_dot=0;
                %     end
                % end
                %
                %
                % if faseOrientamento==true&&fatta_prima==true
                % %    if(t>=Tfin)
                % %        %passo alla fase successiva di spostamento
                % %        faseOrientamento=false;
                % %        Tin=Tfin;
                % %        Tfin=Tin+tempoPercorrenza(nPcount);
                % %    else
                %        %effettuo la rotazione
                %        x_dot=0;
                %        y_dot=0;
                % %        x=Q(nPcount,1);
                % %        y=Q(nPcount,2);
                %        [theta theta_dot]=trajectory_trap_general(t,Tin,Tfin,angoliInSequenza(nPcount),angoliInSequenza(nPcount+1));
                % %    end
                % end
                
            end
            x_ref=x;
            y_ref=y;
            theta_ref=theta;
            
            x_dot_f=x_dot;
            y_dot_f=y_dot;
            theta_dot_f=theta_dot;
            
            % faseOrientamento
            %pause
            
        end
        
        % function[tk tk1]=theta_correct(thetak,thetak1)
        % %%si suppone di lavorare con angoli inferiori a 2*pi
        % %tk=thetak;
        % %tk1=thetak1;
        %
        % %%PARTE AGGIUNTA
        % % % q=floor(thetak/(2*pi));
        % % % tk=mod(thetak,2*pi);
        % % % tk1=mod(thetak1,2*pi);
        % % % if tk~=thetak
        % % %     tk=tk+q*2*pi;
        % % %     tk1=tk1+q*2*pi;
        % % % end
        % %%PARTE AGGIUNTA
        % tk1=thetak1;
        % tk=thetak;
        % if tk1>0
        %     t_tmp=tk1-2*pi;
        % else
        %     t_tmp=tk1+2*pi;
        % end
        % if tk>pi
        %     tk1=max(tk1,t_tmp);
        % elseif tk<-pi
        %     tk1=min(tk1,t_tmp);
        % else
        %     if abs(tk-tk1)>abs(tk-t_tmp)
        %         tk1=t_tmp;
        %     end
        % end
        % end
        
        
        
        function[s s_dot]=trajectory_trap_general(t,t_start,t_fin,s_start,s_fin)
            T=t_fin-t_start;
            [phi phi_dot]=TrajectoryTrapGenerator.trajectory_trap_norm((t-t_start)/T);
            s=(s_fin-s_start)*phi+s_start;
            s_dot=(s_fin-s_start)*phi_dot/T;
        end
        
        
        
        function[phi phi_dot]=trajectory_trap_norm(t)
            k1=1/5;
            phi_dot_max=1/(1-k1);
            alpha=phi_dot_max/k1;
            if t<0
                phi=0;
                phi_dot=0;
            elseif t<k1
                phi=alpha*(t^2)/2;
                phi_dot=alpha*t;
            elseif t<1-k1
                phi=phi_dot_max*(t-k1)+alpha*(k1^2)/2;
                phi_dot=phi_dot_max;
            elseif t<=1
                tt=1-k1;
                phi=-alpha*(t^2)/2+alpha*(tt^2)/2+(phi_dot_max/k1)*(t-tt)+phi_dot_max*(1-2*k1)+alpha*(k1^2)/2;
                %phi=-alpha*(t^2)/2+phi_dot_max*((k1-2*k1^2+t)/k1)+alpha*(k1^2)/2;
                phi_dot=-alpha*t+phi_dot_max/k1;
            else
                phi=0;
                phi_dot=0;
            end
        end
    end
    
end

