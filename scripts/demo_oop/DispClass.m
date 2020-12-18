classdef DispClass
    properties
        A
    end
    methods
        function obj = DispClass(a)
            obj.A = a;
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