function geometry = parse_geometry(geometryElement)
% PARSE_GEOMETRY Extracts geometric parameters from a <geometry> element
% node.
%   GEOMETRY = PARSE_GEOMETRY(GEOMETRYELEMENT) Returns a struct GEOMETRY
%   based on the child element nodes of GEOMETRYELEMENT.  The struct
%   contains the arguments for calls to functions in the Draw package.
%
%   Note:
%       A geometry struct must have the following fields
%           * FormatString - A char array compatible with a string expected
%           in calls to functions in the Draw package.
%           * T - A 4x4 matrix that scales the geometry along coordinate
%           axes.
%
%   See also GET_VALUE, GET_CHILD_ATTRIBUTE, and RESOLVE_PATH


% '*' is a wildcard character that matches any tag name
% we know there is only one element, so we'll grab it and check the tag
% name in order to create the corresponding graphic
element = Urdf.get_element(geometryElement, '*');
tagName = char(element.getTagName());

%   YOUR TODO LIST:
%   + consider using a switch statement to handle all of the geometry
%     types and set |fmt| and |scale| used below.  You can use the 
%     |otherwise| statement to print a warning and set |fmt| and |scale| to
%     empty values.
%   * when processing <mesh> set the optional value of |scale| to 1
%   * you should study the Draw package to understand how to set the
%     character |fmt| based on the link's geometry.

% all done parsing! create a scaling transform and the struct
T = Math.Rps_to_T([], [], scale);
geometry = struct('FormatString', fmt, 'T', T);
end