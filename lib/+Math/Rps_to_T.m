function T = Rps_to_T(R, p, s)
% RPS_TO_T Converts a rotation, translation, and scale to a transformation.
%   T = RPS_TO_T(R, P, S) returns a transformation matrix T in R^{4 x 4}
%   composed of the equivalent rotation R in SO(3), translation P in R^3,
%   and scaling S in R^3 such that T = [R * S, P; 0, 1].
%       - R = [] is shorthand for R = eye(3) (the identity rotation matrix)
%       - P = [] is shorthand for P = [0; 0; 0] (the zero vector)
%       - S = [] is shorthand for S = [1; 1; 1] (the unit scaling vector)
%
%   Note:
%       The resulting transformation matrix is *not* generally a rigid body
%       motion. Its primary use is for applying a rigid-body motion to a
%       _scaled_ version of a graphic in a figure.
%
%   Example:
%       R = [0.7071 0 0.7071; 0 1 0; -0.7071 0 0.7071];
%       p = [1; 2; 3]
%       s = [2; 2; 2]
%       T = Math.Rps_to_T(R, p, s)
%
%       >> [1.4142 0 0.7071 1; 0 2 0 2; -0.7071 0 1.4142 3; 0 0 0 1]
%
%   See also RP_TO_T

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/24/2021, Matlab R2020a, v2

if isempty(s)
    s = [1; 1; 1];
elseif isscalar(s)
    s = [s; s; s];
end
T = Math.Rp_to_T(R, p);
T(1:3, 1:3) = T(1:3, 1:3) * diag(s);
end