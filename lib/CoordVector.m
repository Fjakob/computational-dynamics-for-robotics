% COORDVECTOR Documentation pending.
classdef CoordVector < handle
    % Public Properties
    properties
        name  = '';
        color = [0;0;0];
    end
    % Constant Properties
    properties (Constant, GetAccess = private)
        % vertices in the environment frame
        VERT_INFO = createGraphicsData(false);
        DEFAULT_COLOR = [0 0 0];
        DEFAULT_TXT_POS = [0; 0; 1.075];
        DEFAULT_VECTOR = [0; 0; 1];
        DEFAULT_FONT_SIZE = 12;
    end
    % Private Properties
    properties (SetAccess = private, GetAccess = private)
        v_s;  % Vector coordinates in the environment frame
        patchHandle;
        env;
        labelText;
    end
    % Public Methods
    methods
        % Constructor creates the graphical objects that represent a vector
        function obj = CoordVector(env, T_sb, v_b)
            % Store the graphical environment
            obj.env = env;
            % Create a patch object that contains the graphics.
            figure(obj.env.fig);
            graphics = createGraphicsData();
            obj.patchHandle = patch(graphics);
            
            % Add name label
            obj.labelText = text();
            
            % Store the vector in inertial (env) coordinates
            R = Utils.parseTransformInput(T_sb);
            obj.v_s = R * v_b;
            
            updateGraphics(obj);
        end
        % Destructor removes graphics upon deletion
        function delete(obj)
            delete(obj.patchHandle);
            delete(obj.labelText);
        end
        function show(obj)
            obj.labelText.Visible = 'on';
            obj.patchHandle.Visible = 'on';
        end
        function hide(obj)
            obj.labelText.Visible = 'off';
            obj.patchHandle.Visible = 'off';
        end
        % Update the coordinates of this vector in the provided cosys
        function setCoords(obj, T_sb, v_b)
            R = Utils.parseTransformInput(T_sb);
            obj.v_s = R * v_b;
            updateGraphics(obj);
        end
        % Get the coordinates of this vector in the provided cosys
        function v_b = getCoords(obj, T_sb)
            R = Utils.parseTransformInput(T_sb);
            v_b = R' * obj.v_s;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%% SET FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Set functions are called whenever a public parameter is changed.
        % All of them call the 'updateGraphics' function afterwards, to
        % make sure that the graphical output is updated accordingly:
        function set.color(obj, color)
            obj.color = color;
            updateGraphics(obj);
        end
        function set.name(obj, name)
            obj.name = name;
            updateGraphics(obj);
        end
    end
    % Private Methods
    methods (Access = private)
        % Update the graphic objects, if a value has changed
        function updateGraphics(obj)
            %% extract the frame's configuration
            vinfo = CoordVector.VERT_INFO;
            verts = vinfo.vertices;
            scale = vinfo.scale;
            iHead = vinfo.head;
            iShaft = vinfo.shaft;
            
            v = obj.v_s;
            n = norm(v);
            s = [1; 1; (n - scale) / (1 - scale)]; % scale
            R = Rot.froma2b(CoordVector.DEFAULT_VECTOR, v);
            pShaft = zeros(3,1);
            pHead = R * [0; 0; n - norm(CoordVector.DEFAULT_VECTOR)];
            
            verts(iHead, :) = ...
                Utils.applyTransform([R pHead], verts(iHead, :));
            
            verts(iShaft, :) = ...
                Utils.applyTransform([R pShaft s], verts(iShaft, :));
            
            %% update vector graphic
            set(obj.patchHandle, 'Vertices', verts);
            set(obj.patchHandle, 'FaceColor', obj.color(:)');
            
            %% set axes labels
            % position labels in the space frame {s}
            p = Utils.applyTransform([R pHead], ...
                CoordVector.DEFAULT_TXT_POS')';
            
            set(obj.labelText, ...
                'position', p, ...
                'Color', obj.color, ...
                'String', obj.name, ...
                'FontSize', CoordVector.DEFAULT_FONT_SIZE);
        end
    end
end

function patchStruct = createGraphicsData(isPatch)
% draw an arrow coincident with {s} along \hat{z} axis
%
%   input: (none)
%   output: frame a patch struct
%   example: handle = patch(createFrame());

if nargin == 0
    isPatch = true;
end

N = 4; % number of vertices to draw on circle slice
scale = 0.1; % scale arrow so norm(head + shaft) = 1

% properties for head of arrow
rHead = [0.4, 0]; % draws a cone
sHead = scale * ones(3, 1);
pHead = [0; 0; (1 - scale)];

% properties for shaft of arrow
rShaft = 0.02; % draws a cylinder
scaleShaft = [1; 1; (1 - scale)];

% head data
[hx, hy, hz] = cylinder(rHead, N);
head = surf2patch(hx, hy, hz);
T = [pHead sHead]; % scale + translate
head.vertices = Utils.applyTransform(T, head.vertices);

[sx, sy, sz] = cylinder(rShaft, N);
shaft = surf2patch(sx, sy, sz);
T = [zeros(3,1) scaleShaft]; % scale shaft
shaft.vertices = Utils.applyTransform(T, shaft.vertices);

nv = length(head.vertices);
patchStruct.vertices= [head.vertices; shaft.vertices];

if isPatch % create a patch conforming struct
    patchStruct.faces = [head.faces; shaft.faces + nv];
    patchStruct.FaceVertexCData = CoordVector.DEFAULT_COLOR;
    patchStruct.FaceColor = 'flat';
else % caller interested in individual graphics
    patchStruct.head = 1:nv;
    patchStruct.shaft = (nv + 1):length(patchStruct.vertices);
    patchStruct.scale = scale;
end
end