classdef EnvironmentObject < handle

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1
    
    properties
        RootGraphic
    end
    properties (Dependent)
        Color % Color of all graphics under RootGraphic
        Parent % Parent as an EnvironmentObject
    end
    properties (Dependent, SetAccess = private)
        % MyGraphics - Graphical representation of EnvironmentObject
        %   A subclass can create an optional special graphics handle with
        %   the 'Tag' property set to 'MyGraphics' (as a character array).
        %   The MyGraphics property will then return any graphic handles in
        %   RootGraphic with the tag name set to 'MyGraphics'.  If no such
        %   tag exists, MyGraphics returns an empty array.
        MyGraphics
    end
    methods
        %% Constructor
        function obj = EnvironmentObject(parent)
            % b/c matlab.graphics.primitive.Transform is a sealed class, we
            % can't be a subclass; instead we'll act as a wrapper class and
            % add ourselves in UserData to hook back into ourselves.
            parent = parentRootGraphic(parent);
            obj.RootGraphic = hgtransform('Parent', parent);
            obj.RootGraphic.UserData = struct('envObject', obj);
        end
        %% Property Setter/Getter Methods
        %   The scope (private, protected, public) of these methods is
        %   defined in the related properties block.        
        function set.Color(obj, color)
            h = findobj(obj.RootGraphic, '-property', 'Color', ...
                '-or', '-property', 'FaceColor');
            set(findobj(h, '-property', 'Color'), 'Color', color);
            set(findobj(h, '-property', 'FaceColor'), 'FaceColor', color);
        end        
        function set.Parent(obj, parent)
            obj.set('Parent', parentRootGraphic(parent));
        end
        function parent = get.Parent(obj)
            parent = obj.get('Parent').UserData.envObject;
        end
        function h = get.MyGraphics(obj)
            h = findobj(obj.RootGraphic.Children, 'flat', ...
                'Tag', 'MyGraphics');
        end        
        %% Public Methods
        function obj = set(obj, varargin)
            % set Sets properties of hgtransform graphics handle
            %   The set function acts as a wrapper for the hgtransform
            %   properties, more specifically of the class
            %   matlab.graphics.primitive.Transform.

            set(obj.RootGraphic, varargin{:});
        end        
        function h = get(obj, varargin)
            % get Gets properties of hgtransform graphics handle
            %   The get function acts as a wrapper for the hgtransform
            %   properties, more specifically of the class
            %   matlab.graphics.primitive.Transform.
            
            h = get(obj.RootGraphic, varargin{:});
        end
        function eo = getMyGraphicsChild(obj, i)
            % get.Label Gets the arrow's label as an EnvironmentObject
            hgt = obj.MyGraphics.Children(i);
            eo = hgt.UserData.envObject;
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
        function obj = add(obj, X, Y, Z, T)
            % add(obj, str, [T1...Tk], [n1...nk])
            % add(obj, str, [T1...Tk], [n1...nk], T)
            % add(obj, H)
            % add(obj, H, [], [], T)
            % add(obj, EO)
            % add(obj, EO, [], [], T)
            % add(obj, X, Y, Z)
            % add(obj, X, Y, Z, T)
            
            if nargin < 3
                Y = [];
            end
            if nargin < 4
                Z = [];
            end
            if nargin < 5
                T = eye(4);
            end
            
            if ischar(X)
                % Utils.draw(obj, X, Y, Z).moveGraphic(T);
                obj = Utils.draw(obj, X, Y, Z);
                obj.moveGraphic(T);
            elseif isa(X, 'EnvironmentObject')
                % base case 1: stop after EO
                X.set('Parent', obj.RootGraphic).moveGraphic(T);
            elseif isnumeric(X)
                obj.add( ...
                    surface(X, Y, Z, 'Tag', get(obj, 'Tag')), [], [], T);
            else
                % base case 2: stop after graphics handle
                tag = get(X, 'Tag');
                set(X, 'Parent', EnvironmentObject(obj) ...
                    .moveGraphic(T).set('Tag', tag).RootGraphic);
            end
        end
        function obj = moveGraphic(obj, T)
            % moveGraphic Applies transformation relative to parent
            
            obj.set('Matrix', T);
        end
        function T_sb = getT_sb(obj)
            % getT_sb Returns the body to space transform in SE(3)
            
            T_pb = obj.get('Matrix');
            T_sb = T_pb;
            % this is generally incorrect, we'll fix this method in a
            % future exercise problem; it only works in cases where the
            % parent frame is coincident with {s}.
        end           
    end
end

function parent = parentRootGraphic(parent)
if isa(parent, 'EnvironmentObject')
    parent = parent.RootGraphic;
elseif isa(parent, 'Environment')
    parent = parent.SpaceFrame.RootGraphic;
end
end