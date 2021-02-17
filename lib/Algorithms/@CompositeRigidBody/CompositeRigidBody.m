classdef CompositeRigidBody < RecursiveNewtonEuler
    methods
        function obj = CompositeRigidBody(robot)
            obj@RecursiveNewtonEuler(robot);
        end
%         function tau = iD(obj, q, qd, qdd)
%             tau = obj.M(q) * qdd + obj.h(q, qd);
%         end
        % externally defined functions
        M = M(obj, q)
    end
end
