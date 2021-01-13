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

joint = struct('Name', name, 'T', T, 'Parent', parent, 'Child', child, ...
    'Screw', screw(type, axis(:)));
%   + extract these values from the joint element jointElement.  All
%     functions used in our solution appear in the See also list.  We list
%     parse_link as a reference file to look over in writing your solution.
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
%   * URDF joints are 1D except for planar and floating joints.  You
%     should order the screws in the 6x3 and 6x6 screw matrices so that the 
%     translations appear before the rotations; 
%       A = [px, py, ..., rx, ...],
%     where px is translation along the x-axis (and similarly for py & pz)
%     and rx is rotation about the x-axis (and similarly for ry & rz).
%     This will make interpreting the motion easier as displacements are 
%     done relative to the original (fixed) coordinate system and not 
%     the rotated coordinates.
    otherwise
        error('unknown joint type %s', type);
end
end