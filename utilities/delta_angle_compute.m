%% calcola theta1-theta2
function[delta_angle]=delta_angle_compute(theta1,theta2)

singleTheta2=length(theta2)==1;

delta_angle=zeros(size(theta1));
for i=1:length(theta1)
    if singleTheta2
        thetaCur=theta2;
    else
        thetaCur=theta2(i);
    end
    delta_angle(i)=atan2(sin(theta1(i)-thetaCur),cos(theta1(i)-thetaCur));
end

end