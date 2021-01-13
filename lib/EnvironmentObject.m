classdef EnvironmentObject < handle
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/10/2021, Matlab R2020a, v1
    
    properties
        RootGraphic
    end
    properties (Access = protected)
        % MyGraphics - Graphical representation of EnvironmentObject
        %   A subclass can create an optional special graphics handle with
        %   the 'Tag' property set to 'MyGraphics' (as a character array).
        %   The MyGraphics property will then return any graphic handles in
        %   RootGraphic with the tag name set to 'MyGraphics'.  If no such
        %   tag exists, MyGraphics returns an empty array.
        MyGraphics
    end
    properties (Dependent)
        Name % sets text of all graphics under MyGraphic
        Label % sets text of all graphics under MyGraphic 
        Color % sets color of all graphics under MyGraphic
        LabelColor % sets color of all graphics under MyGraphic
        ShapeColor % sets color of all graphics under MyGraphic
    end
    properties (Dependent, SetAccess = protected)
        T % local transform from RootGraphic's parent to RootGraphic
    end
    properties (Dependent, SetAccess = private)
        T_sb % transform from {s} to RootGraphic
    end
    methods
        %% Constructor
        function obj = EnvironmentObject(parent, myGraphics)
            % b/c matlab.graphics.primitive.Transform is a sealed class, we
            % can't be a subclass; instead we'll act as a wrapper class and
            % add ourselves in UserData to hook back into ourselves.
            parent = obj.getGraphicsHandle(parent);
            obj.RootGraphic = hgtransform('Parent', parent, ...
                'Tag', 'RootGraphic');
            if nargin < 2
                obj.MyGraphics = [];
            else
                obj.MyGraphics = myGraphics;
                obj.MyGraphics.Parent = obj.RootGraphic;
                obj.MyGraphics.Tag = 'MyGraphics';
            end
        end
        %% Property Setter/Getter Methods
        %   The scope (private, protected, public) of these methods is
        %   defined in the related properties block.
        function set.Color(obj, color)
            obj.setShapeColor(color);
            obj.setTextColor(color);
        end
        function set.Name(obj, text)
            obj.setTextString(text);
        end
        function set.T(obj, T)
            % set.T Moves all graphics in RootGraphic
            %   This is a shorthand notation for calling moveGraphic for
            %   library developers.  Users of the library have to call
            %   moveGraphic in order to update the graphics.
            
            obj.moveGraphic(T);
        end
        function T = get.T(obj)
            % get.T Returns RootGraphic relative to parent object
            T = obj.RootGraphic.Matrix;
        end
        function T = get.T_sb(obj)
            % T_sb Computes the body to space transform in SE(3)
            %   T = T_SB(OBJ) Returns the {S} to OBJ.RootGraphics
            %   transform.  The recursion stops once we hit an |axes|
            %   object (the root of our tree; see ENVIRONMENT.).
            
            error('get.T_sb has not been re-implemented yet.');
%            node = base case for node   <--------***** FIX
%               * we want to start from this object's root graphic handle
%            T = base case for T   <--------***** FIX
%            while ~isempty(node) && ~isa(node, 'axes')   <------ UNCOMMENT
%               + we only update T when node.Type is an hgtransform; these
%                 are the only graphics types we assume have a
%                 transformation matrix in their Matrix property.
%               * see the documentation for hgtransform, especially
%                 |Type| in the hgtransform properties documentation
%               * create an hgtransform in the command window to get an
%                 idea of the value and type for node.Type
%                   - h = hgtransform();
%                   - h.Type
%               * what's the type for a surface handle? Try h = surface()
%               * when your ready to write the test, |strcmp| might be
%                 helpful
%                node = ????;   <--------***** FIX
%                   * how do we move up the tree to get to the root?
%                   * stuck?  Try inspecting hgtransform properties
%                     documentation.
%            end                                          <------ UNCOMMENT
        end
        %% Public Methods
        function obj = setShapeColor(obj, color)
            root = {'-property', 'FaceColor'};
            obj.setMyGraphics('FaceColor', color, root);
        end
        
        function obj = setTextColor(obj, color)
            root = {'-property', 'Color'};
            obj.setMyGraphics('Color', color, root);
        end
        
        function obj = setTextString(obj, text)
            root = {'-property', 'String'};
            obj.setMyGraphics('String', text, root);
        end
        
        function h = getMyGraphics(obj, root)
            % in a nutshell, finds a set of handles based on a column cell
            % array worth of findobj commands; a row cell is converted into
            % a column cell before execution.
            if nargin < 2
                h = obj.MyGraphics;
            elseif iscell(root)
                if isrow(root)
                    root = {root};
                end
                h = obj.MyGraphics.Children;
                for i = 1:length(root)
                    h = findobj(h, root{i}{:});
                end
            else
                h = root;
            end
        end
        function obj = setMyGraphics(obj, property, value, root)
            h = obj.getMyGraphics(root);
            h = findobj(h, '-property', property);
            property = cellify(property);
            value = cellify(value);          
            set(h, property, value);
        end        
        function obj = show(obj)
            g = obj.MyGraphics;
            if ~isempty(g)
                g.Visible = 'on';
            end
        end
        function obj = hide(obj)
            g = obj.MyGraphics;
            if ~isempty(g)
                g.Visible = 'off';
            end
        end
        function obj = moveGraphic(obj, T)
            % moveGraphic Applies transformation relative to parent
            %   OBJ = moveGraphic(OBJ, T) Moves the underlying coordinate
            %   vector by displacing it with the transform T_B in SE(3)
            %   defined relative to underlying parent frame B.
            
            obj.RootGraphic.Matrix = T;
        end
        function obj = add(obj, child, T, n, options)
            % add(obj, path/to/stl/file, T, color, options)
            % add(obj, fmt, [T1...Tk], [n1...nk], options)
            % add(obj, H)
            
            if nargin < 3
                T = [];
            end
            if nargin < 4
                n = [];
            end
            if nargin < 5
                options = {};
            end
            
            if isgraphics(child)
                child.set('Parent', obj.RootGraphic);
            elseif isfile(child)
                Draw.stl(obj.RootGraphic, child, T, n, options);
            else
                Draw.shapef(obj.RootGraphic, child, T, n, options);
            end
        end
    end
    methods (Static)
        function handle = getGraphicsHandle(obj)
            if isa(obj, 'EnvironmentObject')
                handle = obj.RootGraphic;
            elseif isa(obj, 'Environment')
                handle = obj.SpaceFrame.RootGraphic;
            elseif isempty(obj) || isgraphics(obj)
                handle = obj;
            else
                error(['obj %s not an Environment, ', ...
                    'EnvironmentObject, or graphics handle'], obj);
            end
        end
    end
end

function c = cellify(c)
if ~iscell(c)
    c = {c};
end
end