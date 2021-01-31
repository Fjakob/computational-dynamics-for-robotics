classdef InverseDynamics < Algorithm
    % InverseDynamics Computes the inverse dynamics of a RigidBody tree.
    %   An InverseDynamics is an abstract class for computing the dynamics
    %   of a robot.
    %
    %   InverseDynamics Properties:
    %       (none)
    %
    %   InverseDynamics Methods:
    %      iD - An abstract method for computing inverse dynamics
    %      fD - Computes forward dynamics using iD
    %      h - Computes the potential, centripetal, and Coriolis forces
    %      M - Computes the mass matrix
    %
    %   See also Algorithm and ForwardDynamics
    
    % AUTHORS:
    %   <------------ Add your info! ------------>
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1
    
    methods (Abstract)
        tau = iD(obj, q, qd, qdd) % computes the inverse dynamics
    end
    methods
        function h = h(obj, q, qd)
            z = zeros(length(q), 1);
            h = obj.iD(q, qd, z);
        end
        function M = M(obj, q)
            n = length(q);
            M = eye(n);
            z = zeros(n, 1);
            g = obj.h(q, z);
            for i = 1:n
                tau = obj.iD(q, z, M(:,i));
                M(:,i) = tau - g;
            end
        end
        function qdd = fD(obj, q, qd, tau)
            M = obj.M(q);
            h = obj.h(q, qd);
            qdd = M \ (tau - h);
        end
    end
end
