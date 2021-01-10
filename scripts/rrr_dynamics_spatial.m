% RRR_DYNAMICS_SPATIAL A spatial algebra approach to computing KE and PE.
%   This script computes the potential and kinetic energy of a 3R robot arm
%   using twists and spatial inertias.  We save the resulting equations of
%   motion to a Matlab package for use with RRR_DYNAMICS_ANIMATION.
%
%   Note:
%       Upon successful termination, this script creates the Matlab package
%       +rrr in the same parent folder of this script.  The package has the
%       necessary functions to compute the robot's dynamics.
%
%   See also +RRR RRR_DYNAMICS_ANIMATION and RRR_DYNAMICS_TRADITIONAL.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/22/2020, Matlab R2020a, v1

clear;
n = 3;

%% Create symbolic variables
%   See the corresponding documentation in rrr_dynamics_traditional.m for
%   more details regarding the |syms| syntax.
%
%   Note:
%       We define q and qdot as positive real symbolic variables.  This is
%       a *hack* to 
%
%       * get simpler results out of simplify, and 
%       * speed up the computed results of simplify.
%
%       We expect the potential and kinetic energies of the robot assuming
%       q and qdot to be |positive| to be equivalent to what we would have
%       computed by hand.
%
%       *After* you have everything working in this script, remove the
%       |positive| keyword and see how its removal affects the values of ke
%       and pe and how long it takes to simplify these variables.

syms q 'q%ddot' [n, 1] positive real
syms m r L 'I%dzz' [n, 1] real
syms g real


%% Base Case
% The base cases for relevant quantities are defined here.  The variable
%
% * ke is the kinetic energy of all links in frames {0} to {i},
% * pe is the potential energy of all links in frames {0} to {i},
% * p is the (spatial) position of frame {i} in {0} coordinates; we assume 
%   {1} and {0} are coincident at the base of the robot.
% * PoE is the Product of Exponential formula in {0} coordinates
% * Icom is the (rotational) inertia matrix in link i center-of-mass
%   coordinates
% * J_s is the spatial Jacobian mapping joint velocities to twist V_s
%
% Note:
%   We convert Icom and J_s to symbolic matrices of zeros to avoid errors
%   from Matlab.

pe = 0; % pe at i = 0
ke = 0; % ke at i = 0
p = [0; 0; 0]; % p at i = 1
PoE = eye(4);  % PoE at i = 0
Icom = sym(zeros(3, 3));  % Icom at i = 0
J_s = sym(zeros(6, n));  % J_s at i = 0 (we recurse over the cols of J_s)

%% Iterative (Recursive) Formulation of the Dyanmics
for i = 1:n
    % compute the joint axis S_i = (w_i, v_i) and displacement T_i
    w_i = [0; 0; 1]; % angular velocity of S_i
    v_i = -Math.r3_to_so3(w_i) * p;
    S_i = [w_i; v_i];
    
    Smat_i = Math.r6_to_se3(S_i);
    T_i = Math.expm6(Smat_i * q(i));
    
    % compute J_s and V_s for link i in {s} coordinates
    AdT = Math.AdT(PoE);
    J_s(:, i) = AdT * S_i;
    V_s = J_s * qdot;
    
    % center of mass (com) of link i in {0} coordinates
    %   1) compute com and Mcom at robot's home position (i.e., q = 0)    
    com = p + [r(i); 0; 0];
    Mcom = Math.Rp_to_T([], com);
    
    %   2) displace com to new location when q is arbitrary
    T_0com = PoE * T_i * Mcom;
    
    % compute I_i in {s} coordinates
    Icom(3,3) = Izz(i);
    I_s = Math.mIcom_to_spatial_inertia(m(i), Icom, T_0com);

    % iteratively compute total PE and KE of links 1 to i
    pe = pe + m(i) * g * T_0com(2, 4);
    ke = ke + 0.5 * transpose(V_s) * I_s * V_s;
    
    % update p to be origin of frame {i+1} at robot's home position (q = 0)
    p = p + [L(i); 0; 0];
    % update PoE to be displacement due to arbitrary rotations q(1), q(2),
    % ..., q(i) about joint axes 1 to i
    PoE = PoE * T_i;
end

%% Save Equations of Motion to File
%   We create a Matlab package |+rrr| and save the equations of motion to
%   the folder for use with rrr_dynamics_animation.m.

% compute Euler-Lagrange equations
pe = simplify(pe);
ke = simplify(ke);
eomSpatial = EulerLagrange(ke, pe, q, qdot);

% save the rrr package in this script's directory
dir = fileparts(which('rrr_dynamics_spatial.m'));
rrrdir = fullfile(dir, '+rrr');
eomSpatial.writeToFile(rrrdir) % returns the save directory location