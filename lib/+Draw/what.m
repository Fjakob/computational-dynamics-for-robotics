function g = what(root, fmt, varargin)
% WHAT Creates a graphics object
%   G = WHAT(ROOT, FMT, VARARGIN) Returns a hgtransform graphics object G
%   containing graphics defined by FMT with ROOT set as the parent object
%   and additional parameters stored in VARARGIN.  ROOT can be any valid
%   graphics handle or the empty list.  FMT determines which drawing
%   function in the Draw package is called.  If FMT is
%
%       * a valid file, then DRAW.STL is called (the file extension does 
%         not matter)
%       * 'point', the DRAW.POINT is called
%       * 'arrow', then DRAW.ARROW is called
%       * 'frame', then DRAW.FRAME is called
%       * otherwise DRAW.SHAPEF is called
%
%   The parameters in VARARGIN are any additional arguments (required or
%   optional) that can be passed to the underlying function in the Draw
%   package the value of FMT maps to.
%
%   Example:
%       Draw.what(axes, 'arrow', 'ArrowHeadHeight', [], 'P', 1:3); 
%       view(3); 
%       axis equal;
%
%       >> plot of arrow graphic with tail at origin and head at [1;2;3]
%
%   See also HGTRANSFORM, POINT, ARROW, FRAME, SHAPEF, TREE, and STL

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1

if isfile(fmt)
    g = Draw.stl(root, fmt, varargin{:});
else
    switch fmt
        case 'point'
            g = Draw.point(root, varargin{:});
        case 'arrow'
            g = Draw.arrow(root, varargin{:});
        case 'frame'
            g = Draw.frame(root, varargin{:});
        otherwise
            g = Draw.shapef(root, fmt, varargin{:});
    end
end
end