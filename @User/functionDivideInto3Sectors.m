function functionDivideInto3Sectors( obj )
%FUNCTIONDIVIDEINTO3SECTORS ���û��ķ�λ�Ƿֳ���������
%   �˴���ʾ��ϸ˵��


    angle = obj.angle_az;
    if angle >= 330  
        temp = angle - 360 -30;  % ��һ������
    elseif angle < 90
        temp = angle - 30;  % ��һ������
    elseif angle >= 90 && angle < 210
        temp = angle - 150;  % �ڶ�������
    else
        temp = angle - 270;  % ����������
    end

obj.angle_az = temp;
end

