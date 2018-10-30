classdef BaseStation < handle
    %BASESTATION �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        bs_x
        bs_y
        bs_h
        r  % С���뾶
        N  % ˮƽ��������
        M  % ��ֱ��������
        userNum
        userArr
        targetArr 
        userClusters
        otherCellArr  % ����С�����û������¼����ŵ����
        oldCellArr  % ����С�����û�
    end
    
    methods
        function obj = BaseStation(x, y)
            load config;  % ���������ļ�config.mat
            if nargin == 0
                obj.bs_x = 0;
                obj.bs_y = 0;
            elseif nargin == 2              
                obj.bs_x = x;
                obj.bs_y = y;
            end
            obj.bs_h = bs_h;
            obj.r = r;
            obj.N = N;
            obj.M = M;
            obj.userNum = userNum;
            init(obj);
            
        end
        
        function init(obj)
            initUserArr(obj);
        end
        
        function initUserArr(obj)
            arr(1, obj.userNum) = User();
           for i = 1 : obj.userNum
               arr(i) = User(obj.bs_x, obj.bs_y);
           end
           obj.userArr = arr;
        end
               
        val = calcUserClusters(obj, N_, M_);  % �����������������
        val = divideGroup(obj);
        val = calcRate(obj, group, SNR, nullSpace);
        
        function val = calcSumRate(obj, SNR, nullSpace)
            userGroup = divideGroup(obj);
            if nargin == 2
                Rate_1 = calcRate(obj, userGroup{1}, SNR);
                Rate_2 = calcRate(obj, userGroup{2}, SNR);
            elseif nargin == 3
                Rate_1 = calcRate(obj, userGroup{1}, SNR, nullSpace);
                Rate_2 = calcRate(obj, userGroup{2}, SNR, nullSpace);
            end
            val = Rate_1 + Rate_2;     
        end
        
        function getTargetArr(obj)
           userGroup =  divideGroup(obj);
           indexArr = [userGroup{1}, userGroup{2}];
           arr(1, length(indexArr)) = User(); % ��ʼ��
           for i = 1 : length(indexArr)
               arr(i) = obj.userArr(indexArr(i));
           end
           obj.targetArr = arr;
           
        end
        
        function val = initOtherCellArr(obj)  % ��ʼ������С�����û�������Ҫ��
            count = 1;
            for i = 1 : length(obj.otherCellArr)  % ��һ��cell��������
                for j = 1 : length(obj.otherCellArr{i})
                    user = obj.otherCellArr{i}(j);
                    oldArr(count) = user;
                    arr(count) = User(obj.bs_x, obj.bs_y, user.x, user.y, user.h);
                    count = count + 1;
                end
            end
            val = arr;
            obj.oldCellArr = oldArr;
            obj.otherCellArr = arr;
        end
        
        val = clacCellInterference( obj );
        val = calcRateWithInterference(obj, SNR, group, cellInterference);
        
        function val = calcRateWithCellInterference(obj, SNR, cellInterference)
            userGroup = divideGroup(obj);
            Rate_1 = calcRateWithInterference(obj, userGroup{1}, SNR, cellInterference);
            Rate_2 = calcRateWithInterference(obj, userGroup{2}, SNR, cellInterference);
            val = Rate_1 + Rate_2;     
        end
        
        val = calcWithZF( obj, group, SNR, errNum, nullSpace );
        function val = calcRateWithZF(obj, SNR, errNum, nullSpace)
            userGroup = divideGroup(obj);
            if nargin == 3
                Rate_1 = calcWithZF(obj, userGroup{1}, SNR, errNum);
                Rate_2 = calcWithZF(obj, userGroup{2}, SNR, errNum);
            elseif nargin == 4
                Rate_1 = calcWithZF(obj, userGroup{1}, SNR, errNum, nullSpace);
                Rate_2 = calcWithZF(obj, userGroup{2}, SNR, errNum, nullSpace);
            end
            val = Rate_1 + Rate_2;    
        end

    end
    
end

