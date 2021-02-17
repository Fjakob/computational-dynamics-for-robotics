classdef Constraints < handle
    % The robot's constraints.  The library is able to represent constraints in
    % two flavors.  We discuss the one used in this demo.  When we want to
    % constrain a point c on rigid body b of a robot, we only need to specify
    % the rigid body b, the transform T_bc in SE(3) to locate the point on the
    % body, and the constraints A that we want to apply such that
    %
    %   A * Ad_{T} V = A * Ad_{T} * J(q) \dot{q} = 0
    %
    % or in coordinates
    %
    %   A_cc * Ad_{T_cb} V_bb = A_cc * Ad_{T_cb} * J_bb(q) \dot{q} = 0
    %
    % where A is a constant m x 6 matrix (m <= 6), V is a 6 x 1 twist, and
    properties
        ImplicitConstraints
        ProportionalGainMatrix
        DerivativeGainMatrix
        Epsilon
    end
    properties (Dependent)
        Robot
        K
        M
        N
    end
    properties (SetAccess = private)
        Bodies
        Parent
        RigidBodyConstraints
        RigidBodyMap % maps constraint numbers to linear indices
    end
    methods
        function obj = Constraints(robot, constraints)
            obj.Robot = robot;
            obj.constrain(constraints);
            obj.clearImplicitConstraints();
            
            obj.ProportionalGainMatrix = eye(obj.K);
            obj.DerivativeGainMatrix = eye(obj.K);
            obj.Epsilon = 1;
        end
        function k = get.K(obj)
            k = obj.RigidBodyMap(end, 2);
        end
        function m = get.M(obj)
            m = size(obj.RigidBodyMap, 1);
        end
        function n = get.N(obj)
            n = length(obj.Bodies);
        end
        function robot = get.Robot(obj)
            robot = obj.Bodies(1).Parent;
        end
        function set.Robot(obj, robot)
            [obj.Bodies, obj.Parent] = robot.toArray();
        end
        function obj = clearImplicitConstraints(obj)
            obj.ImplicitConstraints = @noInputConstraints;
        end
        
        % external functions
        [J, phi, h, hdot] = calcImplicit(obj, q, qdot, t)
        J = Jacobian(obj, q)
    end
    methods (Access = private)
        % external functions
        obj = constrain(obj, bRT)
    end
end

function [J, phi, h, hdot] = noInputConstraints(q, qdot, t) %#ok<INUSD>
J = 0;
phi = 0;
h = 0;
hdot = 0;
end