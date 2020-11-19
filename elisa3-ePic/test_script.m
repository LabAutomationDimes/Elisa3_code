%%test_script.m

%%
timer1_period = 0.1;
port='3430';
%%


% timer1 = timer('TimerFcn',@btm_timer1_Callback,'period',timer1_period);
ePic=ePicKernel();
[ePic,result]=connect(ePic, port);
% if (result == 1)
    
%     set(timer1,'period',timer1_period);
%     start(timer1);
% end
ePic=set(ePic,'speed', [10 -10]);
ePic=update(ePic); 

ePic=set(ePic,'speed', [0 0]);
ePic=update(ePic); 

[ePic,result] = disconnect(ePic);
%{
stop(timer1);
[ePic,result] = disconnect(ePic);
%}