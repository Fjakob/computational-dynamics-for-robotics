function s = fetch(obj, varargin)
% fetch Fetches the values of stored variables.
%   VALUES = fetch(OBJ, VAR1, VAR2, ...) Returns a struct S such that
%   S.VARi = OBJ.Vars.VARi.
%
%   Example:
%       rb = RigidBody('b');
%       rb.store('F', 5, 'G', inputParser, 'H', {'h'});
%       V = rb.fetch('F', 'G', 'H')
%
%       >> V = struct with fields: F: 5 G: [1x1 inputParser] H: {'h'}
%
%   Note:
%       VAR1, VAR2, ... must already exist before calling fetch.
%
%   See also var store clear

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1

n = length(varargin);
s = cell(1, n);
for i = 1:n
    s{i} = obj.Vars.(varargin{i});
end
s = cell2struct(s, varargin, 2);
end