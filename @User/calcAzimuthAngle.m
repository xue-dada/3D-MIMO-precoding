function calcAzimuthAngle(obj)
%calcAzimuthAngle 坐标方位角计算
%   坐标方位角计算，以基站的坐标为原点计算坐标方位角
%   https://wenku.baidu.com/view/6d5e1a570029bd64793e2c84.html?rec_flag=default&sxts=1530530590436
x = obj.x; 
y = obj.y;
bs_x = obj.bs_x; 
bs_y = obj.bs_y;

if (bs_x == x)
    if (bs_y < y)
        angle = 90;  % y正半轴
    elseif (bs_y == y)
        angle = unifrnd(0, 360);
        disp('任意度数')
    else
        angle = 270;  % y负半轴
    end
elseif (bs_x < x)
    if (bs_y < y)
        angle = atan((y - bs_y) / (x - bs_x))*180/pi; % 第一象限内
    elseif (bs_y == y)
        angle = 0;          % x轴正半轴上
    else
        angle = 360 + atan((y - bs_y) / (x - bs_x))*180/pi;  % 第四象限内
    end
else
    if (bs_y < y)
        angle = 180 + atan((y - bs_y) / (x - bs_x))*180/pi;  % 第二象限
    elseif (bs_y == y)
        angle = 180;  % x负半轴上
    else
        angle = 180 + atan((y - bs_y) / (x - bs_x))*180/pi;  % 第三象限
    end
end
obj.angle_az = angle;

end

