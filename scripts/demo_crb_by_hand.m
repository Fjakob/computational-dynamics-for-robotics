% DEMO_CRB_BY_HAND A demo showing explicit steps of computing the CRB
%   This script demonstrates how the CRB computes the mass matrix M(q).

clear;

%% Define Quantities
%   We define several quantities that make computing recursive equations
%   easier.

q = [0, pi/3, -pi/2, pi/4];

m = 1;
L = 1;
p = [L; 0; 0];

Icom = [0, 0, 0; 0, m*L/4, 0; 0, 0, m*L/3];
cmat = Math.r3_to_so3(-p / 2);
I = eye(3);

A = [0; 0; 1; 0; 0; 0];
Amat = Math.r6_to_se3(A);
M = [I p; zeros(1,3) 1];
Minv = Math.T_inverse(M);
Ad_10 = Math.AdT(Math.expm6(-Amat * q(1)));
Ad_20 = Math.AdT(Math.expm6(-Amat * q(2)));
Ad_31 = Math.AdT(Math.expm6(-Amat * q(3)) * Minv);
Ad_42 = Math.AdT(Math.expm6(-Amat * q(4)) * Minv);
Ispat = [Icom, m * transpose(cmat); m * cmat, m * I];

Ic4 = Ispat;
Ic3 = Ispat;
Ic2 = Ispat + transpose(Ad_42) * Ic4 * Ad_42;
Ic1 = Ispat + transpose(Ad_31) * Ic3 * Ad_31;

A_11 = A;
A_22 = A;
A_33 = A;
A_44 = A;
A_31 = Ad_31 * A;
A_42 = Ad_42 * A;

%% Compute M

M = zeros(4, 4);

M(1, 1) = transpose(A_11) * Ic1 * A_11;
M(2, 2) = transpose(A_22) * Ic2 * A_22;
M(3, 3) = transpose(A_33) * Ic3 * A_33;
M(4, 4) = transpose(A_44) * Ic3 * A_44;

    M(4, 2) = transpose(A_44) * Ic4 * A_42;
M(2, 4) = M(4, 2);
M(3, 1) = transpose(A_33) * Ic3 * A_31;
M(1, 3) = M(3, 1);

M