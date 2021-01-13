function link = parse_link(linkElement)
% PARSE_LINK Extracts visual parameters from a <geometry> element node.
% LINK = PARSE_LINK(LINKELEMENT) Returns a struct LINK based on
%   the child attribute and element nodes of LINKELEMENT.
%
%   Note:
%       A link struct must have the following fields
%           * Name - The joint's name
%           * I - A 6x6 spatial inertia matrix in link coordinates
%           * Graphic - A struct describing the visual properties of a 
%             link.
%
%   See also GET_ATTRIBUTE, GET_ELEMENT, PARSE_INERTIAL, and PARSE_VISUAL

name = Urdf.get_attribute(linkElement, 'name');
inertial = Urdf.get_element(linkElement, 'inertial');
I = Urdf.parse_inertial(inertial);
visual = Urdf.get_element(linkElement, 'visual');
g = Urdf.parse_visual(visual);
link = struct('Name', name, 'I', I, 'Graphic', g);
end