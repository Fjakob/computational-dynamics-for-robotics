function obj = set(obj, varargin)
% SET sets rigid body properties use a Name, Value pair.
%
%   Example:
%       rb = RigidBody('robot');
%       rb.set('M', eye(4));

p = inputParser;
p.addParameter('Parent', obj.Parent);
p.addParameter('M', obj.M);
p.addParameter('I', obj.I);
p.addParameter('A', obj.A);
p.addParameter('dAdt', obj.dAdt);
p.parse(varargin{:});
k = fieldnames(p.Results);
for i = 1:length(k)
    switch k{i}
        case 'Parent'
            obj.Parent = p.Results.Parent;
            if ~isempty(obj.Parent)
                obj.Parent.Link.add(obj.LinkTransform.RootGraphic);
            end
        case 'M'
            obj.M = p.Results.M;
            obj.LinkTransform.moveGraphic(obj.M);
        case 'I'
            obj.I = p.Results.I;
            obj.CenterOfMass.SpatialInertia = obj.I;
        case 'A'
            obj.A = p.Results.A;
            obj.Joint.setScrew(obj.A);
        case 'dAdt'
            obj.dAdt = p.Results.dAdt;
        otherwise
            warning('ignoring invalid set option: %s', k{i});
    end
end
end