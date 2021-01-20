function material = parse_material(materialElement)
% PARSE_MATERIAL Extracts material parameters from a <material> element
% node.
%   MATERIAL = PARSE_MATERIAL(MATERIALELEMENT) If MATERIALELEMENT has at
%   least one optional field defined, then MATERIAL is a struct containing
%   the name, color, and texture attributes (unspecified attributes take on
%   empty values in the struct).  Otherwise MATERIAL is the material's
%   name.  If the name is returned, then the actual material information is
%   assigned during the call to PARSE.  As an optional element the value
%   for MATERIALELEMENT can be empty.
%
%   Note:
%       If defined, a material struct must have the following fields
%           Name - The name of the material
%           Color - A numerica array containing the RGBA values
%           Texture - A path to a texture file
%       If no values are specified in the corresponding attributes, then
%       the field values are empty arrays.
%
%       <material>'s attribute 'name' is required if <material> is present.
%
%   See also GET_ATTRIBUTE, GET_CHILD_ATTRIBUTE, and GET_VALUE

if isempty(materialElement)
    name = '';
    rgba = [];
    f = '';
else
    name = Urdf.get_attribute(materialElement, 'name');
    rgba = Urdf.get_child_attribute(materialElement, 'color', 'rgba', '');
    if isempty(rgba)
        rgba = [];
    else
        rgba = Urdf.get_value(rgba);
    end
    f = Urdf.get_child_attribute(materialElement, ...
        'texture', 'filename', '');
end

% parsing is complete, now populate the struct or return the material name
if isempty(rgba) && isempty(f)
    material = name;
else
    material = struct('Name', name, 'Color', rgba, 'Texture', f);
end

if ~isempty(f)
   warning('ignoring texture; parser does not support texture files.'); 
end
end