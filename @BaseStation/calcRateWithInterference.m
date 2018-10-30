function [ sumRate ] = calcRateWithInterference( obj, group_1, SNR, cellInterference )
%CALCOTHERCELLINTERFERENCE 此处显示有关此函数的摘要
%   此处显示详细说明
load config F_az F_el N;
N = obj.N;
M = obj.M;
[N_, M_] = size(obj.targetArr);
K1 = length(group_1);        %  group 1 的用户数
[~, y] = size(SNR);          %  1 * 长度y
K = (N_*M_)/2;   
Rate_1 = zeros(K, y);        %  y * K1

% -----------group one-----------------
    for i = 1:K1   
        user_k = group_1(i);             %　从分组中取用户
        h_T = obj.userArr(user_k).csi;
% ---------------------------

       % 根据公式（27）计算速率 
        numerator_right = zeros(1, K1);              % h_T * bi 计算分子右边各项之和
        for j = 1:K1
            user_index = group_1(j);
            pos_az = obj.userArr(user_index).largestEig_az_index;
            pos_el = obj.userArr(user_index).largestEig_el_index;
            F_az_user = F_az(:,pos_az);
            F_el_c = conj(F_el);
            F_el_user = F_el_c(:,pos_el);
            bi = kron(F_az_user, F_el_user);  % NM * 1
            numerator_right(1,j) = abs(h_T * bi).^2;  % 
        end
            denominator_right = numerator_right;
            denominator_right(i) = 0;  % 分母比分子少一项

            rate = 1/2 .* log2( (K1+SNR.*sum(numerator_right) + cellInterference) ./ (K1+SNR.*sum(denominator_right) + cellInterference) );
            Rate_1(i,:) = rate;
    end
      Rate = sum(Rate_1);

sumRate = Rate;
end

