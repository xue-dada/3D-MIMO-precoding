function calcLargestEigAndPos( obj, F_az, F_el )
%CALCLARGESTEIGANDPOS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    R_az = obj.R_az;
    R_el = obj.R_el;

    diag_az = F_az' * R_az * F_az;  % N*N �õ��Խ���
    diag_el = F_el' * R_el * F_el;  % M*M
    
    largest_eig_az = max(max(diag_az));  % �õ��������ֵ
    largest_eig_el = max(max(diag_el));
    [x_az, y_az] = find(diag_az==largest_eig_az);
    [x_el, y_el] = find(diag_el==largest_eig_el);
    
    if (x_az == y_az) && (x_el == y_el)  % �ж��Ƿ��ǶԽ�����ȡ������
        obj.largestEig_az_index = x_az;
        obj.largestEig_el_index = x_el;
        obj.largestEig_az = largest_eig_az;
        obj.largestEig_el = largest_eig_el;
    else    
        disp('error---in ','---diag_az or diag_el is not a diagonal matrix');
    end

end

