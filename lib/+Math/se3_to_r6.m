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

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

w = Math.so3_to_r3(Vmat);
v = Vmat(1:3, 4);
V = [w; v];
end