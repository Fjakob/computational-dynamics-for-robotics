function Vmat = r6_to_se3(V)
% R6_TO_SE3 Convert V in R^6 into [V] in se(3).
%   VMAT = R6_TO_SE3(V) returns the 4x4 matrix representation of V in
%   se(3).
%
%   Example:
%       syms w1 w2 w3 v1 v2 v3 real;
%       V = [w1; w2; w3; v1; v2; v3];
%       Vmat = Math.r6_to_se3(V)
%
%       >> [0 -w3 w2 v1; w3 0 -w1 v2; -w2 w1 0 v3; 0 0 0 0]
%
%   See also SE3_TO_R6 AND EXPM6

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

w_mat = Math.r3_to_so3(V);
v = V(4:6);
Vmat = [w_mat v; zeros(1,4)];
end