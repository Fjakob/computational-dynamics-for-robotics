function f = frame(root)
% FRAME Draws a frame with axes label and adds the graphic to root
%
%   See also HGTRANSFORM, STL, ARROW, POINT, SHAPEF, TREE, and WHAT

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/09/2021, Matlab R2020a, v1

% create frame container for graphics with root as parent
f = hgtransform('Parent', root, 'Tag', 'Frame');

% Add children
%   Note: add elements, so f.Children = [Label, Origin, X, Y, Z]

a = 'XYZ';
I = eye(3);
for i = 3:-1:1
    g = Draw.arrow(f, 'ArrowHeadHeight', [], 'P', I(:, i));
    g.Tag = [a(i), '-Axis'];
end

g = Draw.point(f);
g.Tag = 'Origin';
end