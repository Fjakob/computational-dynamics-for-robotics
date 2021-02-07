classdef RecursiveNewtonEuler < InverseDynamics
    % RecursiveNewtonEuler Computes the dynamics of a RigidBody tree.
    %   The RecursiveNewtonEuler computes the dynamics of a robot of the
    %   form
    %       M(q) qdd + h(q, qd) = tau.
    %   In particular, the algorithm provides efficient computations for
    %   h(q, qd) and is capable of computing M(q), but, in general, not as
    %   efficiently as the CompositeRigidBody.  The class inherits from
    %   InverseDynamics.
    %
    %   RecursiveNewtonEuler Properties:
    %       Parent - A linear array of parent nodes
    %       Bodies - A linear array of rigid bodies of type RigidBody
    %       N - The degrees of freedom of the robot model
    %
    %   RecursiveNewtonEuler Methods:
    %      iD - An implementation of the recursive Newton-Euler algorithm
    %      using integer and object arrays.
    %
    %   See also RigidBody, Algorithm, InverseDynamics,
    %   RecursiveNewtonEulerRecursion, and CompositeRigidBody
    
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