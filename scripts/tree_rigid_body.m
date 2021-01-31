% TREE_RIGID_BODY A script for demoing the RigidBody class.
%
%   See also TREE_URDF_PARSER and RIGIDBODY.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1

clear;
clc;

dir = what('ext_lib').path;
urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');

root = RigidBody.fromUrdf(urdf);

[bodies, parent] = root.toArray();

html = fullfile(tempdir, 'rb.html');
root.tree(html);
open(html)

env = Environment;
env.SpaceFrame.add(root.LinkTransform.RootGraphic);
