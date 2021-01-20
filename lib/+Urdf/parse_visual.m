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

if isempty(visualElement)
    graphic = [];
else
    name = Urdf.get_attribute(visualElement, 'name', '');
    
    origin = Urdf.get_element(visualElement, 'origin');
    T = Urdf.parse_origin(origin);
    
    material = Urdf.get_element(visualElement, 'material');
    
    geometry = Urdf.get_element(visualElement, 'geometry');
    graphic = Urdf.parse_geometry(geometry);
    
    graphic.T = T * graphic.T;
    graphic.Name = name;
    graphic.Material = Urdf.parse_material(material);
end
end