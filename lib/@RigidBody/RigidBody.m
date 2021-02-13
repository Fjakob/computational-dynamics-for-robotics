classdef RigidBody < handle
    % RigidBody Represents a rigid body.
    %   A rigid body can be connected to other rigid bodies to form a
    %   kinematic tree.
    %
    %   RigidBody Properties:
    %       Name - The name of the rigid body
    %       Parent - The rigid body's parent
    %       Children - The rigid body's children
    %       Vars - A struct to store user-specific variables
    %       I - the body's spatial inertia R^{6x6} in link coordinates
    %       A - the body's screw in R^6 in link coordinates
    %       dAdt - derivative of A in a moving frame
    %       M - the transform in SE(3) from parent to rigid body
    %       Fext0 - An externally applied wrench in R^6 in {s} coordinates
    %       LinkTransform - An EnvironmentObject for holding other graphics
    %       Joint - A graphical representation of the screw axis
    %       Link - A graphical representation of a link
    %       CenterOfMass - A graphical representation of the COM
    %
    %   RigidBody Methods:
    %      RigidBody - The constructor for this class
    %      set - Sets the various properties of the class
    %      T - Computes the transform from parent to rigid body
    %      fromUrdf - A static function for creating rigid bodies from URDF
    %      tree - Draws the kinematic tree in html
    %      clear - Delete the user-defined fields in Vars
    %      var - Returns the value of a user-defined field in Vars
    %      fetch - Returns a struct with fields and values from Vars
    %      store - Stores a new value in Vars
    %      toArray - Converts a linked list into an array
    %      toMap - Converts a linked list into an associative array
    %
    %   See also Frame, ScrewAxis, EnvironmentObject, CenterOfMass
    
    % AUTHORS:
    %   <------------ Add your info! ------------>
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1
    
    
    properties (SetAccess = private)
        Name % name of rigid body
        Parent % parent of rigid body
        Children % children of rigid body
        Vars % volatile storage space with user-defined fields
        
        I % spatial inertia Icom in link coordinates, I = Icom_i in R^{6x6}
        A % screw in link coordinates, A = A_ii in R^6
        dAdt % acceleration in moving frame coordinates, dAdt = dA_ii/dt
        M % transform from parent to rigid body at home position, M = M_ip
        Fext0 % wrench in fixed frame {s} coordinates
        
        LinkTransform % A graphical transform from parent to rigid body
        Joint % A ScrewAxis object
        Link % A Frame object
        CenterOfMass % A CenterOfMass object
    end
    methods
        function obj = RigidBody(name)
            Z = zeros(6);
            M = eye(4);
            I = Z;
            A = Z(:, 1);
            dAdt = Z(:, 1);
            Fext0 = Z(:, 1);
            
            % set graphics
            obj.LinkTransform = EnvironmentObject([]);
            obj.Joint = ScrewAxis(obj.LinkTransform, A);
            obj.Link = Frame(obj.Joint, eye(4));
            obj.CenterOfMass = CenterOfMass(obj.Link, I);
            
            obj.Joint.hide();
            obj.Link.hide();
            obj.CenterOfMass.hide();
            
            % set numeric variables
            obj.clear(); % sets obj.Vars
            obj.Name = name;
            obj.Parent = RigidBody.empty();
            obj.Children = RigidBody.empty();
            obj.set('M', M, 'I', I, 'A', A, 'dAdt', dAdt, 'Fext0', Fext0);
        end
        function set.Parent(obj, parent)
            if ~isempty(obj.Parent)
                % remove obj from children array of old parent
                c = obj.Parent.Children;
                obj.Parent.Children = c(c ~= obj);
            end
            obj.Parent = parent;
            if ~isempty(parent)
                % add obj to children array of new parent
                parent.Children(end + 1) = obj;
            end
        end
        function T_ip = T(obj, q)
            Amat = Math.r6_to_se3(obj.A);
            T_ip = Math.expm6(-Amat * q) * Math.T_inverse(obj.M);
        end
        
        % externally defined functions
        obj = clear(obj)
        values = fetch(obj, varargin)
        obj = set(obj, varargin)
        obj = store(obj, varargin)
        obj = storeDefault(obj)
        [bodies, parent] = toArray(obj, isRoot)
        [map, names] = toMap(obj)
        cmds = tree(obj, parentId)
        value = var(obj, name)
    end
    methods (Static)
        % externally defined functions
        [root, name] = fromUrdf(file)
    end
end