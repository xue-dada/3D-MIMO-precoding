classdef BaseStation < handle
    %BASESTATION 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        x
        y
        h
        r
        N  % 水平天线数
        M  % 垂直天线数
        userNum
        userArr
        targetArr 
    end
    
    methods
        function obj = BaseStation(x, y, h, r, userNum)
            if nargin == 0
                obj.x = 0;
                obj.y = 0;
                obj.h = 35;
                obj.r = 500;
                obj.userNum = 100; 
            elseif nargin == 5              
                obj.x = x;
                obj.y = y;
                obj.h = h;
                obj.r = r;
                obj.userNum = userNum;
            end
        end
        
        function init(obj)
            getUserArr(obj);
        end
        
        function getUserArr(obj)
            arr(1, obj.userNum) = User();
           for i = 1 : obj.userNum
               arr(i) = User(obj.x, obj.y, obj.r, obj.h);
           end
           obj.userArr = arr;
        end
    end
    
end

