function functionDivideInto3Sectors( obj )
%FUNCTIONDIVIDEINTO3SECTORS 将用户的方位角分成三个扇区
%   此处显示详细说明


    angle = obj.angle_az;
    if angle >= 330  
        temp = angle - 360 -30;  % 第一个扇区
    elseif angle < 90
        temp = angle - 30;  % 第一个扇区
    elseif angle >= 90 && angle < 210
        temp = angle - 150;  % 第二个扇区
    else
        temp = angle - 270;  % 第三个扇区
    end

obj.angle_az = temp;
end

