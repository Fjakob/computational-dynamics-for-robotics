classdef CompositeRigidBody < RecursiveNewtonEuler
    methods
        function obj = CompositeRigidBody(robot)
            obj@RecursiveNewtonEuler(robot);
        end
%%%%%%%%%%%%%% DELETE BELOW, NOT NECESSARY AND LEADS TO INFINITE RECURSION        
%   In the code below, iD(...) calls h(...) which calls iD which calls h,
%   etc.
%         function tau = iD(obj, q, qd, qdd)
%             tau = obj.M(q) * qdd + obj.h(q, qd);
%         end
%%%%%%%%%%%%%% DELETE ABOVE, NOT NECESSARY AND LEADS TO INFINITE RECURSION
        % externally defined functions
        M = M(obj, q)
    end
end
