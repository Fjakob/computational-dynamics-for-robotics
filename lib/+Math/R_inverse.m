function Rinv = R_inverse(R)
% R_INVERSE Computes the inverse of R in SO(3).
%   RINV = R_INVERSE(R) returns the 3x3 inverse matrix of R.
%
%   Example:
%       R = [1 0 0; 0 0 1; 0 -1 0];
%       Rinv = Math.rotation_inverse(R)
%
%       >> [1 0 0; 0 0 -1; 0 1 0]
%
%   See also T_INVERSE

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

Rinv = transpose(R);
end