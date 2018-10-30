function calcGroup_distribute(group, n)
% https://segmentfault.com/q/1010000010391464
% ���黮��������ֺ��е����ֵ��С
% [10 20 30 40 50 60]�ֳ�3�飬���ŷ���Ϊ[10 20 30] [40 50] [60]

    global min_cell;  % �����洢�����ֺ��е����ֵ��С�ķ���
    global opt_cell;  % �����洢ÿ�εݹ��õķ���
    global min_value; % ������������к�ֵ���ֵ����Сֵ
    if n == 1
        opt_cell{1} = group;
        max_value = -inf;
        for each = opt_cell
            temp = sum(cell2mat(each));
            if temp > max_value
                max_value = temp;  % �ҷ����е����ֵ
            end
        end
        if max_value < min_value
            min_value = max_value;  % ���������ֵ��С
            min_cell = opt_cell;
            return;
        end
    else
        m = length(group);
        for i = n:m
            opt_cell{n} = group(i:m);
            calcGroup_distribute(group(1: i-1), n-1);  % �ݹ��㷨
        end
    end

end

