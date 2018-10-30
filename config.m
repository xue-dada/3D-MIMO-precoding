N = 40;  % ˮƽ����
M = 100;  % ��ֱ����
userNum = 100;  % �û���
r = 100;  % С���뾶
bs_h = 35; % ��վ�߶�
angleSpread_az = 5;  % ˮƽ��չ��
angleSpread_el = 2.5;  % ��ֱ��չ��
angleSpread_min = 2.5;
angleSpread_max = 5;

snr_db = (-10:1:20);
snr = 10.^(snr_db/10);

bs_coordinate = [0, 0, 0, r*3^(1/2), 0, -r*3^(1/2), ...
                r*1.5, r*0.5*3^(1/2), r*1.5,-r*0.5*3^(1/2), ...
                -r*1.5, r*0.5*3^(1/2), -r*1.5, -r*0.5*3^(1/2)];

F_az = zeros(N, N);  % �Ͼ���
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