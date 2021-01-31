classdef ForwardDynamics < Algorithm
    % ForwardDynamics Computes the forward dynamics of a RigidBody tree.
    %   An ForwardDynamics is an abstract class for computing the dynamics
    %   of a robot.
    %
    %   ForwardDynamics Properties:
    %       (none)
    %
    %   ForwardDynamics Methods:
    %      fD - An abstract method for computing the forward dynamics.    
    %      iD - Computes inverse dynamics using fD
    %      Minvh - Computes potential, centripetal, and Coriolis 
    %              accelerations
    %      Minv - Computes the mass matrix inverse
    %
    %   See also Algorithm and ForwardDynamics
    
    % AUTHORS:
    %   <------------ Add your info! ------------>
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1    
    methods (Abstract)
        qdd = fD(obj, q, qd, tau) % computes the forward dynamics
    end
    methods
        function a = Minvh(obj, q, qd)
            z = zeros(length(q), 1);
            a = -obj.fD(q, qd, z);
        end
        function Minv = Minv(obj, q)
            n = length(q);
            Minv = eye(n);
            z = zeros(n, 1);
            ag = obj.Minvh(q, z);
            for i = 1:n
                qdd = obj.fD(q, z, Minv(:,i));
                Minv(:,i) = qdd + ag;
            end
        end
        function tau = iD(obj, q, qd, qdd)
            Minv = obj.Minv(q);
            Minvh = obj.Minvh(q, qd);
            tau = Minv \ (qdd + Minvh);
        end
    end
end
