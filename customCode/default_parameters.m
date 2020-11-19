%% default_parameters.m
%% robot
samplingTime=0.2;
%% BASIC 
video_server_enable=0;
%% IR CAM
IRCAMname='Microsoft® LifeCam HD-3000';
%IRCAMname='Microsoft LifeCam HD-3000';
IR_ExposureMode='manual';
IR_Exposure=-9;
IR_Brightness=150;
IR_Resolution='640x480';
%% RGB CAM
RGBCAMname='Trust Webcam';
RGB_Brightness=-64;
RGB_Contrast=64;
%% IR/RGB localization
RGB_rawMean=[14 11]; %%RGB   ?
RGB_tol=10;
ErosionThr=220/255;  %laboratorio
DilationThr=40/255;
DilationThrOrientation=100/255;
%%


