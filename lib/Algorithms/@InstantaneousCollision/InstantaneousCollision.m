classdef InstantaneousCollision < Algorithm
    properties
        CoefficientOfRestitution
    end
    properties (SetAccess = private)
        PhysicalConstraints
    end
    properties (Access = private)
        CompositeRigidBody
    end
    methods
        function obj = InstantaneousCollision(robot)
            obj@Algorithm(robot);
            obj.PhysicalConstraints = Constraints.empty();
            obj.CompositeRigidBody = CompositeRigidBody(robot);
            obj.CoefficientOfRestitution = 1;
        end
        function obj = setAp(obj, physical)
            obj.PhysicalConstraints = Constraints(obj.Robot, physical);
            obj.PhysicalConstraints.ProportionalGainMatrix = 0;
            obj.PhysicalConstraints.DerivativeGainMatrix = 0;
            k = obj.PhysicalConstraints.K;
            if k > 0
                obj.CoefficientOfRestitution = eye(k);
            else
                obj.CoefficientOfRestitution = 1;
            end
        end
        function [xd, opts] = odeFun(obj, taufun, isterminal, direction)
            % odeFun Returns a function handle for use in Matlab's ODE
            % suite.
            
            if nargin < 3
                isterminal = [];
            end
            if nargin < 4
                direction = [];
            end
            
            if nargin < 2
                xd = obj.CompositeRigidBody.odeFun();
            else
                xd = obj.CompositeRigidBody.odeFun(taufun);
            end
            
            opts = odeset('Events', ...
                @(t, x) events(obj, t, x, isterminal, direction));
        end        
        
        [qd, data] = fD(obj, q, qd)
        impulse = iD(obj, q, qd)
    end
    methods (Access = protected)
        obj = constrain(obj, type, bRT)
    end
end

function [g, isterm, dir] = events(obj, t, x, isterm, dir)
nx = length(x);
nq = nx / 2;
q = x(1:nq);
qd = x(nq+1:nx);

[~, ~, g] = obj.PhysicalConstraints.calcImplicit(q, qd, t);

if isempty(isterm)
    k = length(g);
    isterm = ones(k, 1);
end
end