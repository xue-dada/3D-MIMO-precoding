%path-loss calculation
Carrier_Freq = 4*10^9; % Carrier frequency
lambda = 3*10^8 / Carrier_Freq; % Wavelength
n_pathloss = 3.5; % Pathloss constant
Tx_Rx_dist = 50; % Distance between BS and MS
ro = ((lambda/(4*pi*5))^2)*(5/Tx_Rx_dist)^n_pathloss; % Pathloss
Pt_avg = 10^(.7); % Average total transmitted power 7dB
Pr_avg = Pt_avg*ro; % Average received power  Ω” ’


d_k = unifrnd(100, 1500)/1000;
gama = 3.76;
beita = d_k^(-gama);  % path-loss model as in [4]
n = sqrt(beita) 

d_k_2 = unifrnd(10, 250)/1000;
gama_2 = 1;
beita_2 = d_k_2^(-gama_2);
n_2 = sqrt(beita_2) 

