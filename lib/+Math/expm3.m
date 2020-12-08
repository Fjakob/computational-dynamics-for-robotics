function R = expm3(so3)
% EXPM3 Computes the matrix exponential of an element in so(3).
%   R = EXPM3(WMAT) returns the 3x3 rotation matrix in SO(3) of WMAT in
%   so(3) using Rodrigues' rotation formula, where for SO3 = [w_hat theta]
%       R = I + sin(theta) [w_hat] + (1 - cos(theta)) [w_hat]^2,
%   where w_hat in R^3 is a unit rotation axis and theta in R is the amount
%   of rotation about the axis.
%
%   Note:
%       Given WMAT in so(3), we use Rodrigues' rotation formula to compute
%       the corresponding rotation matrix.  While there exists a built-in
%       matrix exponential function where expm3(WMAT) = expm(WMAT), this
%       implementation is more efficient.
%
%   Example:
%       wmat = [0 -1 0; 1 0 0; 0 0 0] * pi / 2;
%       R = Math.expm3(wmat)
%
%       >> [0 -1 0; 1 0 0; 0 0 1]
%
%   See also R3_TO_SO3 and EXPM6

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

% compute the exponential coordinates expc = w_hat * theta
expc = Math.so3_to_r3(so3);
if norm(expc) == 0
    % b/c theta = 0, we can't compute a unique rotation axis; but it
    % doesn't matter
    R = eye(3);
else
    [w_hat, theta] = Math.expc_to_axis_angle3(expc);
    w_mat = Math.r3_to_so3(w_hat);
    R = eye(3) + sin(theta) * w_mat ...
        + (1 - cos(theta)) * w_mat^2;
end
end