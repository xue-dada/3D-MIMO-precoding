function [ cellInterference ] = clacCellInterference( obj )
%CLACCELLINTERFERENCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
load config F_az F_el N;

K1 = length(obj.otherCellArr);        %  group 1 ���û���

otherCellArr = obj.otherCellArr;
oldCellArr = obj.oldCellArr;

numerator_right = zeros(1, K1); 

for i = 1:K1
    newUser = otherCellArr(i);    
    h_T = newUser.csi;  % ����С���û�������С���ŵ�
    
    oldUser = oldCellArr(i);
    pos_az = oldUser.largestEig_az_index;
    pos_el = oldUser.largestEig_el_index;
    F_az_user = F_az(:,pos_az);
    F_el_c = conj(F_el);  
    F_el_user = F_el_c(:,pos_el);
    bi = kron(F_az_user, F_el_user);  % NM * 1
    numerator_right(i) = abs(h_T * bi).^2;  % 
end
cellInterference = sum(numerator_right);

