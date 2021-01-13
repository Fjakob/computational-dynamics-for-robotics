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

if material is empty
    ???
else
    parse <material>
end
%   * parse the material element here by extracting its attributes and its
%     children's attributes.  Make sure to test that it isn't empty and to
%     set appropriate values if it is.
%
%   * suggested functions can be found in the list of See also functions.

% parsing is complete, now populate the struct or return the material name
if isempty(rgba) && isempty(f)
    material = name;
else
    material = struct(...);
end

if ~isempty(f)
   warning('ignoring texture; parser does not support texture files.'); 
end
end