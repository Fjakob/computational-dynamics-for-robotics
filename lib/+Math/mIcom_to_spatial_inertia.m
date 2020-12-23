function [I_a, R_bp] = mIcom_to_spatial_inertia(m, Icom, T_ab)
% MICOM_TO_SPATIAL_INERTIA Converts mass properties to a spatial inertia
%   I_A = MICOM_TO_SPATIAL_INERTIA(M, ICOM, T_AB) returns the spatial
%   inertia of a rigid body I_A in {a} coordinates given an arbitrary frame
%   {a} and a frame {b} that is coincident with the location of the center
%   of mass of the rigid body, where M is the mass of the rigid body, ICOM
%   is the 3x3 rotational inertia matrix expressed in the center-of-mass
%   frame {b} of the rigid body, and T_AB is the configuration of {b}
%   relative to {a}. The input values M, ICOM, T_AB satisfy
%       I_B = [ICOM , 0; 0, M * eye(3)] and
%       I_A = Ad(T_AB^(-1))^T * I_B * Ad(T_AB^(-1)),
%   where Ad(T) and T^(-1) are the adjoint of T and inverse of T,
%   respectively.
%
%   [I_A, R_BP] = MICOM_TO_SPATIAL_INERTIA(___) also returns the
%   orientation of the frame {p} aligned with the prinicpal axes of ICOM
%   with respect to {b}.  This can be used in SPATIAL_INERTIA_TO_MICOM to
%   return the same ICOM used in MICOM_TO_SPATIAL_INERTIA; the default is
%   to return ICOM in {p} coordinates.
%
%   Note:
%       The frame {b} must have its origin at the center of mass of the
%       rigid body in order for I_b the spatial inertia in {b} coordinates
%       to have the special block diagonal form.
%
%   Example:
%       T_ab = eye(4);
%       Icom = [1 2 3; 4 5 6; 7 8 9];
%       m = 10;
%       I_b = Math.mIcom_to_spatial_inertia(m, Icom, T_ab)
%
%       >> [ 
%           1 2 3 0 0 0; 
%           4 5 6 0 0 0; 
%           7 8 9 0 0 0;
%           0 0 0 10 0 0;
%           0 0 0 0 10 0;
%           0 0 0 0 0 10
%          ]
%
%   See also SPATIAL_INERTIA_TO_MICOM

if nargin < 3
    T_ab = eye(4);
end

I_a = spatial inertia in frame {a} coordinates
%   + add other local variables as needed to complete the definition
%   + useful variables to add could include T_ba, a zero matrix, 
%     Adjoint of T_ba, spatial inertia I_b

if nargout > 1
    R_bp = orientation of {p} in {b} coordinates in SO(3)
%       * use Matlab's eig(...) function
end
end