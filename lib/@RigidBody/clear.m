function obj = clear(obj)
% clear Deletes all stored variables.
%   OBJ = clear(OBJ) Removes all fields from the struct OBJ.Vars
%
%   Example:
%       rb = RigidBody('b');
%       rb.store('F', 5, 'G', inputParser, 'H', {'h'});
%       rb.Vars
%       rb.clear();
%       rb.Vars
%
%       >> struct with fields: F: 5 G: [1x1 inputParser] H: {'h'}
%       >> struct with no fields.
%
%   See also var, store, and fetch

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

obj.Vars = struct();
end