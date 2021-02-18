classdef ConstrainedMechanicalSystem < Algorithm
    properties (SetAccess = private)
        PhysicalConstraints
        VirtualContraints
        TransmissionMatrix
    end
    properties (Access = private)
        CompositeRigidBody
    end
    methods
        function obj = ConstrainedMechanicalSystem(robot)
            obj@Algorithm(robot);
            obj.PhysicalConstraints = Constraints.empty();
            obj.VirtualContraints = Constraints.empty();
            obj.TransmissionMatrix = Constraints.empty();
            obj.CompositeRigidBody = CompositeRigidBody(robot);
        end
        function obj = setAp(obj, physical)
            obj.PhysicalConstraints = Constraints(obj.Robot, physical);
        end
        function obj = setAvB(obj, virtual, transmission)
            obj.VirtualContraints = Constraints(obj.Robot, virtual);
            obj.TransmissionMatrix = Constraints(obj.Robot, transmission);
            obj.TransmissionMatrix.ProportionalGainMatrix = 0;
            obj.TransmissionMatrix.DerivativeGainMatrix = 0;
        end
        
        [qdd, data] = fD(obj, q, qd, t)
        tau = iD(obj, q, qd, qdd)
    end
    methods (Access = protected)
        obj = constrain(obj, type, bRT)
    end
end