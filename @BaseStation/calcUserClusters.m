function user_clusters = calcUserClusters( obj, N_, M_ )
%CALCUSERCLUSTER 此处显示有关此函数的摘要
%   此处显示详细说明
UserLargestEigAndPos = zeros(obj.userNum, 4);
for i = 1 : obj.userNum
    UserLargestEigAndPos(i,:) = [obj.userArr(i).largestEig_az_index 
                                 obj.userArr(i).largestEig_el_index 
                                 obj.userArr(i).largestEig_az 
                                 obj.userArr(i).largestEig_el];
end

[sorted_pos_az, index_az] = sortrows(UserLargestEigAndPos, 1);  % 按用户特征值位置排序，UserLargestEigAndPos(index,:);
pos_az_map = tabulate(sorted_pos_az(:,1)/2);  % 统计特征值出现次数，当所有元素时非负整数时，会统计0次，所以这样写
pos_az_map(:,1) = pos_az_map(:,1)*2;          % http://www.ilovematlab.cn/thread-222441-1-1.html

groups_az = pos_az_map(:,2);  % 最大特征值位置的用户数，位置从低到高
A = groups_az;                % A是各个特征值位置的用户数，从小到大

global min_cell;   % 用来存储各划分和中的最大值最小的分组
min_cell = {};
global opt_cell;   % 用来存储每次递归获得的分组
opt_cell = {};
global min_value;  % 用来保存分组中和值最大值的最小值
min_value = inf;

calcGroup_distribute(A, N_);  % 各划分和中的最大值最小的分组
a = 1;
b = 0;
for i = 1:N_          
    b = b + sum(min_cell{i});
    c(1,a:b) = index_az(a:b);  % 第一行用户下标，第二行对应的分组，index_az为原来的位置下标
    c(2,a:b) = i;
    a = b+1;
end

% ----------------计算垂直特征值分组--------------------------------
[sorted_pos_el, index_el] = sortrows(UserLargestEigAndPos, 2);  % UserLargestEigAndPos(index,:);
pos_el_map = tabulate(sorted_pos_el(:,2)/2);  % 统计特征值出现次数，当所有元素时非负整数时，会统计0次，所以这样写
pos_el_map(:,1) = pos_el_map(:,2)*2;          % http://www.ilovematlab.cn/thread-222441-1-1.html

groups_el = pos_el_map(:,2);  % 最大特征值位置的用户数，位置从低到高
B = groups_el;

min_cell = {};
opt_cell = {};
min_value = inf;
calcGroup_distribute(B, M_);
a = 1;
b = 0;
for i = 1:M_
    b = b + sum(min_cell{i}); 
    d(1, a:b) = index_el(a:b);  % 第一行用户下标，第二行对应的分组，index_el为原来的位置下标
    d(2, a:b) = i;
    a = b+1;
end

% -----------------将用户放到各个簇中------------------------
user_clusters = cell(N_, M_); 
for i = 1:length(c)
    user_index = c(1, i);
    x = c(2,i);  % 水平分组下标
%     d_index = find(d(1,:)==user_index);  % 与下面一行功能一样，便于理解
    d_index = d(1,:)==user_index;   % 找用户相对应的垂直下标，(因为水平与垂直是分开计算的)
    y = d(2, d_index); % 垂直分组下标
    
    eig_az = UserLargestEigAndPos(user_index, 3);
    eig_el = UserLargestEigAndPos(user_index, 4);
    user_clusters{x, y}(1, end+1) = user_index;  % 将用户放在分簇（x,y）中
    user_clusters{x, y}(2, end) = eig_az*eig_el;  % save eig_az*eig_el   
end   
    % 按照水平垂直特征值的乘积排序
    for x = 1:N_
        for y = 1:M_
            if ~isempty(user_clusters{x, y})  % 判断是否为空
                temp = sortrows(user_clusters{x, y}', -2);  % 转置后，按第二列降序排列，从大到小
                user_clusters{x, y} = temp';  % 再转置，恢复
            end
        end
    end
obj.userClusters = user_clusters;   
end


