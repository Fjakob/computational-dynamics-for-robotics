function [m, Icom, T_ab] = spatial_inertia_to_mIcom(I_a, R_ab)
% SPATIAL_INERTIA_TO_MICOM Converts spatial inertia to mass properties.
%   [M, ICOM, T_AB] = SPATIAL_INERTIA_TO_MICOM(I_A) returns the mass M,
%   inertia matrix ICOM at the center-of-mass frame {b} with axes aligned
%   with {a}, and transform T_AB in SE(3) (the
%   configuration of {b} relative to {a}) of the spatial inertia I_A.  The
%   output values M, ICOM, T_AB satisfy
%       T_AB = [I p_ab; 0 1]
%       I_A = Ad(T_AB^(-1))^T * [ICOM, 0; 0, M * eye(3)] * Ad(T_AB^(-1)),
%   where I is the identity matrix in SO(3), p_ab in R^3 is the location of
%   the origin of {b} in {a} coordinates, and Ad(T) and T^(-1) are the
%   adjoint of T and inverse of T, respectively.
%
%   [M, ICOM, T_AB] = SPATIAL_INERTIA_TO_MICOM(___, R_AB) returns the mass
%   M, inertia matrix ICOM, and transform T_AB in SE(3) with respect to a
%   center-of-mass frame {b}.  The frame {b} has orientation R_AB in SO(3)
%   relative to {a}.  In this case, T_AB is
%       T_AB = [R_AB p_ab; 0 1]
%   where p_ab in R^3 is the location of the origin of {b} in {a}
%   coordinates.
%
%   Note:
%       Internally, we define an intermediate coordinate frame {c} so
%       that we can better keep track of the different frames and the
%       transforms between them.  The three frames we use interally are
%
%          * {a} - the frame I_a is defined in.
%          * {b} - a center-of-mass frame (i.e., the origin of {b} is
%          located at the center of mass of the rigid body).  The axes of
%          the frame are rotated R_ab with respect to {a}.
%          * {c} - a frame with origin coincident with the origin of {a},
%          but with axese aligned with {b} (i.e, R_ac = R_ab).
%
%   See also SPATIAL_INERTIA_TO_MICOM

if nargin < 2
    % {b} is a center-of-mass frame with axes aligned with {a}
    R_ab = eye(3);
end

m = ???
Icom = ???
T_ab = ???
end