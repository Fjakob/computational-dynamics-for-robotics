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
            obj.CenterOfMassFrame = Frame(myGraphics, eye(4));
            obj.CenterOfMassFrame.RootGraphic.Tag = 'COM Frame';
            obj.CenterOfMassFrame.Name = 'com';
            
            % add principal axes {p}
            obj.PrincipalAxes = Frame(myGraphics, eye(4));
            obj.PrincipalAxes.RootGraphic.Tag = 'Principal Axes';
            obj.PrincipalAxes.Name = 'p';
            
            % add ellipsoid
            obj.InertiaEllipsoid = Draw.what(myGraphics, '.', eye(4));
            obj.InertiaEllipsoid.Tag = 'Inertia Ellipsoid';
            
            % make principal axes and ellipsoid transparent
            obj.setMyGraphics('FaceAlpha', 0.1, {'Tag', ...
                'Principal Axes', '-or', 'Tag', 'Inertia Ellipsoid'});
            
            % set spatial inertia to update graphics
            obj.SpatialInertia = I;
            
            % show only center of mass
            obj.hide('e', 'p', 'f');
            obj.show('c');
        end
        function set.SpatialInertia(obj, I)
            obj.SpatialInertia = I;
            obj.updateGraphics();
        end
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
                actions = struct( ...
                    'c', @() obj.PrincipalAxes.hideOrigin(), ...
                    'e', @() set(obj.InertiaEllipsoid, 'Visible', 0), ...
                    'p', @() obj.PrincipalAxes.hideAxes(), ...
                    'f', @() obj.CenterOfMassFrame.hide() ...
                    );
                apply(varargin, actions);
            end
        end
    end
    methods (Access = private)
        function obj = updateGraphics(obj)
            I = obj.SpatialInertia;
            if norm(I) > 0
                % get Icom in {parent} and transform T = T_{parent,com}
                [~, Icom, T] = Math.spatial_inertia_to_mIcom(I);
                
                % calc principal axes and ellipsoid
                [R_bp, Icom] = Math.eig(Icom); % get {p} w.r.t {com}
                scale = diag(Icom);
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