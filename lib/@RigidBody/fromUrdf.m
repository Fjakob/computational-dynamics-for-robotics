function [root, name] = fromUrdf(file)
% fromUrdf Creates a tree with nodes of type RigidBody from a URDF file.
%   [ROOT, NAME] = fromUrdf(FILE) Returns the root of the tree ROOT and the
%   name of the robot as specified in the <robot> tag of a URDF file
%   specified with FILE.
%
%   Example:
%       dir = what('ext_lib').path;
%       urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
%       [root, name] = RigidBody.fromUrdf(urdf)
%
%       >> root = RigidBody with properties: ...
%       >> name = 'robot'
%
%   See also tree_urdf_parser toMap toArray

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

[joints, links, ~, name] = Urdf.parse(file);

tree = containers.Map();
for i = links.keys
    k = i{:};
    link = links(k);
    g = link.Graphic;
    rb = RigidBody(link.Name).set('I', link.I);
    if ~isempty(g)
        h = Draw.what(rb.Link.RootGraphic, g.FormatString, g.T);
        set(findobj(h, '-property', 'FaceColor'), ...
            'FaceColor', g.Material.Color(1:3));
    end
    tree(k) = rb;
end

for i = joints.keys
    k = i{:};
    joint = joints(k);
    
    p = joint.Parent;
    c = joint.Child;
        
    rb = tree(c);
    rb.set('Parent', tree(p), 'M', joint.T, 'A', joint.Screw);
end

root = RigidBody.empty();
for i = tree.keys
    k = i{:};
    rb = tree(k);
    if isempty(rb.Parent)
        root = rb;
    end
end

assert(~isempty(root));
end