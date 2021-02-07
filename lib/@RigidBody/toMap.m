function [map, names] = toMap(obj)
% toMap Converts RigidBody tree of linked lists into an associative array.
%   [MAP, NAMES] = toMap(OBJ) Returns the descendent nodes rooted at OBJ
%   into a map of RigidBody objects MAP with the name of the rigid bodies
%   NAMES as keys. OBJ is considered the root of the tree and is *not* part
%   of MAP.  The names in the cell array NAMES are in the same order as the
%   names of the bodies in the linear array returned from toArray would
%   appear.
%
%   Example:
%       dir = what('ext_lib').path;
%       urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
%       root = RigidBody.fromUrdf(urdf);
%       [map, names] = root.toMap()
%       map('right_foot')
%
%       >> map = Map with properties: ...
%       >> RigidBody with properties: Name: 'right_foot' ...
%
%   See also toArray fromUrdf

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 02/07/2021, Matlab R2020a, v2

bodies = linear array of bodies rooted at obj
%   * use the corresponding RigidBody method
map = containers.Map( name of bodies as keys, bodies as values)
%   * both inputs have to be cell arrays
%   * {bodies.Name} for the keys and num2cell for the values might be
%     useful functions to use to quickly build the map's keys and values
%   * {bodies.Name} is also the order of the names of the bodies array.
