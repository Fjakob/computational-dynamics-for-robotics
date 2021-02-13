function obj = set(obj, varargin)
% set sets rigid body properties using a Name, Value pair.
%   OBJ = set(OBJ, VARARGIN) Updates OBJ's properties based on (Name,
%   Value) pairs.  The following Name options are valid:
%       'Parent' - Updates OBJ's parent to Value and
%       OBJ.LinkTransform.RootGraphic's parent to Value.Link.RootGraphic
%       'M' - Updates the fixed parent-to-OBJ transform of OBJ and
%       OBJ.LinkTransform.
%       'I' - Updates OBJ's spatial inertia and the spatial inertia of
%       OBJ.CenterOfMass
%       'A' - Updates OBJ's screw axis and the screw axis of OBJ.ScrewAxis
%       'dAdt' - Updates OBJ's screw axis derivative
%       'Fext0' - Updates OBJ's external wrench
%
%   Example:
%       T = [0.6428 0 0.766 5; 0 1 0 -4; -0.766 0 0.6428 3; 0 0 0 1];
%       rb = RigidBody('robot-link-name');
%       rb.set('M', T, 'I', zeros(6));
%       rb.M
%
%       >> [0.6428 0 0.766 5; 0 1 0 -4; -0.766 0 0.6428 3; 0 0 0 1]

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

p = inputParser;
p.addParameter('Parent', obj.Parent);
p.addParameter('M', obj.M);
p.addParameter('I', obj.I);
p.addParameter('A', obj.A);
p.addParameter('dAdt', obj.dAdt);
p.addParameter('Fext0', obj.Fext0);
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
        case 'Fext0'
            obj.Fext0 = p.Results.Fext0;
        otherwise
            warning('ignoring invalid set option: %s', k{i});
    end
end
end