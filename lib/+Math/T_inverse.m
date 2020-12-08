function Tinv = T_inverse(T)
% TRANSFORM_INVERSE Computes the inverse of T in SE(3).
%   TINV = TRANSFORM_INVERSE(T) returns the 4x4 inverse matrix of T.
%
%   Example:
%       T = [1 0 0 1; 0 0 1 2; 0 -1 0 3; 0 0 0 1];
%       Tinv = Math.transform_inverse(T)
%
%       >> [1 0 0 -1; 0 0 -1 3; 0 1 0 -2; 0 0 0 1]
%
%   See also R_INVERSE

[R, p] = Math package function that converts T to [R, p]
Rinv = Math package that computes inverse of R
Tinv = inverse of T using a combination of R, p, and Rinv
end