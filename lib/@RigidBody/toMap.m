function map = toMap(obj)
% toMap Converts RigidBody tree of linked lists into an associative array.
%   map = toMap(OBJ) Returns the descendent nodes rooted at OBJ into a map
%   of RigidBody objects MAP with the name of the rigid bodies as keys. OBJ
%   is considered the root of the tree and is *not* part of MAP.
%
%   Example:
%       dir = what('ext_lib').path;
%       urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
%       root = RigidBody.fromUrdf(urdf);
%       map = root.toMap()
%       map('right_foot')
%
%       >> map = Map with properties: ...
%       >> RigidBody with properties: Name: 'right_foot' ...
%
%   See also toArray fromUrdf

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

bodies = linear array of bodies rooted at obj
%   * use the corresponding RigidBody method
map = containers.Map( name of bodies as keys, bodies as values)
%   * both inputs have to be cell arrays
%   * {bodies.Name} for the keys and num2cell for the values might be
%     useful functions to use to quickly build the map's keys and values
