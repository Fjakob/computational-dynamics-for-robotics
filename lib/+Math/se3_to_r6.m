function V = se3_to_r6(Vmat)
% SE3_TO_R6 Convert [V] in se(3) into V in R^6.
%   V = SE3_TO_R6(VMAT) returns the R^6 vector representation of VMAT in
%   se(3).
%
%   Example:
%       syms w1 w2 w3 v1 v2 v3 real;
%       Vmat = [0 -w3 w2 v1; w3 0 -w1 v2; -w2 w1 0 v3; 0 0 0 0];
%       V = Math.se3_to_r6(Vmat)
%
%       >> [w1; w2; w3; v1; v2; v3]
%
%   See also R6_TO_SE3

w = a function in the Math package that converts from so3 to R^3
v = part of Vmat that contains v
V = w and v;
end