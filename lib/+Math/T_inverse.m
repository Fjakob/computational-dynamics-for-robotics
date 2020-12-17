function Tinv = T_inverse(T)
% T_INVERSE Computes the inverse of T in SE(3).
%   TINV = T_INVERSE(T) returns the 4x4 inverse matrix of T.
%
%   Example:
%       T = [1 0 0 1; 0 0 1 2; 0 -1 0 3; 0 0 0 1];
%       Tinv = Math.transform_inverse(T)
%
%       >> [1 0 0 -1; 0 0 -1 3; 0 1 0 -2; 0 0 0 1]
%
%   See also R_INVERSE

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

[R, p] = Math.T_to_Rp(T);
Rinv = Math.R_inverse(R);
Tinv = [Rinv -Rinv*p; zeros(1,3) 1];
end