function graphic = parse_visual(visualElement)
% PARSE_VISUAL Extracts visual parameters from a <visual> element node.
%   GRAPHIC = PARSE_VISUAL(VISUALELEMENT) Returns a struct GRAPHIC based on
%       the child attribute and element nodes of VISUALELEMENT.
%
%   Note:
%       A graphic struct must have the following fields
%           * Name - The graphic's name
%           * FormatString - A char array compatible with a string expected
%             in calls to functions in the Draw package.
%           * T - A composition of a 4x4 scaling matrix S and 
%             link-to-visual frame transformation matrix in SE(3) 
%             T_iv such that T = T_iv * S
%           * Material - Either a character array that references the name
%             of a <material> struct defined outside of the parent <link> 
%             tag or a material struct (see PARSE_MATERIAL) for details.
%
%       A call to PARSE_GEOMETRY with a geometry element will partially
%       populate GRAPHIC with S and FormatString.
%
%   See also GET_ATTRIBUTE GET_ELEMENT PARSE_ORIGIN PARSE_GEOMETRY and
%   PARSE_MATERIAL

%   + use the See also functions to tackle this problem; it contains all
%     functions you will need for this problem.
%   + the returned graphic struct is a modification of the struct returned
%     by Urdf.parse_geometry.  In the version of the struct in this 
%     file, modify the field containing the scaling matrix and add 
%     two new fields as described in the above documentation.
%   * Don't forget, this element is optional.  If <visual> is not present, 
%     then graphic should be an empty value (e.g., graphic = []).
end