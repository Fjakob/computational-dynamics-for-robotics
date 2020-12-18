classdef DispABaseClass
    properties
        A
    end
    properties (Access = protected)
        B
    end
    methods
        function obj = DispABaseClass(a)
            obj.A = a;
            obj.B = 0;
        end
        function dispA(obj, n)
            obj.B = obj.A + 5;
            for i = 1:n
                s = num2str(obj.B + i);
                disp(s);
            end
        end
    end
end