function a = arrow(root, varargin)
% ARROW Draws a unit arrow along the z-axis of root with an empty label and
% adds the graphic to root
%
%   Example:
%       Draw.arrow(axes); 
%       view(3); 
%       axis equal;
%
%       >> plot of arrow graphic primitives (head and shaft) at the origin
%
%       Draw.arrow(axes, 'ArrowHeadHeight', [], 'P', [1;2;3])
%       view(3);
%       axis equal;
%
%       >> plot of arrow graphic with tail at origin and head at [1;2;3]
%
%   See also HGTRANSFORM, POINT, TREE, FRAME, SHAPEF, TREE, WHAT, and STL

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/09/2021, Matlab R2020a, v1

% parse the inputs; we usually don't do error checking, but do so here to
% explore the inputParser features
parser = inputParser;
parser.addRequired('Root', @(x) isobject(x) || isempty(x));
parser.addParameter('ArrowHeadHeight', NaN, ...
    @(x) isscalar(x) || isempty(x));
parser.addParameter('P', [], @(x) isnumeric(x) && length(x) == 3);
parser.parse(root, varargin{:});

a = parser.Results.Root;
h = parser.Results.ArrowHeadHeight;
p = parser.Results.P;

if isempty(h) || ~isnan(h) || isempty(p)
    a = new(a, h);
end

if ~isempty(p)
   a = update(a, p);
end
end

function a = new(root, headHeight)
% NEW Create a new arrow graphic
%
%   Note:
%      The returned graphic is not an arrow as expected, but the different
%      components of the arrow at their respective origins.  The update
%      function assembles the components into a proper arrow with
%      appropriate scaling and placement with respect to the parent frame.

if isempty(headHeight) || isnan(headHeight)
    headHeight = 0.1;
end

a = hgtransform('Parent', root, 'Tag', 'Arrow');

% Add children
%   Note: add children so that order is [label, arrow head, arrow shaft].
%   To get this ordering, add children in reverse order.

% create components for an arrow and label in base graphic coordinates.
n = 4; % # of faces to draw

% compensate for shapef making cylinder and cone heights from [-0.5, 0.5]
p = [0; 0; 0.5]; % place bottom of graphic at origin
Tp = Math.Rp_to_T([], p);

% transformation properties for shaft of arrow; the parent-child
% relationship will be
%   Arrow <- ArrowShaft <- Fixed Transform T * Tp <- Patch Handle
shaftScale = 0.02;
s = [shaftScale; shaftScale; 1];
T = Math.Rps_to_T([], [], s);
g = Draw.shapef(a, '-', T * Tp, n);
g.Tag = 'Shaft';

% transformation properties for head of arrow; the parent-child
% relationship will be
%   Arrow <- ArrowHead <- Fixed Transform T * Tp <- Patch Handle
headScale = 0.4;
s = headHeight * [headScale; headScale; 1];
T = Math.Rps_to_T([], [], s);
g = Draw.shapef(a, '>', T * Tp, n);
g.Tag = 'Head';

% transformation properties for label; the parent-child
% relationship will be
%   Arrow <- ArrowLabel <- Fixed Transform T <- Text Handle
p = [0; 0; headHeight + 0.075];
T = Math.Rp_to_T([], p);
g = Draw.shapef(a, 'L', T);
g.Tag = 'Label';
end

function arrow = update(arrow, p)
% UPDATE Updates arrow graphic
%
%   Note:
%       Usually we don't need a complicated function to update the
%       graphics, but we want to keep a fixed relative position of the
%       arrow head with respect to the arrow shaft, so we need to be
%       careful with how we scale the underlying unit arrow.

% get relevant values to update the graphic
label = arrow.Children(1);
head = arrow.Children(2);
shaft = arrow.Children(3);
headHeight = head.Children.Matrix(3, 3);

zAxis = [0; 0; 1]; % base arrow's initial direction
n = norm(p);

% scale the unit arrow's shaft to the correct size in the unit
% arrow's frame (i.e., along z-axis)
s = [1; 1; n - headHeight]; % shaft scaling
Tscale = Math.Rps_to_T([], [], s);
shaft.Matrix = Tscale;

% position the label and arrow head in the scaled arrow's frame
% (i.e., along z-axis)
t = [0; 0; n - headHeight]; % label and head translation
Ttrans = Math.Rp_to_T([], t);
label.Matrix = Ttrans;
head.Matrix = Ttrans;

% transform scaled arrow along z-axis to point in the direction of p with
% the tip of scaled vector's head at the origin of its coordinate system
% (in the parent's frame, the end of the tip is located at point p)
R = Math.R_a_to_b(zAxis, p);
T = Math.Rp_to_T(R, []);
arrow.Matrix = T;
end