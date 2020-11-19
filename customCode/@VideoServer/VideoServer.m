classdef VideoServer < handle
    properties (Access=public)
        IRcam;
        RGBcam;
        f_px2pos;
        f_pos2px;
        
        timerCam;
        trajK1;
        rawK1;
        orientation;
        
        nAgents;
        curFrame;
        
        enable_preview;
        preview_figure_handle;
        
        enable_auto_update;
    end
    methods (Access=private)
        calibrateCams(videoServer);
        
    end
    methods (Static)
        [trajK2,rawK2,collision]=getPosRGB(imgRGB,trajK1,rawK1,nAgents,rawMean,tol);
        ris = isInCircle(c,r,p);
        [BW,BWD]=imgThresholdErode(I,thr,raw);
        [BW,BWD]=imgThresholdDilate(I,thr,raw);
        [trajK2,rawK2,collision,collisionSet]=getPosIR(imgIR,trajK1,rawK1,nAgents,rawMean,tol);
        orientation=getOrientation(trajK2,rawK2,imgRGB,imgIR,nAgents,rawMean,tol);
        [n,freeAgents,M1,r1F,r2F,M2,r1B,r2B]=findFree(centers,radii1,radii2,rawMean,tol);
        [couple]=findCouples(M1,M2);
        [centers,radii1,radii2]=findAgents(I);
        
        
    end
    methods (Access=public)
        startTrack(videoServer,elisas);
        [imgRGB]=updateAgents(videoServer);
        stopTrack(videoServer);
        [agentsState]=getAgentsState(videoServer);
        [f]=getCurrentFrame(videoServer);
        
        
        function[obj]=VideoServer(nAgents,enable_preview,enable_auto_update)
            if nargin==1
                enable_preview=0;
                enable_auto_update=0;
            end
            addpath('.\');
            parameters;
            
            obj.enable_auto_update=enable_auto_update;
            obj.nAgents=nAgents;
            obj.enable_preview=enable_preview;
            obj.curFrame=[];
            obj.orientation=[];
            
            obj.timerCam=timer('ExecutionMode','fixedRate','Period',samplingTime);
            obj.timerCam.TimerFcn =@(myTimerObj, thisEvent)(updateAgents(obj));
            
            obj.trajK1=[];
            obj.rawK1=[];
            
%             obj.IRcam=webcam(IRCAMname);
%             obj.IRcam.ExposureMode = IR_ExposureMode;
%             obj.IRcam.Exposure     = IR_Exposure;
%             obj.IRcam.Brightness   = IR_Brightness;
%             obj.IRcam.Resolution   = IR_Resolution;
            
            obj.RGBcam = webcam(RGBCAMname);
            obj.RGBcam.Brightness = RGB_Brightness;
            obj.RGBcam.Contrast   = RGB_Contrast;
                       

            
            try
                load('cameraCalibrationParameters.mat')
            catch
                obj.calibrateCams();
                load('cameraCalibrationParameters.mat');
            end
            
            

            theta=atan2(Px2(2)-Px1(2),Px2(1)-Px1(1));
            R=[cos(theta) sin(theta);-sin(theta) cos(theta)];

            %  Px1=[  36.0000  433.0000];
            %   Px2=[  586.0000  433.0000];
            %    Px3=[ 586.0000   33.0000];
            %    Px4=[  36.0000   33.0000];

           Plx=norm(Px2-Px1);
           Ply=norm(Px4-Px1);
           lx=width;
           ly=height;
           
           
           obj.f_pos2px=@(pos)(R'*[Plx*pos(1)/lx;Ply-((Ply*pos(2)/ly))]+[Px1(1);Px4(2)]);
           obj.f_px2pos=@(px)([(lx/Plx)*(R(1,:)*(px(:)-[Px1(1);Px4(2)]));-(R(2,:)*(px(:)-[Px1(1);Px4(2)])-Ply)*ly/Ply]);
            

            
        end
    end
end