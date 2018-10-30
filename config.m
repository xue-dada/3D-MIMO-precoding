N = 40;  % 水平天线
M = 100;  % 垂直天线
userNum = 100;  % 用户数
r = 100;  % 小区半径
bs_h = 35; % 基站高度
angleSpread_az = 5;  % 水平扩展角
angleSpread_el = 2.5;  % 垂直扩展角
angleSpread_min = 2.5;
angleSpread_max = 5;

snr_db = (-10:1:20);
snr = 10.^(snr_db/10);

bs_coordinate = [0, 0, 0, r*3^(1/2), 0, -r*3^(1/2), ...
                r*1.5, r*0.5*3^(1/2), r*1.5,-r*0.5*3^(1/2), ...
                -r*1.5, r*0.5*3^(1/2), -r*1.5, -r*0.5*3^(1/2)];

F_az = zeros(N, N);  % 酉矩阵
F_el = zeros(M, M);

for m = 1:N
    for n = 1:N
        F_az(m, n) = (1/sqrt(N))*exp(1i*2*pi*(m-1)*(n-(N/2))/N);
    end
end


for m = 1:M
    for n = 1:M  
        F_el(m, n) = (1/sqrt(M))*exp(1i*2*pi*(m-1)*(n-(M/2))/M);
    end    
end
save config.mat