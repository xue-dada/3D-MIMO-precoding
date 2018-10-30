function [ sumRate ] = calcWithZF( obj, group_1, SNR, errNum, nullSpace )
%CALCRATEWITHZF 此处显示有关此函数的摘要
%   此处显示详细说明
N = obj.N;
M = obj.M;
K1 = length(group_1);        %  group 1 的用户数
[~, y] = size(SNR);          %  1 * 长度y
[N_, M_] = size(obj.targetArr);
K = (N_*M_)/2;   
Rate_1 = zeros(K, y);        %  y * K1
  
if nargin == 5  % 有零空间
    I_az = eye(N);
    h_parm  = kron(I_az, nullSpace);
else
    h_parm = 1;
end

for i = 1:K1
    user_k = group_1(i);
    user = obj.userArr(user_k);
    [h_real, h_err] = calculateChannel(user, errNum, h_parm); % 1 * NM  误差信道
    H_1(i,:) = h_err;  
    H_real(i,:) = h_real;
end
W = H_1' / ( H_1 * H_1'); % H' * inv( H * H')
% beta_zf = sqrt(1/norm(W,'fro').^2);
% W = beta_zf * W;
for i = 1:K1
    W(:,i) = W(:,i)/norm(W(:,i)); % Normalize
end


% -----------group one-----------------
    for i = 1:K1
        h_k = H_real(i,:);  % 获取信道
% ---------------------------
    
       % 根据公式（27）计算速率 
        numerator_right = zeros(1, K1);              % h_T * bi 计算分子右边各项之和
        for j = 1:K1
            if j ~= i
                bi = W(:,j);  % ZF预编码
            else
                bi = W(:,i);  % 求逆 http://www.ilovematlab.cn/thread-431872-1-1.html
            end
            numerator_right(1,j) = abs(h_k * bi).^2;  % 
        end
            denominator_right = numerator_right;
            denominator_right(i) = 0;  % 分母比分子少一项


            rate = 1/2 .* log2( (K1+SNR.*sum(numerator_right)) ./ (K1+SNR.*sum(denominator_right)) );
            Rate_1(i,:) = rate;
    end
      sumRate = sum(Rate_1);

function [ h_real, h_err ] = calculateChannel(user, a, h_parm)
        R_az_user = user.R_az;    %  得到用户的水平协方差
        R_el_user = user.R_el;    %  得到用户的垂直协方差

        H_w = 1/sqrt(2)*(randn(N,M)+1i*randn(N,M));   % 独立同分布的复高斯矩阵
        H = R_az_user^(1/2) * H_w * R_el_user^(1/2);  % 公式（3）的信道
        g_k = reshape(H,N*M, 1);                         % 矩阵矢量化
        
%         d_k = (unifrnd(100, 500) + user.d) / 1000;
        d_k = user.d / 1000;
%         d_k = user.d / 150;
        gama = 2;
        beita = d_k^(-gama);  % path-loss model as in [4]
        
        g_error = 1/sqrt(2)*(randn(N*M,1)+1i*randn(N*M,1));
%         h_real = sqrt(beita) .* g_k ;
%         h_err = sqrt(beita) .* (sqrt(1-a^2).*g_k + a.*g_error);
        h_real = user.csi * h_parm;
        if a == 0
            h_err = h_real;
        else
            h_length = length(h_real);
            g_error = 1/sqrt(2)*(randn(h_length,1)+1i*randn(h_length,1));
            h_err = sqrt(1-a^2).*h_real + sqrt(beita)*a.*g_error.';
        end
end

end

