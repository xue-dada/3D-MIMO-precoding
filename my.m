classdef my
    %MY �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties(Access=private)
        a
        b
    end
    
    methods
        function obj = my(a, b)
            if nargin == 0
                obj.a = 1;
                obj.b = 2;
            elseif nargin == 2
                obj.a = a;
                obj.b = b;
            end
        end
       
        function val = getN(obj)
            val = [obj.a obj.b];
        end
                
    end
    
end

