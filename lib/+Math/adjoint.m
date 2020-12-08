function X = adjoint(T)
% ADJOINT Computes the adjoint of an element in se(3).
%   X = ADJOINT(T) returns the 6x6 adjoint representation of the
%   transformation matrix T in SE(3), where T = [R p; 0 1] and 
%   X = [R 0; [p]*R R] in R^{6x6}.
%
%   Example:
%       T = [1 0 0 1; 0 0 1 2; 0 -1 0 3; 0 0 0 1];
%       X = Math.adjoint(T)
%
%       >> [1  0  0  0  0  0; 
%           0  0  1  0  0  0; 
%           0 -1  0  0  0  0;
%           0 -2 -3  1  0  0;
%           3  1  0  0  0  1;
%          -2  0  1  0 -1  0
%          ]
%
%   See also RP_TO_T

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

[R, p] = a Math package function that picks T apart;
p_mat = a Math package function that returns [p] in so(3)
Z = a zero matrix of appropriate size
X = the adjoint of T
end