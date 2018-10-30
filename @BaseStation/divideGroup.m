function [ user_group ] = divideGroup( obj )
%DIVIDEGROUP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
group_1 = [];
group_2 = [];
user_clusters = obj.userClusters;
[N_, M_] = size(user_clusters);

    for x = 1:N_
        for y = 1:M_
            if ~isempty(user_clusters{x, y})
                if ~mod(x+y, 2)  
                    % ���ͣ�ȡ�࣬ȡֵΪ0��������±�Ϊ��Ϊ���ż��
                    group_1(end+1) = user_clusters{x,y}(1,1);
                else
                    % ȡֵΪ1��������±�Ϊһ������һż��
                    group_2(end+1) = user_clusters{x,y}(1,1);
                end
            end
        end
    end
user_group = cell(1,2);
user_group{1} = group_1;
user_group{2} = group_2;


end

