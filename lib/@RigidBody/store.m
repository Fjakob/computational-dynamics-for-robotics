function obj = store(obj, varargin)
% store Create or update a set of variables.
%   OBJ = store(OBJ, VAR1, VAL1, VAR2, VAL2, ...) Stores VARi as a field in
%   OBJ.Vars such that OBJ.Vars.(Vari) = VALi.  VARi must be a char array.
%   VALi can be any type.
%
%   Example:
%       rb = RigidBody('b');
%       rb.Vars
%       rb.store('F', 5, 'G', inputParser, 'H', {'h'});
%       rb.Vars
%
%       >> struct with no fields.
%       >> struct with fields: F: 5 G: [1x1 inputParser] H: {'h'}
%
%   See also var fetch clear

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

for i = 1:2:length(varargin)
    obj.Vars.(varargin{i}) = varargin{i+1};
end
end