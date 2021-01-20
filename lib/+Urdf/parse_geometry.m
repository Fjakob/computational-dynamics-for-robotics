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

val = @Urdf.get_value;
getChildAttr = @Urdf.get_child_attribute;

% '*' is a wildcard character that matches any tag name
% we know there is only one element, so we'll grab it and check the tag
% name in order to create the corresponding graphic
element = Urdf.get_element(geometryElement, '*');
tagName = char(element.getTagName());

switch tagName
    case 'box'
        scale = val(getChildAttr(geometryElement, 'box', 'size'));
        fmt = '#';
    case 'cylinder'
        r = val(getChildAttr(geometryElement, 'cylinder', 'radius'));
        h = val(getChildAttr(geometryElement, 'cylinder', 'length'));
        scale = [r; r; h];
        fmt = '-';
    case 'sphere'
        scale = val(getChildAttr(geometryElement, 'sphere', 'radius'));
        fmt = '.';
    case 'mesh'
        file = getChildAttr(geometryElement, 'mesh', 'filename');
        fmt = Urdf.resolve_path(geometryElement, file);
        scale = val(getChildAttr(geometryElement, 'mesh', 'scale', '1'));
    otherwise
        warning('unknown geometry in geometry element');
        fmt = '';
        scale = [];
end


% all done parsing! create a scaling transform and the struct
T = Math.Rps_to_T([], [], scale);
geometry = struct('FormatString', fmt, 'T', T);
end