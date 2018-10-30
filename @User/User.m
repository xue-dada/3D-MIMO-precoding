classdef User < handle
    %USER �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        x  % ������
        y  % ������
        h  % �߶�
        bs_x;  % ��վ������
        bs_y;  % ��վ������
        angle_az;  % ˮƽ��
        angle_el;  % ��ֱ��
        R_az;  % ˮƽЭ����
        R_el;  % ��ֱЭ����
        d; % �û����վ����
        angleSpread_az;
        angleSpread_el;
        csi;  % h_T
        largestEig_az_index;
        largestEig_el_index;
        largestEig_az;
        largestEig_el;
        
    end
    
    methods
        function obj = User(bs_x, bs_y, x, y, h)  % ��Ĺ��캯����r0ΪС���뾶,bs_h0Ϊ��վ�߶�
            load config ;
            if nargin == 0  % �ղι���
                obj.bs_x = 0;
                obj.bs_y = 0;
            elseif nargin == 2  % �вι���
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
            if isempty(obj.x)  % �ж��Ƿ�֮ǰ����ֵ
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
                obj.x = unifrnd(-width, width); %  �������-500, 500��
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
            obj.d = norm([obj.x - obj.bs_x, obj.y - obj.bs_y]); % �����û�����վ�ľ���
        end
        
        calcAzimuthAngle(obj);  % �����������������ڵ������ļ���
        
        function calcElevationAngle(obj, bs_h)
            obj.angle_el = atan((obj.h - bs_h)/ obj.d)*180/pi;
        end
        
        calcCovariance(obj, N, M);   % �����������������ڵ������ļ���
        calcLargestEigAndPos(obj, F_az, F_el);
        functionDivideInto3Sectors( obj );  % ��������
        calcCSI( obj );

    end
    
end

