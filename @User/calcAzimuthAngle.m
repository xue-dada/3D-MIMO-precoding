function calcAzimuthAngle(obj)
%calcAzimuthAngle ���귽λ�Ǽ���
%   ���귽λ�Ǽ��㣬�Ի�վ������Ϊԭ��������귽λ��
%   https://wenku.baidu.com/view/6d5e1a570029bd64793e2c84.html?rec_flag=default&sxts=1530530590436
x = obj.x; 
y = obj.y;
bs_x = obj.bs_x; 
bs_y = obj.bs_y;

if (bs_x == x)
    if (bs_y < y)
        angle = 90;  % y������
    elseif (bs_y == y)
        angle = unifrnd(0, 360);
        disp('�������')
    else
        angle = 270;  % y������
    end
elseif (bs_x < x)
    if (bs_y < y)
        angle = atan((y - bs_y) / (x - bs_x))*180/pi; % ��һ������
    elseif (bs_y == y)
        angle = 0;          % x����������
    else
        angle = 360 + atan((y - bs_y) / (x - bs_x))*180/pi;  % ����������
    end
else
    if (bs_y < y)
        angle = 180 + atan((y - bs_y) / (x - bs_x))*180/pi;  % �ڶ�����
    elseif (bs_y == y)
        angle = 180;  % x��������
    else
        angle = 180 + atan((y - bs_y) / (x - bs_x))*180/pi;  % ��������
    end
end
obj.angle_az = angle;

end

