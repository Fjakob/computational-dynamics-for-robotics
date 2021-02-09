% DEMO_VISUALIZE_INTERTIA A demo for visualizing inertia ellipsoids.
%   This script shows how to use the class CenterOfMass to visualize
%   inertia ellipsoids
%
%   See also MICOM_TO_SPATIAL_INERTIA and CENTEROFMASS

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 02/09/2021, Matlab R2020a, v1

clear;

%% Create Spatial Inertia
%   Here we create a spatial inertia from mass m and inertia matrix Icom

m = 10;
Icom_p = diag([2 3 4]);

expc = [0; 1; 0] * pi / 2;
R_bp = Math.expm3(Math.r3_to_so3(expc));
Icom_b = R_bp * Icom_p * R_bp';

p_ab = [1;2;3];
expc = [0; 0; 1] * pi / 2;
R_sb = Math.expm3(Math.r3_to_so3(expc));
T_sb = Math.Rp_to_T(R_sb, p_ab);

I_s = Math.mIcom_to_spatial_inertia(m, Icom_b, T_sb);

[m2, Icom_c, T_sc] = Math.spatial_inertia_to_mIcom(I_s, R_sb);

%% Draw inertia ellipsoid
%   In the output figure, we define |env| as the body frame for visualizing
%   the center of mass and its ellipsoid.
%
%   Because we are not able to exactly recover T_sb and R_sb from a call to
%   Math.mIcom_to_spatial_inertia, we instead are vieweing a center-of-mass
%   frame defined by the transform T_sc.  In the output, as expected, {com}
%   has its axes aligned with {s} as specified in T_sc.
%
%   We do not bother to interpret the orientation of {p} relative to {s}
%   given the above data, because the underlying code is a hack (see
%   Math.eig) and, in general, there are several ways of defining the order
%   of the principal axes (we could choose a convention, like order the
%   axes from largest to smallest principle moments, but we would still
%   have the issue of coordinates flips in Math.eig).  All we can say is
%   that the relative orientation is a (signed) permuation of the
%   orientation specified by R_sb * R_bp.

env = Environment;
env.show()
com = CenterOfMass(env, I_s);

%%
% show ellipsoid and principal axes scaled the principal moments
 
com.show('e', 'p', 'f');

%%
% show all possible graphics
 
% com.show('f', 'e', 'p', 'c');

%%
% hide all possible graphics

% com.hide('c', 'f', 'e', 'p', 'c');

env.resetOutput