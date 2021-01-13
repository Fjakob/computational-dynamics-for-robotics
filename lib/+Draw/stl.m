function s = stl(root, file, T, color, options)
% DRAWSTL Loads an STL file from file
%   S = STL(ROOT, FILE, T, COLOR, OPTIONS) Returns an hgtransform graphics
%   object S with ROOT as the parent object of an STL file stored in FILE.
%   ROOT can be empty.
%
%   S = STL(__, T) Additionally apply a transform T in SE(3) to the STL
%   FILE.  The matrix is applied to the hgtransform S.
%
%   S = STL(__, COLOR) Additionally set the FaceColor property of the
%   underlying patch object to COLOR.
%
%   S = STL(__, OPTIONS) Additionally pass patch properties in the cell
%   array OPTIONS.
%
%   Example:
%       file = 'ext_lib/mystery_robot/l_finger.stl';
%       options = {'FaceVertexCData', jet(145)};
%       Draw.stl(axes, file, [], 'interp', options); 
%       view(3); 
%       axis equal;
%
%       >> plot of l_finger.stl using jet color map.
%
%   See also HGTRANSFORM, POINT, ARROW, FRAME, SHAPEF, TREE, and WHAT

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1

if nargin < 3 || isempty(T)
    T = eye(4);
end

if nargin < 4 || isempty(color)
    color = rand(1,3);
end

if nargin < 5
   options = {};
end

% LineStyle and FaceNormalsMode chosen based on studying scene
% graph of show(importrobot(...)) settings for patch; incorrect
% LineStyle will significantly slow down rendering
options = [options, ...
    {'Tag', 'STL', 'LineStyle', 'none', 'FaceNormalsMode', 'auto'}];

% create STL container with root as parent
s = hgtransform('Parent', root, 'Matrix', T, 'Tag', 'STL');

stl = stlread(file);
f = stl.ConnectivityList;
v = stl.Points;
fN = stl.faceNormal;
vN = stl.vertexNormal;

patch('Parent', s, 'Faces', f, 'Vertices', v, 'FaceNormals', fN, ...
    'VertexNormals', vN, 'FaceColor', color, options{:});
end