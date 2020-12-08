function Rinv = R_inverse(R)
% ROTATION_INVERSE Computes the inverse of R in SO(3).
%   RINV = ROTATION_INVERSE(R) returns the 3x3 inverse matrix of R.
%
%   Example:
%       R = [1 0 0; 0 0 1; 0 -1 0];
%       Rinv = Math.rotation_inverse(R)
%
%       >> [1 0 0; 0 0 -1; 0 1 0]
%
%   See also T_INVERSE

Rinv = transpose(R);
end