function root = createGraphics(obj, parent)
if nargin < 2
    parent = [];
end

g = obj.Graphics;
if ~isa(g, 'EnvironmentObject')
    root = EnvironmentObject(parent);
    if ~isempty(g)
        for i = 1:length(g)
            h = Draw.what(root.RootGraphic, g(i).FormatString, g(i).T);
            set(findobj(h, '-property', 'FaceColor'), ...
                'FaceColor', g(i).Material.Color(1:3));
        end
    end
    obj.Graphics = root;
else
    root = obj.Graphics;
end

for c = obj.Children
    c.createGraphics(root);
end
end