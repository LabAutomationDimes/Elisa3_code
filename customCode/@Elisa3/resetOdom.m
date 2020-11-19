function[]=resetOdom(elisa3,x,y,theta)
elisa3.connect();
elisa3.ePic=set(elisa3.ePic,'resetAndCalib',1);
elisa3.ePic=set(elisa3.ePic,'odom',[x y theta]); 
%elisa3.ePic.param.odomIni=1;
elisa3.ePic=update(elisa3.ePic);
elisa3.disconnect();
end