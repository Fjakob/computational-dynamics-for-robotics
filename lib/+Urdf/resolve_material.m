function link = resolve_material(link, materials)
% RESOLVE_MATERIAL Maps name of material in a material struct
%
%   See also RESOLVE_PATH

g = link.Graphic;
if ~isempty(g) && ischar(g.Material)
    m = g.Material;
    if materials.isKey(m)
        link.Graphic.Material = materials(m);
    else
        n = link.Name;
        msg = ['Link %s refers to an undefined material %s;', ...
            ' setting a random color for material property.'];
        warning(msg, n, m);
        link.Graphic.Material = struct('Color', rand(1, 4), ...
            'Texture', '');
    end
end
end