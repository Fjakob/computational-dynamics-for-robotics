function [bodies, parent] = toArray(obj, isRoot)
% toArray Converts RigidBody tree of linked lists into an array
%   [BODIES, PARENT] = toArray(OBJ) Returns the descendent nodes
%   rooted at OBJ into an array of RigidBody objects with an integer array
%   specifying the parent of each object such that for the RigidBody at
%   index i of the bodies array PARENT(i) is its parent:
%       BODIES(PARENT(i)) == BODIES(i).Parent.
%   OBJ is considered the root of the tree and is *not* part of the BODIES
%   array.
%
%   [BODIES, PARENT] = toArray(__, ISROOT) Same as above, except if ISROOT
%   is false and nargout == 1, then OBJ is included in the BODIES array.
%   This form is only meant to be used internally as part of the recursion.
%
%   Example:
%       dir = what('ext_lib').path;
%       urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
%       root = RigidBody.fromUrdf(urdf);
%       [bodies, parent] = root.toArray()
%       bodies(parent(5)) == bodies(5).Parent
%
%       >> bodies = 1×21 RigidBody array with properties: ...
%          parent = 0 1 2 3 0 5 6 7 ...
%       >> logical 1
%
%   See also toMap fromUrdf

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

if nargin < 2
    isRoot = true;
end

bodies = obj;
for c = obj.Children
    bodies = [bodies c.toArray(false)]; %#ok<AGROW>
end

if nargout > 1
    % only compute parent array at root level, if asked
    k = arrayfun(@(b) b.Name, bodies, 'UniformOutput', false);
    n = length(bodies) - 1; % root => 0
    map = containers.Map(k, 0:n);
    
    % we drop root to make parent array line up with bodies
    bodies = bodies(2:end);
    parent = arrayfun(@(b) map(b.Parent.Name), bodies);
elseif isRoot
    % for consistency remove root before returning bodies
    bodies = bodies(2:end);
end
end