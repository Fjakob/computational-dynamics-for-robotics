function wmat = r3_to_so3(w)
% R3_TO_SO3 Convert w in R^3 into [w] in so(3).
%   WMAT = R3_TO_SO3(W) returns the 3x3 skew-symmetric matrix
%   representation of W in so(3).
%
%   Note: 
%       For two vectors a and b, cross(a, b) = [a] * b.
%
%   Example:
%       syms w1 w2 w3 real;
%       w = [w1; w2; w3];
%       wmat = Math.r3_to_so3(w)
%
%       >> [0 -w3 w2; w3 0 -w1; -w2 w1 0]
%
%   See also SO3_TO_R3 and EXPM3

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

wmat = [0 -w(3) w(2); w(3) 0 -w(1); -w(2) w(1) 0];
end