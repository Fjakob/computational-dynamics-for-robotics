function shapes = shapef(root, fmt, T, n, options)
% SHAPEF Draws a shape primitive using a format string
%   SHAPES = SHAPEF(ROOT, FMT) Creates an hgtransform SHAPES with ROOT
%   as the parent graphic handle and children graphics handles based on the
%   format string FMT.  The resulting graphics heirarchy is
%       ROOT <- SHAPES <- child(i) based on fmt(i), 
%   where ROOT can be a
%       * a graphics handle
%       * an empty matrix [] (an empty matrix => no parent)
%   and FMT, a character array, can consist of the following valid
%   characters:
%       .   Draws a unit sphere centered at the origin
%       #   Draws a unit cube centered at the origin
%       -   Draws a unit cylinder centered at the origin
%       >   Draws a unit cone centered at the origin pointing up +'ve z
%       <   Draws a unit cone centered at the origin pointing down -'ve z
%       L   Creates an empty text label located at the origin
%   All other characters are ignored.
%
%   ROOT = SHAPEF(___, T) Applies a local transform T in SE(3) to each
%   character in FMT.  T can also be an empty value (e.g., T = []), which
%   defaults to the identity element.
%
%   ROOT = SHAPEF(___, [T1 ... Tk]) Applies a local transform Ti in SE(3)
%   to the I^th character in FMT (1 <= i <= k, strlength(FMT) = k).
%
%   ROOT = SHAPEF(___, N) Creates each shape with N vertices.  N can be
%   negative (e.g., N = -1), in which case a default value is used.  For
%   format option 'L', N is a font size.
%
%   ROOT = SHAPEF(___, [N1 ... Nk]) Creates shape FMT(i) with Ni vertices
%   (1 <= i <= k, strlength(FMT) = k).
%
%   ROOT = SHAPEF(___, OPTIONS_ROW) Creates each shape in FMT(i) with valid
%   key-value options (Keyi, Valuei) in a row cell array OPTIONS_ROW such 
%   that
%       OPTIONS_ROW = {Key1, Value1, ..., Keyi, Valuei, ...}
%   an arbitrary length cell array of key-value pairs.
%
%   ROOT = SHAPEF(___, OPTIONS_COL) Creates each shape in FMT(i) with valid
%   key-value options in a column cell array OPTIONS_COL such that
%       OPTIONS_COL = {{Key11, Value11, ...}; ...; {Keyk1, Valuek1, ...}},
%   where OPTIONS_COL{i} (1 <= i <= k, strlength(FMT) = k) is an arbitrary
%   length cell array of key-value pairs for shape FMT(i).
%
%   Example:
%       f = @(x) Math.Rp_to_T([], [2*x 0 0]);
%       T = arrayfun(f, -3:3, 'UniformOutput', false);
%       options = {'FaceColor', 'green', 'LineStyle', '-'};
%       Draw.shapef(axes, '<#-.-#>', [T{:}], 35, options); 
%       view(3); 
%       axis equal;
%
%   Note:
%       For cubes '#', the number of vertices is ignored, but still has to
%       be supplied for [n1 ... nk] array.
%
%       For option arguments passed directly to the shape graphics handle,
%       cubes accept patch properties, other shapes accept surface
%       properties, and text label accepts text properties.
%
%   See also HGTRANSFORM, POINT, ARROW, FRAME, SHAPEF, TREE, WHAT, and STL

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/09/2021, Matlab R2020a, v1

% assign local variables
if nargin < 3 || (nargin >= 3 && isempty(T))
    T = eye(4);
end

if nargin < 4 || (nargin >= 4 && isempty(n))
    n = -1;
end

if nargin < 5
   options = {};
end

% pad variables to arrays of length of fmt string
nf = strlength(fmt);
if length(T) == 4
    T = repmat(T, 1, nf);
end

if isscalar(n)
    n = repmat(n, 1, nf);
end

if isempty(options) || isrow(options)
    options = repmat({options}, nf, 1);
end

shapes = hgtransform('Parent', root, 'Tag', fmt);
% add children with per child definition of  T, n, and options
for i = 1:nf
    c = fmt(i);
    j = 4*(i-1)+1:4*i;
    hgt = hgtransform('Parent', shapes, 'Tag', c, 'Matrix', T(:, j));
    switch c
        case '.'
            h = ball(n(i));
        case '>'
            h = rod([1, 0], n(i));
        case '<'
            h = rod([0, 1], n(i));
        case '-'
            h = rod(1, n(i));
        case '#'
            h = cube(n(i));
        case 'L'
            h = label(n(i));
        otherwise
            warning('Unknown format %c; skipping.', fmt(i));
            continue;
    end
    o = options{i};
    h.set('Parent', hgt, 'Tag', c, 'LineStyle', 'none', o{:});
end
end

function h = label(n)
if n < 0
    n = 12;
end
h = text('FontSize', n, 'Interpreter', 'latex', 'Parent', []);
end

function h = ball(n)
if n < 0
    n = 20;
end

[X, Y, Z] = sphere(n);
h = surface(X, Y, Z, 'Parent', []);
end

function h = rod(r, n)
if n < 0
    n = 20;
end

[X, Y, Z] = cylinder(r, n);
Z = Z - 0.5; % shift (height) middle to origin
h = surface(X, Y, Z, 'Parent', []);
end

function h = cube(~)
% CUBE Draw a unit cube centered at origin and returns a patch handle

% vertices partitioned into z = +/- 1 slices
zp1 = [-1 -1 1; 1 -1 1; 1 1 1; -1 1 1];
zm1 = [-1 -1 -1; 1 -1 -1; 1 1 -1; -1 1 -1];

% scale vertices so we have a unit box centered at origin
v = 0.5 * [zm1; zp1];

% definition of i^th face
%   * f(1,:) => draw in (x, y) plane on z = -1 slice
%   * f(2,:) => draw in (x, y) plane on z = 1 slice
%   * f(3,:) => draw in (y, z) plane on x = -1 slice
%   * f(4,:) => draw in (y, z) plane on x = 1 slice
%   * f(5,:) => draw in (x, z) plane on y = -1 slice
%   * f(6,:) => draw in (x, z) plane on y = 1 slice
% vertices are specified in ccw direction, so face normal is facing out
f = [4 3 2 1; 5 6 7 8; 1 5 8 4;
    2 3 7 6; 1 2 6 5; 3 4 8 7];

h = patch('Parent', [], 'Faces', f, 'Vertices', v);
end