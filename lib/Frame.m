classdef Frame < EnvironmentObject
    % Frame Documentation pending
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v22
    %   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21
    
    properties
        T = eye(4) % transformation matrix in SE(3)
    end
    properties (Dependent)
        Name
    end
    properties (Dependent, Access = private)
        Label
        X
        Y
        Z
    end
    methods
        %% Constructor
        function obj = Frame(parent, T)
            % init graphics
            obj@EnvironmentObject(parent);
            obj.hide();
            Utils.drawFrame(obj);
            % setup properties
            obj.T = T;
            % show graphics
            obj.show();
        end
        %% Property Setter/Getter Methods
        %   The scope (private, protected, public) of these methods is
        %   defined in the related properties block.        
        function set.T(obj, T)
            obj.T = T;
            obj.moveGraphic(T);
        end
        function set.Name(obj, name)
            obj.X.Name = ['$\hat{x}_{', name, '}$'];
            obj.Y.Name = ['$\hat{y}_{', name, '}$'];
            obj.Z.Name = ['$\hat{z}_{', name, '}$'];
            txt = obj.Label.RootGraphic.Children;
            set(txt, 'String',  ['\{', name, '\}']);
        end
        function name = get.Name(obj)
            txt = obj.Label.RootGraphic.Children;
            name = get(txt, 'String');
            name = name(3:end-2);
        end
        function txt = get.Label(obj)
            txt = obj.getMyGraphicsChild(1);
        end
        function x = get.X(obj)
            x = obj.getMyGraphicsChild(3);
        end
        function y = get.Y(obj)
            y = obj.getMyGraphicsChild(4);
        end
        function z = get.Z(obj)
            z = obj.getMyGraphicsChild(5);
        end        
        %% Public Methods
        function obj = showAxes(obj)
            obj.X.show();
            obj.Y.show();
            obj.Z.show();
        end
        function obj = hideAxes(obj)
            obj.X.hide();
            obj.Y.hide();
            obj.Z.hide();
        end
    end
end