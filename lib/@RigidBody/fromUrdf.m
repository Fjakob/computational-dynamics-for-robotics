function [root, name] = fromUrdf(file)
%   YOUR TODO LIST: Similar to scripts/tree_urdf_parse.m, parse a URDF 
%                   file.
%       + we are creating a tree where the nodes are of type RigidBody
%       + set the following properties of a RigidBody
%           * Name - based the name of the link
%           * Parent - based on the link's parent
%               * Use obj.Parent and make sure set.Parent is implemented
%                 correctly (e.g., the child appends itself to the parent)
%           * A - based on the link's joint axis and type
%           * I - based on the link's inertial data, and
%           * M - based on the fixed transformation from parent to link.
%         The info is stored in the parsed joint and link tags of the URDF.
%       * the parameter dAdt = 0 because A is constant in link coordinates.
%       + add any graphics specified for the visual component of a link to
%         an object's Link property
%       + in order to keep the physical quantities and the graphics in 
%         sync, you should use the RigidBody's set(...) method to set 
%         Parent, A, I, and M.
end