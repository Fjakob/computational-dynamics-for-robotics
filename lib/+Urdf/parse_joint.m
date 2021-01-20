function joint =  parse_joint(jointElement)
% PARSE_JOINT Extracts joint parameters from a <joint> element node.
%   JOINT = PARSE_JOINT(JOINTELEMENT) Returns a struct JOINT based on
%       the child attribute and element nodes of JOINTELEMENT.
%
%   Note:
%       A joint struct must have the following fields
%           * Name - The joint's name
%           * T - A 4x4 transformation matrix in SE(3) that defines the
%             child link relative to the parent link
%           * Parent - The parent link's name
%           * Child - The child link's name
%           * Screw - A 6 x n matrix, where n is the degrees of freedom of
%             the joint and each column corresponds to a screw axis for 
%             each degree of freedom.
%
%   See also GET_VALUE GET_ATTRIBUTE, GET_CHILD_ATTRIBUTE, GET_ELEMENT,
%   PARSE_ORIGIN, and PARSE_LINK

name = Urdf.get_attribute(jointElement, 'name');
type = Urdf.get_attribute(jointElement, 'type');

parent = Urdf.get_child_attribute(jointElement, 'parent', 'link');
child = Urdf.get_child_attribute(jointElement, 'child', 'link');

origin = Urdf.get_element(jointElement, 'origin');
T = Urdf.parse_origin(origin);

axis = Urdf.get_child_attribute(jointElement, 'axis', 'xyz', '1 0 0');
axis = Urdf.get_value(axis);

joint = struct('Name', name, 'T', T, 'Parent', parent, 'Child', child, ...
    'Screw', screw(type, axis(:)));
end

function A = screw(type, axis)
% SCREW Converts a string description of a joint into an array of screw
% axes
%   A = SCREW(TYPE, AXIS) Returns a 6 x n matrix of screws based on TYPE
%   and if applicable AXIS.

z = zeros(3,1);

if norm(axis) > 0
    axis = axis / norm(axis);
end

switch type
    case {'revolute', 'continuous'}
        A = [axis; z];
    case 'prismatic'
        A = [z; axis];
    case 'fixed'
        A = [z; z];
    case 'floating'
        A = eye(6);
    case 'planar'
        A = padarray([axis null(transpose(axis))], [3, 0], 'pre');
    otherwise
        error('unknown joint type %s', type);
end
end