% Frame Documentation pending
classdef Frame < handle
    % Public Properties
    properties
        R = eye(3); % rotation matrix
        p = zeros(3,1); % position vector
        name = ''; % frame's name
        color = [0;0;0]; % frame's color
    end
    % Constant Properties
    properties (Constant)
        AX_X = [1; 0; 0];
        AX_Y = [0; 1; 0];
        AX_Z = [0; 0; 1];
    end
    properties (Constant, GetAccess = private)
        VERT_INFO = createGraphicsData(false);
        DEFAULT_COLOR = [0 0 0];
    end
    properties (Constant, GetAccess = private)
        % define the position of labels relative to this frame's
        % coordinates
        POS_XLABEL_IN_B_FRAME = [1.15; 0; 0];
        POS_YLABEL_IN_B_FRAME = [0; 1.15; 0];
        POS_ZLABEL_IN_B_FRAME = [0; 0; 1.15];
    end
    % Dependent Properties
    properties (Dependent)
        T; % transformation matrix in SE(3)
    end
    % Private Properties
    properties (SetAccess = private, GetAccess = private)
        env;
        patchHandle;
        X;
        Y;
        Z;
    end
    % Public Methods
    methods
        % Constructor creates the graphical objects that represent a cosys
        function obj = Frame(env, T_sb)
            % Store the graphical environment
            obj.env = env;
            
            % define axes before obj.R (and friends) to avoid issues when
            % we set obj.R which calls set.R which calls updateGraphics
            % before axes are ready.
            for i = 'x':'z'
                I = upper(i);
                obj.(I) = CoordVector(env, T_sb, Frame.(['AX_', I]));
                obj.(I).name = ['$\hat{', i, '}$'];
                % see 'matlab/matlab_oop/method-invocation.html#bup5s2j'
            end
            
            % Create a patch object that contains the graphics.
            figure(obj.env.fig);
            graphics = createGraphicsData();
            obj.patchHandle = patch(graphics);
            
            % Store the cosys trafo w.r.t to inertial (env) coordinates
            obj.R = Utils.parseTransformInput(T_sb);
            
            % redundant as obj.R and friends call it in their set methods
            % updateGraphics(obj);
        end
        % Destructor removes graphics upon deletion
        function delete(obj)
            delete(obj.X);
            delete(obj.Y);
            delete(obj.Z);
            delete(obj.patchHandle);
        end
        function show(obj)
            obj.X.show();
            obj.Y.show();
            obj.Z.show();
            obj.patchHandle.Visible = 'on';
        end
        function hide(obj)
            obj.X.hide();
            obj.Y.hide();
            obj.Z.hide();
            obj.patchHandle.Visible = 'off';
        end
        %%%%%%%%%%%%%%%%%%%%%%%%% SET FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Set functions are called whenever a public parameter is changed.
        % All of them call the 'updateGraphics' function afterwards, to
        % make sure that the graphical output is updated accordingly:
        
        %% Methods for setting/getting the frame's configuration
        %   * set functions: called whenever a public parameter changes.
        % Get functions are called whenever a public parameter is
        % referenced.
        %
        % Because set functions change the internal state of a frame
        % All of them call the 'updateGraphics' function afterwards, to
        % make sure that the graphical output is updated accordingly
        
        %% Here are examples for writing your own set/get functions
        function set.R(obj, R)
            % set.R sets the frame's orientation to R
            %   input: R a rotation matrix in SO(3)
            %   see also set.T.
            obj.R = R;
            updateGraphics(obj);
        end
        
        %% -------- INSERT CODE --------
        % Write set.p and document it.
        %
        % set.p
        %   input: p a (column) vector in R^3
        %   output: (none)
        %
        % sets the frame's position to p and updates the figure.
        %   ------- start code snippet -------
        %       WRITE YOUR CODE HERE
        %   ------- end code snippet -------
        
        % Write set.T and document it
        %
        % set.T
        %   input: T a 4x4 matrix in SE(3)
        %   output: (none)
        %
        % sets the frame's configuration to T and updates the figure.
        %   ------- start code snippet -------
        %       WRITE YOUR CODE HERE
        %   ------- end code snippet -------
        
        % Write get.T and document it
        %
        % get.T
        %   input: (none)
        %   output: T the frame's configuration in SE(3)
        %
        % gets the frame's config. as a transformation matrix in SE(3).
        %   ------- start code snippet -------
        %       function T = get.T(obj)
        %           what does T equal in terms of (R, p)?
        %       end
        %   ------- end code snippet -------
        
        %%
        function set.name(obj, name)
            obj.name = name;
            updateGraphics(obj);
        end
        function set.color(obj, color)
            obj.color = color;
            updateGraphics(obj);
        end
    end
    % Private Methods
    methods (Access = private)
        % Update the graphic objects, if a value has changed
        function updateGraphics(obj)
            % extract the frame's configuration
            vinfo = Frame.VERT_INFO;
            verts = Utils.applyTransform(obj.p, vinfo.vertices);
            
            % update coordinate axes graphic
            set(obj.patchHandle,'Vertices', verts);
            set(obj.patchHandle,'FaceColor', obj.color');
            
            for i = 'x':'z'
                I = upper(i);
                obj.(I).setCoords(obj, Frame.(['AX_', I]));
                obj.(I).name = ['$\hat{', i, '}_{', obj.name, '}$'];
                obj.(I).color = obj.color;
            end
        end
    end
end

function origin = createGraphicsData(isPatch)
% draw a frame coincident with {s}
%
%   input: (none)
%   output: frame a patch struct
%   example: handle = patch(createGraphicsData());

if nargin == 0
    isPatch = true;
end
scaleOrigin = 0.05;
[sx, sy, sz] = sphere;
origin = surf2patch(sx, sy, sz);
origin.vertices = scaleOrigin * origin.vertices;

if isPatch % create a patch conforming struct
    origin.FaceVertexCData = Frame.DEFAULT_COLOR;
    origin.FaceColor = 'flat';
end
end