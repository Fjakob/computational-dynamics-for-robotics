function value = var(obj, name)
% var Get value of stored variable.
%   VALUE = var(OBJ, NAME) Returns VALUE as the value stored in
%   OBJ.Vars(NAME).
%
%   Example:
%       rb = RigidBody('b');
%       rb.store('F', 5, 'G', inputParser, 'H', {'h'});
%       rb.var('F')
%       rb.var('G')
%       rb.var('H')
%
%       >> 5
%       >> inputParser with properties: ...
%       >> {'h'}
%
%   See also fetch store clear

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

value = obj.fetch(name).(name);
end