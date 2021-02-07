classdef RecursiveNewtonEulerRecursion < InverseDynamics
    % RecursiveNewtonEulerRecursion Computes the dynamics of a RigidBody
    % tree.
    %   The RecursiveNewtonEulerRecursion computes the dynamics of a robot
    %   of the form
    %       M(q) qdd + h(q, qd) = tau.
    %   In particular, the algorithm provides efficient computations for
    %   h(q, qd) and is capable of computing M(q), but, in general, not as
    %   efficiently as the CompositeRigidBody.  The class inherits from
    %   InverseDynamics.
    %
    %   RecursiveNewtonEulerRecursion Properties:
    %       Mapping - A mapping between robot names
    %
    %   RecursiveNewtonEulerRecursion Methods:
    %      iD - An implementation of the recursive Newton-Euler algorithm
    %      using a linked list of RigidBody objects.
    %
    %   See also RigidBody, Algorithm, InverseDynamics,
    %   RecursiveNewtonEuler, and CompositeRigidBody
    
    properties
        % Mapping - A mapping from indices of inputs to RigidBody names
        %   The inputs (e.g., q, qd, qdd) to the methods of this class
        %   (e.g., iD) are linear arrays that need to be converted to
        %   containers.Map objects where the keys are the names of the
        %   RigidBody objects and the values are taken from the linear
        %   arrays. The mapping from linear integer indices i to keys of k
        %   of containers.Map is defined by Mapping, where obj.Mapping{i} =
        %   k. The mapping can be arbitrary and does not need to satisfy
        %   any special properties.
        %
        %   Example:
        %       q = [1; 2; 3];
        %       qmap = containers.Map();
        %       qmap('link 1') = q(1);
        %       qmap('link 2') = q(2);
        %       qmap('link 3') = q(3);
        %       mapping = {'link 1', 'link 2', 'link 3'};
        %       alg = RecursiveNewtonEulerRecursion(robot, mapping);
        %       alg.Mapping
        Mapping
    end
    methods
        function obj = RecursiveNewtonEulerRecursion(robot, map)
            % RecursiveNewtonEulerRecursion The constructor.
            %   OBJ = RecursiveNewtonEulerRecursion(ROBOT) Returns OBJ
            %   an instance of RecursiveNewtonEulerRecursion that operates
            %   on the RigidBody tree rooted at ROBOT.  A mapping
            %   obj.Mapping must be defined before calling the object's
            %   methods.
            %
            %   OBJ = RecursiveNewtonEulerRecursion(ROBOT, MAP) Same as
            %   above, but uses a user-defined MAP as the mapping between
            %   input indices and RigidBody names for obj.Mapping.
            %
            %   OBJ = RecursiveNewtonEulerRecursion(ROBOT, 'Robot') Same as
            %   above, but uses the names from ROBOT.toMap() to initialize
            %   obj.Mapping.
            
            obj@InverseDynamics(robot);
            if nargin > 1 && iscell(map)
                obj.Mapping = map;
            elseif nargin > 1 && ischar(map) && strcmpi(map, 'Robot')
                [~, obj.Mapping] = robot.toMap();
            else
                obj.Mapping = {};
            end
        end
        % externally defined functions
        tau = iD(obj, q, qd, qdd)
    end
    methods (Access = protected)
        function obj = setRobot(obj, robot)
            setRobot@InverseDynamics(obj, robot);
            obj.Mapping = {};
        end
    end
end