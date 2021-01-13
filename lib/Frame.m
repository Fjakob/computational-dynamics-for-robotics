classdef Frame < EnvironmentObject
    % Frame Documentation pending
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/10/2021, Matlab R2020a, v23
    %   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21
    
    methods
        %% Constructor
        function obj = Frame(parent, T)
            % init graphics
            myGraphics = hgtransform('Parent', []);
            obj@EnvironmentObject(parent, myGraphics);
            obj.hide();
            obj.RootGraphic.Tag = 'Frame';
            
            % add elements so myGraphic.Children = [Origin, X, Y, Z]
            color = {'red', 'green', 'blue'};
            label = {'$\hat{x}$', '$\hat{y}$', '$\hat{z}$'};
            I = eye(3);
            for i = 3:-1:1
                % create temporary CoordVectors to help set up axes
                c = CoordVector([], I(:, i));
                c.MyGraphics.Parent = myGraphics;
                c.MyGraphics.Tag = [upper(label{i}(7)), '-Axis'];
                c.Name = label{i};
                c.Color = color{i};
            end
            c = Draw.point(myGraphics);
            c.Tag = 'Origin';
            
            % update graphics
            obj.moveGraphic(T);
            % show graphics
            obj.show();
        end
        %% Public Methods        
        function obj = setTextString(obj, name)
            n = name;
            if length(n) > 1 && n(1) == '$' && n(end) == '$'
                n = n(2:end-1);
            end
            x = ['$\hat{x}_{', n, '}$'];
            y = ['$\hat{y}_{', n, '}$'];
            z = ['$\hat{z}_{', n, '}$'];
            o = ['\{', name, '\}'];
            setTextString@EnvironmentObject(obj, {o; x; y; z});
        end
        %% Public Methods
        function obj = showAxes(obj)
            for i = 2:4
                obj.MyGraphics.Children(i).Visible = 'on';
            end
        end
        function obj = hideAxes(obj)
            for i = 2:4
                obj.MyGraphics.Children(i).Visible = 'off';
            end
        end    
    end
end