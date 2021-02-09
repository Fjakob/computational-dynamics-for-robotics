function [R, Icom_p] = eig(Icom_b)
% EIG Computes the principal axes of an inertia matrix.
%   [R, ICOM_P] = EIG(ICOM_B) returns the rotation matrix R in SO(3) that
%   changes the coordinates of an inertia matrix ICOM_B defined in
%   center-of-mass coordinates {b} into a frame {p} aligned with the
%   principle axes of inertia.  The resulting inertia matrix is ICOM_P,
%   which satisfies:
%       ICOM_B = R * ICOM_P * transpose(R).
%
%   Example:
%       Icom_b = [3.313 0.758 0.650; 0.758 2.438 -0.375; 
%           0.650 -0.375 1.750];
%       [R, Icom_p] = Math.eig(Icom_b)
%
%       >> [-0.4070 -0.2380 -0.8819; 0.4775 0.7676 -0.4276; 
%           0.7787 -0.5951 -0.1988]
%       >> [1.1803 0 0; 0 2.4937 0; 0 0 3.8270]
%
%   Note:
%       Unlike Matlab's builtin eig function, this function returns a
%       matrix R in SO(3).  Both functions return R' * R = I, but this
%       function ensures that det(R) = +1.  As an example, compare det(R)
%       when Icom_b = [9 0 0; 0 8 0; 0 0 7];

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

[R, Icom_p] = eig(Icom_b);
if det(R) < 0
    R = -R; % flip any one index or all 3 indices
end
end