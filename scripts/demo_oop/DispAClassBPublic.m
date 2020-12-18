classdef DispAClassBPublic
    properties
        A
        B
    end
    methods
        function obj = DispAClassBPublic(a)
            obj.A = a;
            obj.B = 0;
        end
        function obj = set.A(obj, a)
            obj.A = a;
            obj.B = a + 5;
        end
        function dispA(obj, n)
            a = obj.A;
            b = obj.B;
            for i = 1:n
                s = num2str(b + i);
                disp(s);
            end
        end
    end
end
