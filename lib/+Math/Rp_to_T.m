function T = Rp_to_T(R, p)
% RP_TO_T Converts a rotation and translation to a transformation.
%   T = RP_TO_T(R, P) returns a transformation matrix T in SE(3) composed
%   of the equivalent rotation R in SO(3) and translation P in R^3 such
%   that T = [R, P; 0, 1].
%       - R = [] is shorthand for R = eye(3) (the identity rotation matrix)
%       - P = [] is shorthand for P = [0; 0; 0] (the zero vector)
%
%   Example:
%       R = [0.7071 0 0.7071; 0 1 0; -0.7071 0 0.7071];
%       p = [1; 2; 3]
%       T = Math.Rp_to_T(R, p)
%
%       >> [0.7071 0 0.7071 1; 0 1 0 2; -0.7071 0 0.7071 3; 0 0 0 1]
%
%   See also T_TO_RP and RPS_TO_T

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

if isempty(R)
    R = eye(3);
end
if isempty(p)
    p = zeros(3,1);
end
T = [R p(:); zeros(1,3) 1];
end