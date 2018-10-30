function [ user_group ] = divideGroup( obj )
%DIVIDEGROUP 此处显示有关此函数的摘要
%   此处显示详细说明
group_1 = [];
group_2 = [];
user_clusters = obj.userClusters;
[N_, M_] = size(user_clusters);

    for x = 1:N_
        for y = 1:M_
            if ~isempty(user_clusters{x, y})
                if ~mod(x+y, 2)  
                    % 按和，取余，取值为0，即块的下标为都为奇或偶数
                    group_1(end+1) = user_clusters{x,y}(1,1);
                else
                    % 取值为1，即块的下标为一奇数，一偶数
                    group_2(end+1) = user_clusters{x,y}(1,1);
                end
            end
        end
    end
user_group = cell(1,2);
user_group{1} = group_1;
user_group{2} = group_2;


end

