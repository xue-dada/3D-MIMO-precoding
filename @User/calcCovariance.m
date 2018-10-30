function calcCovariance( obj, N, M)
%CALCCOVARIANCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

angleSpread_az = obj.angleSpread_az * pi / 180;
angleSpread_el = obj.angleSpread_el * pi / 180;

theta_az = obj.angle_az * pi / 180;  
theta_el = obj.angle_el * pi / 180;  

R_az = functionOneRingModel(N,angleSpread_az, theta_az);  % channel covariance matrix
R_el = functionOneRingModel(M,angleSpread_el, theta_el);

obj.R_az = R_az;
obj.R_el = R_el;

end

