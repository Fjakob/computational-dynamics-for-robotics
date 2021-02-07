classdef RecursiveNewtonEulerRecursion < InverseDynamics
    properties
        Mapping
    end
    methods
        function obj = RecursiveNewtonEulerRecursion(robot, map)
            obj@InverseDynamics(robot);
            if nargin > 1
                obj.Mapping = map;
            end
        end
        % externally defined functions
        tau = iD(obj, q, qd, qdd)
    end
    methods (Access = protected)
        function obj = setRobot(obj, robot)
            setRobot@InverseDynamics(obj, robot);
            obj.Mapping = {};
        end
    end
end