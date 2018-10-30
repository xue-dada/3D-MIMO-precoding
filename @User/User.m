classdef User < handle
    %USER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        x  % 横坐标
        y  % 纵坐标
        h  % 高度
        bs_x;  % 基站横坐标
        bs_y;  % 基站纵坐标
        angle_az;  % 水平角
        angle_el;  % 垂直角
        R_az;  % 水平协方差
        R_el;  % 垂直协方差
        d; % 用户离基站距离
        angleSpread_az;
        angleSpread_el;
        csi;  % h_T
        largestEig_az_index;
        largestEig_el_index;
        largestEig_az;
        largestEig_el;
        
    end
    
    methods
        function obj = User(bs_x, bs_y, x, y, h)  % 类的构造函数，r0为小区半径,bs_h0为基站高度
            load config ;
            if nargin == 0  % 空参构造
                obj.bs_x = 0;
                obj.bs_y = 0;
            elseif nargin == 2  % 有参构造
                obj.bs_x = bs_x;
                obj.bs_y = bs_y;
            elseif nargin == 5
                obj.bs_x = bs_x;
                obj.bs_y = bs_y;
                obj.x = x;
                obj.y = y;
                obj.h = h;
            end
%             obj.angleSpread_az = angleSpread_az;
%             obj.angleSpread_el = angleSpread_el;
            obj.angleSpread_az = unifrnd(angleSpread_min, angleSpread_max);
            obj.angleSpread_el = unifrnd(angleSpread_min, angleSpread_max);
            init(obj, r, bs_h, N, M, F_az, F_el);
            
        end
        
        function init(obj, r, bs_h, N, M, F_az, F_el)
            if isempty(obj.x)  % 判断是否之前被赋值
                setCoordinate(obj, r, bs_h);
            end
            calcDistance(obj)
            calcAzimuthAngle(obj)
            functionDivideInto3Sectors( obj );
            calcElevationAngle(obj, bs_h)
            calcCovariance(obj, N, M);
            calcLargestEigAndPos(obj, F_az, F_el);
            calcCSI(obj);
        end
        
        function setCoordinate(obj, r, bs_h)
            flag = 1;
            width = r;
            length = r/2 * 3^(1/2);
            while flag
                obj.x = unifrnd(-width, width); %  随机数（-500, 500）
                obj.y = unifrnd(-length, length);
                if (width - abs(obj.x)) >= (abs(obj.y) / 3^(1/2))
                    obj.h = unifrnd(0, 2 * bs_h);
                    obj.x = obj.bs_x + obj.x;
                    obj.y = obj.bs_y + obj.y;
                    flag = 0;
                end
            end
        end
        
        function calcDistance(obj)
            obj.d = norm([obj.x - obj.bs_x, obj.y - obj.bs_y]); % 计算用户到基站的距离
        end
        
        calcAzimuthAngle(obj);  % 函数申明，函数放在单独的文件中
        
        function calcElevationAngle(obj, bs_h)
            obj.angle_el = atan((obj.h - bs_h)/ obj.d)*180/pi;
        end
        
        calcCovariance(obj, N, M);   % 函数申明，函数放在单独的文件中
        calcLargestEigAndPos(obj, F_az, F_el);
        functionDivideInto3Sectors( obj );  % 函数申明
        calcCSI( obj );

    end
    
end

