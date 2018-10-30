function user_clusters = calcUserClusters( obj, N_, M_ )
%CALCUSERCLUSTER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
UserLargestEigAndPos = zeros(obj.userNum, 4);
for i = 1 : obj.userNum
    UserLargestEigAndPos(i,:) = [obj.userArr(i).largestEig_az_index 
                                 obj.userArr(i).largestEig_el_index 
                                 obj.userArr(i).largestEig_az 
                                 obj.userArr(i).largestEig_el];
end

[sorted_pos_az, index_az] = sortrows(UserLargestEigAndPos, 1);  % ���û�����ֵλ������UserLargestEigAndPos(index,:);
pos_az_map = tabulate(sorted_pos_az(:,1)/2);  % ͳ������ֵ���ִ�����������Ԫ��ʱ�Ǹ�����ʱ����ͳ��0�Σ���������д
pos_az_map(:,1) = pos_az_map(:,1)*2;          % http://www.ilovematlab.cn/thread-222441-1-1.html

groups_az = pos_az_map(:,2);  % �������ֵλ�õ��û�����λ�ôӵ͵���
A = groups_az;                % A�Ǹ�������ֵλ�õ��û�������С����

global min_cell;   % �����洢�����ֺ��е����ֵ��С�ķ���
min_cell = {};
global opt_cell;   % �����洢ÿ�εݹ��õķ���
opt_cell = {};
global min_value;  % ������������к�ֵ���ֵ����Сֵ
min_value = inf;

calcGroup_distribute(A, N_);  % �����ֺ��е����ֵ��С�ķ���
a = 1;
b = 0;
for i = 1:N_          
    b = b + sum(min_cell{i});
    c(1,a:b) = index_az(a:b);  % ��һ���û��±꣬�ڶ��ж�Ӧ�ķ��飬index_azΪԭ����λ���±�
    c(2,a:b) = i;
    a = b+1;
end

% ----------------���㴹ֱ����ֵ����--------------------------------
[sorted_pos_el, index_el] = sortrows(UserLargestEigAndPos, 2);  % UserLargestEigAndPos(index,:);
pos_el_map = tabulate(sorted_pos_el(:,2)/2);  % ͳ������ֵ���ִ�����������Ԫ��ʱ�Ǹ�����ʱ����ͳ��0�Σ���������д
pos_el_map(:,1) = pos_el_map(:,2)*2;          % http://www.ilovematlab.cn/thread-222441-1-1.html

groups_el = pos_el_map(:,2);  % �������ֵλ�õ��û�����λ�ôӵ͵���
B = groups_el;

min_cell = {};
opt_cell = {};
min_value = inf;
calcGroup_distribute(B, M_);
a = 1;
b = 0;
for i = 1:M_
    b = b + sum(min_cell{i}); 
    d(1, a:b) = index_el(a:b);  % ��һ���û��±꣬�ڶ��ж�Ӧ�ķ��飬index_elΪԭ����λ���±�
    d(2, a:b) = i;
    a = b+1;
end

% -----------------���û��ŵ���������------------------------
user_clusters = cell(N_, M_); 
for i = 1:length(c)
    user_index = c(1, i);
    x = c(2,i);  % ˮƽ�����±�
%     d_index = find(d(1,:)==user_index);  % ������һ�й���һ�����������
    d_index = d(1,:)==user_index;   % ���û����Ӧ�Ĵ�ֱ�±꣬(��Ϊˮƽ�봹ֱ�Ƿֿ������)
    y = d(2, d_index); % ��ֱ�����±�
    
    eig_az = UserLargestEigAndPos(user_index, 3);
    eig_el = UserLargestEigAndPos(user_index, 4);
    user_clusters{x, y}(1, end+1) = user_index;  % ���û����ڷִأ�x,y����
    user_clusters{x, y}(2, end) = eig_az*eig_el;  % save eig_az*eig_el   
end   
    % ����ˮƽ��ֱ����ֵ�ĳ˻�����
    for x = 1:N_
        for y = 1:M_
            if ~isempty(user_clusters{x, y})  % �ж��Ƿ�Ϊ��
                temp = sortrows(user_clusters{x, y}', -2);  % ת�ú󣬰��ڶ��н������У��Ӵ�С
                user_clusters{x, y} = temp';  % ��ת�ã��ָ�
            end
        end
    end
obj.userClusters = user_clusters;   
end


