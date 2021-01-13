function p = point(root)
% POINT Draws a unit sphere and adds the graphic to root
%
%   See also HGTRANSFORM, STL, ARROW, FRAME, SHAPEF, TREE, and WHAT

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/10/2021, Matlab R2020a, v1

% Add children
%   Note: add elements, so p.Children = [Label, P]

% transformation properties for point
ns = 50;
opts = {'FaceColor', 'black'};
s = 0.05;
Ts = Math.Rps_to_T([], [], s);

% transformation properties for label
nL = -1; % default font size
optL = {};
pL = [0; 0; -0.2];
TL = Math.Rp_to_T([], pL);

p = Draw.shapef(root, '.L', [Ts TL], [ns nL], {opts; optL});
p.Tag = 'Point';
end