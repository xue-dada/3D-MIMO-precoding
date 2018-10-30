function calcGroup_distribute(group, n)
% https://segmentfault.com/q/1010000010391464
% 数组划分求各划分和中的最大值最小
% [10 20 30 40 50 60]分成3组，最优分组为[10 20 30] [40 50] [60]

    global min_cell;  % 用来存储各划分和中的最大值最小的分组
    global opt_cell;  % 用来存储每次递归获得的分组
    global min_value; % 用来保存分组中和值最大值的最小值
    if n == 1
        opt_cell{1} = group;
        max_value = -inf;
        for each = opt_cell
            temp = sum(cell2mat(each));
            if temp > max_value
                max_value = temp;  % 找分组中的最大值
            end
        end
        if max_value < min_value
            min_value = max_value;  % 分组和最大的值最小
            min_cell = opt_cell;
            return;
        end
    else
        m = length(group);
        for i = n:m
            opt_cell{n} = group(i:m);
            calcGroup_distribute(group(1: i-1), n-1);  % 递归算法
        end
    end

end

