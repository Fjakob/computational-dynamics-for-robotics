function obj = storeDefault(obj, g)
% storeDefault Stores V, Vdot, and T0 with default values.
%   OBJ = storeDefault(OBJ) Sets fields 'V', 'Vdot', and 'T0' in OBJ.Vars
%
%   Example:
%       rb = RigidBody('b');
%       rb.storeDefault();
%       rb.Vars
%
%       >> struct with fields: V: ... Vdot: ... T0: ...
%
%   See also store

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

if nargin < 2
    g = [0; 9.81; 0];
end

V0 = zeros(6,1);
Vdot0 = [zeros(3, 1); g];
T0 = eye(4);
obj.store('V', V0, 'Vdot', Vdot0, 'T0', T0);
end