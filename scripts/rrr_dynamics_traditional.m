% RRR_DYNAMICS_TRADITIONAL A traditional approach to computing KE and PE.
%   This script computes the potential and kinetic energy of a 3R robot arm
%   using the traditional approach of specifying the position and
%   orientation of each link's center of mass with respect to the robot's
%   base frame.  We save the resulting equations of motion to a Matlab
%   package for use with RRR_DYNAMICS_ANIMATION.
%
%   Note:
%       Upon successful termination, this script creates the Matlab package
%       +rrr in the parent folder of this script.  The package has the
%       necessary functions to compute the robot's dynamics.
%
%   See also +RRR RRR_DYNAMICS_ANIMATION and RRR_DYNAMICS_SPATIAL.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/22/2020, Matlab R2020a, v1

%% Create symbolic variables
%   The robot has n degrees of freedom and so we generate the coordinates
%   and model parameters based on n.
%
%   Note:
%       Read the |syms| documentation to learn more about the new syntax
%       used below.  Specifically, %d is a format specifier and [n, 1]
%       creates an n x 1 vector of symbolic variables.

clear;
n = 3;

syms q 'q%ddot' [n, 1] real
syms m L 'I%dzz' r [n, 1] real
syms g real

%% Base Case
% The base cases for relevant quantities are defined here.  The variable
%
% * ke is the kinetic energy of all links in frames {0} to {i},
% * pe is the potential energy of all links in frames {0} to {i},
% * phi is the orientation of frame {i} in {0} coords, and
% * p is the (planar) position of frame {i} in {0} coordinates; we assume 
%   {1} and {0} are coincident at the base of the robot.
%
% All variables listed are scalars except p, which is a 2 x 1 vector.

%  <+>
%{
ke = ???; % ke at i = 0
%   * there are no links between frame {0} and {0}
pe = ???; % pe at i = 0
%   * there are no links between frame {0} and {0}?
phi = ???; % phi at i = 0
%   * use your base case solution from the corresponding problem here
p = ???; % p at i = 1
%   * use your base case solution from the corresponding problem here
%}
% </+>
ke = 0; % ke at i = 0
pe = 0; % pe at i = 0
phi = 0; % phi at i = 0
p = [0; 0]; % p at i = 1

%% Iterative (Recursive) Formulation of the Dyanmics
for i = 1:n
    phi = phi + q(i);
    
    % center of mass (com) of link i
    com = p + r(i) * [cos(phi); sin(phi)];
    
    % compute velocities
    Jw = jacobian(phi, q);
    Jv = jacobian(com, q);
    
    phidot = Jw * qdot;
    comdot = Jv * qdot;
    
    % iteratively compute total PE and KE of links 1 to i
    pe = pe + m(i) * g * com(2);
    ke = ke + 0.5 * m(i) * transpose(comdot) * comdot ...
        + 0.5 * Izz(i) * phidot^2;

    % update p to be origin of frame {i+1}
    p = p + L(i) * [cos(phi); sin(phi)];
end

%% Save Equations of Motion to File
%   We create a Matlab package |+rrr| and save the equations of motion to
%   the folder for use with rrr_dynamics_animation.m.

% compute Euler-Lagrange equations
ke = simplify(ke);
pe = simplify(pe);
eomTraditional = EulerLagrange(ke, pe, q, qdot);

% save the rrr package in this script's directory
dir = fileparts(which('rrr_dynamics_traditional.m'));
rrrdir = fullfile(dir, '+rrr');
eomTraditional.writeToFile(rrrdir) % returns the save directory location