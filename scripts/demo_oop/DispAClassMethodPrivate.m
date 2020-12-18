classdef DispAClassMethodPrivate
    properties
        A
    end
    properties (Access = private)
        B
    end
    methods
        function obj = DispAClassMethodPrivate(a)
            obj.A = a;
            obj.B = 0;
        end
        function dispA(obj, n)
            obj.B = obj.A + 5;
            for i = 1:n
                output(obj, i);
            end
        end
    end
    methods (Access = private)
        function output(obj, i)
            disp(num2str(obj.B + i));
        end
    end
end