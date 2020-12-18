classdef DispASubClass < DispABaseClass
    properties
        C
    end
    methods
        function obj = DispASubClass(a, c)
            obj@DispABaseClass(a);
            obj.C = c;
        end
        function dispA(obj, n)
            obj.B = -3 * obj.A;
            for i = 1:n
                s = num2str(obj.B + rand);
                disp(s);
            end
        end
        function dispC(obj)
            disp(obj.C);
        end
    end
end