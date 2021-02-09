classdef CenterOfMass < EnvironmentObject
    % CenterOfMass Represents an inertia ellipsoid
    %   When added to a rigid body and given a spatial inertia, this class
    %   draws an inertia ellipsoid representing the mass distribution along
    %   the principal axes of the inertia matrix.
    %
    %   CenterOfMass Properties:
    %       SpatialInertia - The spatial inertia of the rigid body
    %
    %   Environment Methods:
    %      CenterOfMass - The constructor for this class
    %      show - shows the frames, center of mass, and ellipsoid
    %      hide - hides the frames, center of mass, and ellipsoid
    %
    %   See also EnvironmentObject and Math/eig
    
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/24/2021, Matlab R2020a, v1
    
    properties
        SpatialInertia % The spatial inertia of the rigid body
    end
    properties (Access = private)
        CenterOfMassFrame % A Frame object for visualizing the COM frame
        PrincipalAxes % A Frame object for visualizing the principal axes
        InertiaEllipsoid % A transformed sphere object
    end
    methods
        function obj = CenterOfMass(parent, I)
            % create an empty graphics container
            myGraphics = hgtransform('Parent', []);
            obj@EnvironmentObject(parent, myGraphics);
            
            obj.hide();
            
            % add center-of-mass frame {com}
            obj.CenterOfMassFrame = a Frame;
            %   * the frame's parent is myGraphics
            %   * the two frames are coincident
            obj.CenterOfMassFrame.RootGraphic.Tag = 'COM Frame';
            obj.CenterOfMassFrame.Name = 'com';
            
            % add principal axes {p}
            obj.PrincipalAxes = another frame;
            %   * the frame's parent is myGraphics
            %   * the two frames are coincident
            %   + tag its RootGraphic as a 'Principal Axes'
            %   + name the frame {p}
            
            % add ellipsoid
            obj.InertiaEllipsoid = Draw.what(???, a sphere, eye(4));
            %   * the parent is myGraphics
            %   + tag it as an 'Inertia Ellipsoid'
            %   * obj.InertiaEllipsoid is already a graphics handle
            
            % make principal axes and ellipsoid transparent
            obj.setMyGraphics('FaceAlpha', 0.1, {'Tag', ...
                'Principal Axes', '-or', 'Tag', 'Inertia Ellipsoid'});
            
            % set spatial inertia to update graphics
            obj.SpatialInertia = I;
            
            % show only center of mass
            obj.hide('e', 'p', 'f');
            obj.show('c');
        end
            YOUR TODO LIST:
%                * Write a setter function for SpatialInertia that sets 
%                  SpatialInertia and updates the graphics for this class.
%                * The class already has a private method for updating
%                  graphics.
        function obj = show(obj, varargin)
            % show Shows the various graphics.
            %   OBJ = show(OBJ, VARARGIN) Makes graphical objects visible
            %   based on the corresponding code values:
            %       * 'c' - displays the origin of the principal axes
            %       * 'e' - displays the inertia ellipsoid
            %       * 'p' - displays the principal axes
            %       * 'f' - displays the center-of-mass frame
            %       * 'com' - same as 'c'
            %       * 'ellipse' - same as 'e'
            %       * 'principal' - same as 'p'
            %       * 'frame' - same as 'f'            
            %
            %   See also hide
            
            actions = struct( ...
                'c', @() obj.PrincipalAxes.showOrigin(), ...
                'e', @() set(obj.InertiaEllipsoid, 'Visible', 'on'), ...
                'p', @() obj.PrincipalAxes.showAxes(), ...
                'f', @() obj.CenterOfMassFrame.show() ...
                );
            apply(varargin, actions);
            show@EnvironmentObject(obj);
        end
        function obj = hide(obj, varargin)
            % hide Hides the various graphics.
            %   OBJ = hide(OBJ, VARARGIN) Makes graphical objects invisible
            %   based on the corresponding code values:
            %       * 'c' - hide the origin of the principal axes
            %       * 'e' - hide the inertia ellipsoid
            %       * 'p' - hide the principal axes
            %       * 'f' - hide the center-of-mass frame
            %       * 'com' - same as 'c'
            %       * 'ellipse' - same as 'e'
            %       * 'principal' - same as 'p'
            %       * 'frame' - same as 'f'
            %
            %   See also show
            
            n = length(varargin);
            if n == 0
                % hide all graphics
                hide@EnvironmentObject(obj);
            else
                % hide individual graphics
            YOUR TODO LIST:
%                + Write this segment of hide based on your knowledge of 
%                  the hiding the individual graphical objects.  Use the 
%                  |show| method as a guide.
            end
        end
    end
    methods (Access = private)
        function obj = updateGraphics(obj)
            I = obj.SpatialInertia;
            if norm(I) > 0
                % get Icom in {parent} and transform T = T_{parent,com}
                (Icom, T) = ???
%                   * you need to get these components from I                
                
                % calc principal axes and ellipsoid
                (R_bp, Icom) = some function of Icom
%                   * how do we get the principal axes and moments from 
%                     Icom?  Don't call the Matlab builtin, use the version
%                     in the CDR Math library                
%                   * you should overwrite the values of the previous Icom
%                     with the values of the principal moments of inertia
                scale = ???
%                   * We want to scale obj.InertiaEllipsoid with respect to
%                     the principal moments of inertia.  Why?
            else
                % zero inertia, hide graphic
                scale = eps * [1; 1; 1];
                T = Math.Rps_to_T([], [], scale);
                R_bp = eye(3);
            end
            
            scale(scale == 0) = eps; % hgtransforms can't do zero scaling
            T_bp = Math.Rps_to_T(R_bp, [], scale);
            
            % move principal axes (and scale them by their moments)
            obj.PrincipalAxes.moveGraphic(T_bp);
            
            % move ellipsoid
            obj.InertiaEllipsoid.Matrix = T_bp;
            
            % move root graphic to center of mass position
            obj.moveGraphic(T);
        end
    end
end

function apply(cmds, actions)
% APPLY Applies a set of actions to a set of commands.
for i = 1:length(cmds)
    switch cmds{i}
        case {'c', 'com'}
            actions.c();
        case {'e', 'ellipse'}
            actions.e();
        case {'p', 'principal'}
            actions.p();
        case {'f', 'frame'}
            actions.f();
    end
end
end