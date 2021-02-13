function T = expm6(se3)
% EXPM6 Computes the matrix exponential of an element in se(3).
%   T = EXPM6(SE3) returns the 4x4 transformation matrix in SE(3) of SE3
%   in se(3).  For SE3 = [S * theta], we have
%       T = [R, G(theta)*v; 0, 1],
%   where
%       S = [w; v] in R^6 with norm(w) = 1 or norm(v) = 1 if norm(w) = 0,
%       R = e^[w * theta] in SO(3), and
%       G(theta) = I * theta + (1 - cos(theta)) * [w] 
%                  + (theta - sin(theta)) * [w]^2 in R^{3x3}.
%
%   Note:
%       Given SE3 in se(3), we use a closed-form solution to compute the
%       corresponding transformation matrix.  While there exists a built-in
%       matrix exponential function where expm6(SE3) = expm(SE3), this
%       implementation is more efficient.
%
%   Example:
%       se3 = [0 -1 0 0; 1 0 0 0; 0 0 0 2; 0 0 0 0] * pi / 2;
%       T = Math.expm6(se3)
%
%       >> [0 -1 0 0; 1 0 0 0; 0 0 1 3.1416; 0 0 0 1]
%
%   See also R3_TO_SO3 and EXPM6

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

% compute the exponential coordinates expc = S * theta
expc = Math.se3_to_r6(se3);
if norm(expc) == 0
    T = eye(4);
else
    [S, theta] = Math.expc_to_axis_angle6(expc);
    
    w_mat = Math.r3_to_so3(S(1:3));
    v = S(4:6);
    
    R = Math.expm3(w_mat * theta);
    
    w_matv = w_mat * v;
    Gv = v * theta + (1 - cos(theta)) * w_matv ...
        + (theta - sin(theta)) * (w_mat * w_matv);
    
    T = [R Gv; zeros(1,3) 1];
end
end