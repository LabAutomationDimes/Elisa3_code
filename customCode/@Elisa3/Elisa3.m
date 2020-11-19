classdef Elisa3 < handle

    properties (Access=public)
        ePic;
        port;
% %         wheelRadius;
% %         wheel2wheelDistance;
% %         M_wRwL2vw;
% %         M_vw2wRwL;
    end
    
    properties (Constant)
        turnOnIRoptions_FrontTwo=1;
        turnOnIRoptions_RearOne=2;
        turnOnIRoptions_All=3;
        turnOnIRoptions_turnOff=4;
        wheelRadius=0.0045;
        wheel2wheelDistance=0.0408;
        M_wRwL2vw=[
                Elisa3.wheelRadius/2 Elisa3.wheelRadius/2;
                Elisa3.wheelRadius/Elisa3.wheel2wheelDistance -Elisa3.wheelRadius/Elisa3.wheel2wheelDistance
                ];
        M_vw2wRwL=inv(Elisa3.M_wRwL2vw);

    end

    methods (Static)
        [outputs]      = loop(elisas3,startingScript,routineScript,endingScript,TMax,additiveParameters);
                         setSpeed4Robots(ports,wRvec,wLvec,isRadS,iswRwL);
                         setSpeedNRobots(ports,wRvec,wLvec,isRadS,iswRwL);
                         setSpeedNRobotsND(ports,wRvec,wLvec,isRadS,iswRwL);
                 [ePic]= connectS(elisa3);
        
    end
    methods (Access=public)
        [result]       = connect(elisa3);
        [result]       = disconnect(elisa3);
        [x,y,theta,up] = getOdom(elisa3);
                         resetOdom(elisa3,x,y,theta);
                         setSpeed(elisa3,wR,wL,isRadS,iswRwL);
                         stop(elisa3);
                         turnOnIR(elisa3,turnOnIRoptions_flag);
                         setColor(elisa3,rgbColor);
        
        
        
        
        
        function[robot]=Elisa3(port)

            
            try
                ePic=ePicKernel();
            catch
                addpath('.\elisa3-ePic');
                addpath('.\');
                ePic=ePicKernel();
            end
            robot.ePic=ePic;
            robot.port=port;
            
            %{
            Wheels diamater = 9 mm
            Distance between wheels = 40.8 mm
            %}
% %             robot.wheelRadius=0.0045;
% %             robot.wheel2wheelDistance=0.0408;
% %             robot.M_wRwL2vw=[
% %                 robot.wheelRadius/2 robot.wheelRadius/2;
% %                 robot.wheelRadius/robot.wheel2wheelDistance -robot.wheelRadius/robot.wheel2wheelDistance
% %                 ];
% %             robot.M_vw2wRwL=inv(robot.M_wRwL2vw);
        end
    end
end