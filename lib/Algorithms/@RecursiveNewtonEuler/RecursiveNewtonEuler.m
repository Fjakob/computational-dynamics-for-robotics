classdef RecursiveNewtonEuler < InverseDynamics
    properties (Access = protected)
        Parents % A linear array of parent nodes
        Bodies % A linear array of rigid bodies
        N % The degrees of freedom of the robot
    end
    methods
        function obj = RecursiveNewtonEuler(robot)
            % call the superclass' constructor
            %   * you don't need to do anything else
            %   * how do the properties of this class get set?
        end
        % externally defined functions
        tau = iD(obj, q, qd, qdd)
    end
    methods (Access = protected)
        function obj = setRobot(obj, robot)
%            YOUR TODO LIST:
%                + call superclass's setRobot function
%                + update properties Bodies, Parents, and N
%                + use robot to update these properties
        end
    end
end