function AdT = AdT(T)
% ADT Computes the adjoint of an element in se(3).
%   X = ADT(T) returns the 6x6 adjoint representation of the
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

[R, p] = Math.T_to_Rp(T);
p_mat = Math.r3_to_so3(p);
Z = zeros(3,3);
AdT = [R Z; p_mat * R R];
end