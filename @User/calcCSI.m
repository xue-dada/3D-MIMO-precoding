function calcCSI( obj )
%CALCCSI 此处显示有关此函数的摘要
%   此处显示详细说明
        load config F_az F_el N M;
        R_az_user = obj.R_az;
        R_el_user = obj.R_el;
        diag_az = F_az' * R_az_user * F_az;
        diag_el = F_el' * R_el_user * F_el;
        H_w = 1/sqrt(2)*(randn(N,M)+1i*randn(N,M));
        h_w = reshape(H_w,N*M, 1);
        h_w_T = h_w.';
        F = kron(F_az, conj(F_el));

%         d_k = obj.d/150;
%         d_k = (unifrnd(100, 500) + obj.d) / 1000;
        d_k = obj.d / 1000;
        gama = 2;
        beita = d_k^(-gama);  % path-loss model as in [4]
        h_T = sqrt(beita) * h_w_T * kron(diag_az^(1/2), diag_el^(1/2)) * F';
        obj.csi = h_T;
end

