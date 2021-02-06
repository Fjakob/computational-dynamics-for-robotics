% DEMO_RNEA_BY_HAND A demo showing explicit steps of computing the RNEA
%   This script demonstrates how the RNEA solves an inverse dynamics
%   problem.

clear;

%% Define Quantities
%   We define several quantities that make computing recursive equations
%   easier.

g = [0; 10; 0];
q = [0, 0, -pi/2];
qd = [3; 1; 2];
qdd = [5; 2; 3];

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
Ad1 = Math.AdT(Math.expm6(-Amat * q(1)));
Ad2 = Math.AdT(Math.expm6(-Amat * q(2)) * Minv);
Ad3 = Math.AdT(Math.expm6(-Amat * q(3)) * Minv);
Ispat = [Icom, m * transpose(cmat); m * cmat, m * I];

ad = @(V) Math.adV(V);
adT = @(V) transpose(ad(V));

% calculate load wrench
m_ext = 0.5;
p_35 = [L + 0.1; 0; 0];
Fext5 = [0; 0; 0; m_ext * g(2); 0; 0];
T_53 = Math.Rp_to_T([], -p_35);
Fext3 = transpose(Math.AdT(T_53)) * Fext5;

%% Compute the Base Case

V0 = [0; 0; 0; 0; 0; 0];
Vdot0 = [0; 0; 0; -g];

%% Expand the Recursive Case
%   We perform both passes in this part of the code

%%
% pass 1: compute velocities and known wrenches

V1 = A * qd(1);
V1dot = Ad1 * Vdot0 + A * qdd(1);
FB1 = Ispat * V1dot - adT(V1) * (Ispat * V1);
F1 = FB1; % + transpose(Ad2) * F2

V2 = Ad2 * V1 + A * qd(2);
V2dot = Ad2 * V1dot + ad(V2) * (A * qd(2)) + A * qdd(2);
FB2 = Ispat * V2dot - adT(V2) * (Ispat * V2);
F2 = FB2; % + transpose(Ad3) * F3

V3 = Ad3 * V2 + A * qd(3);
V3dot = Ad3 * V2dot + ad(V3) * (A * qd(3)) + A * qdd(3);
FB3 = Ispat * V3dot - adT(V3) * (Ispat * V3);
F3 = FB3 - Fext3;

%%
% pass 2: update the wrenches and calc the generalized forces

F2 = F2 + transpose(Ad3) * F3;
F1 = F1 + transpose(Ad2) * F2;

% compute forces
tau1 = transpose(A) * F1;
tau2 = transpose(A) * F2;
tau3 = transpose(A) * F3;

tau = [tau1; tau2; tau3];

%% Compute Motor Power

Pmotor1 = tau1 * qd(1);