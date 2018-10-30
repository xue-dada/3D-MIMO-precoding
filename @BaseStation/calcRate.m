function [ sumRate ] = calcRate( obj, group_1, SNR, nullSpace )
%CALCSUMRATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
load config F_az F_el N;
N = obj.N;
M = obj.M;
[N_, M_] = size(obj.targetArr);
K1 = length(group_1);        %  group 1 ���û���
[~, y] = size(SNR);          %  1 * ����y
K = (N_*M_)/2;   
Rate_1 = zeros(K, y);        %  y * K1

if nargin == 4  % ����ռ�
    I_az = eye(N);
    h_parm  = kron(I_az, nullSpace);
    F_parm = nullSpace';
else
    h_parm = 1;
    F_parm = 1;
end
% -----------group one-----------------
    for i = 1:K1   
        user_k = group_1(i);             %���ӷ�����ȡ�û�
        h_T = obj.userArr(user_k).csi * h_parm;
% ---------------------------

       % ���ݹ�ʽ��27���������� 
        numerator_right = zeros(1, K1);              % h_T * bi ��������ұ߸���֮��
        for j = 1:K1
            user_index = group_1(j);
            pos_az = obj.userArr(user_index).largestEig_az_index;
            pos_el = obj.userArr(user_index).largestEig_el_index;
            F_az_user = F_az(:,pos_az);
            F_el_c = F_parm * conj(F_el);
            F_el_user = F_el_c(:,pos_el);
            bi = kron(F_az_user, F_el_user);  % NM * 1
            numerator_right(1,j) = abs(h_T * bi).^2;  % 
        end
            denominator_right = numerator_right;
            denominator_right(i) = 0;  % ��ĸ�ȷ�����һ��

            rate = 1/2 .* log2( (K1+SNR.*sum(numerator_right)) ./ (K1+SNR.*sum(denominator_right)) );
            Rate_1(i,:) = rate;
    end
      Rate = sum(Rate_1);

sumRate = Rate;
end


