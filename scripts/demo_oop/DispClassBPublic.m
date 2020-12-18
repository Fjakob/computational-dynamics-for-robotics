classdef DispClassBPublic
    properties
        A
        B
    end
    methods
        function obj = DispClassBPublic(a)
            obj.A = a;
            obj.B = 0;
        end
        function dispA(obj, n)
            a = obj.A;
            b = a + 5;
            for i = 1:n
                s = num2str(b + i);
                disp(s);
            end
        end
    end
end