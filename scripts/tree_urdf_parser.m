% URDF_PARSER A script for displaying CDR-compatible URDF files.
%
%   Note:
%       * If you want to add more URDF models, place them in ext_lib.
%       * We recommend running this script as a live script.
%
%   See also EXT_LIB/HUMANOID_URDF EXT_LIB/IIWA_DESCRIPTION and
%   EXT_LIB/MYSTERY_ROBOT.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1

%%

clear;

%% Parse the URDF file
% You can test up to three pre-installed URDF files.  What is the mystery
% robot?

dir = what('ext_lib').path;
urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
% urdf = fullfile(dir, 'iiwa_description', 'urdf', 'iiwa14.urdf');
% urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');

[joints, links, materials, name] = Urdf.parse(urdf);


%% Create the Rigid Bodies
% We create elements of the scene graph using matlab graphic containers.
% At this point, we just want to add individual rigid bodies.  We'll
% connect them into a tree in the next step.

names = links.keys;
rbtree = containers.Map();
for i = 1:length(names)
    link = links(names{i});
    g = link.Graphic;
    
    % here we map URDF <visual> information to Matlab graphics
    rb = hgtransform('Parent', [], 'Tag', names{i});
    if ~isempty(g)
        Draw.???(args are in terms of fields in g and the object rb)
%       + call Draw.??? to add a graphic as a child of rb; look at each
%         file and determine which one(s) to use.
        h = findobj(rb, '-property', 'FaceColor');
        set(h, 'FaceColor', g.Material.Color(1:3));
    end

    rbtree(names{i}) = rb;
end

%% Connect the Bodies into a Tree
% now we add parent-child relationships and offsets

names = joints.keys;
for i = 1:length(names)
    joint = joints(names{i});
    
    p = parent contained in joint i
    c = child contained in joint i
    rb = the node named child in rbtree
%       + update rb's parent
%       + update rb's transform
end

%% Find the Root
% The pre-distributed URDF files contain a single kinematic tree.  Find the
% root.

names = rbtree.keys;
root = [];
%   + write a for loop to find the root node
%   * to determine the root node, consider what special connectivity 
%     property it has that no other node has in terms of its place in the 
%     tree
%   * we know there is only one root; consider a |break| when you find it

%% Display the Robot
% create an environment and show the results
env = Environment;
env.SpaceFrame.add(root);
env.resetOutput;

%% Output a Scene Graph
% output a scene graph, showing how various components are related; it
% helps to be familiar with the URDF file to understand how the visual
% components relate to each other.

html = fullfile(tempdir, 'main.html');
Draw.tree(root, html);
open(html);