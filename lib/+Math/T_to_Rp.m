function [R, p] = T_to_Rp(T)
% T_TO_RP Decomposes a transformation into a rotation and translation.
%   [R, P] = T_TO_RP(T) returns the rotation R in SO(3) and translation P
%   in R^3 such that T = (R, P) in SE(3) is the resulting rigid-body
%   motion.
%
%   Example:
%       T = [0.7071 0 0.7071 1; 0 1 0 2; -0.7071 0 0.7071 3; 0 0 0 1];
%       [R, p] = Math.T_to_Rp(T)
%
%       >> R = [0.7071 0 0.7071; 0 1 0; -0.7071 0 0.7071]
%          p = [1; 2; 3]
%
%   See also RP_TO_T and RPS_TO_T

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

R = ???;
p = ???;
end