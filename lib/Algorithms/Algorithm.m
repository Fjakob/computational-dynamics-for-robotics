classdef Algorithm < handle
    properties
        Robot
    end
    methods
        function obj = Algorithm(robot)
            obj.Robot = robot;
        end
        function set.Robot(obj, robot)
            obj.Robot = robot;
            obj.setRobot(robot);
        end
    end
    methods (Access = protected)
        function obj = setRobot(obj, robot) %#ok<INUSD>
            % override with custom code in subclass if necessary
        end
    end
end

