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
symbolic 'm' 'L' and 'r'
%   * m = [m1; m2; m3] after its definition; similarly for L and r
%   * create 3 n x 1 vector of symbolic variables of type real
%   * your answer should be in terms of |syms|, m, L, r, n, and real

symbolic 'Izz'
%   % Izz = [I1zz; I2zz; I3zz] after its definition
%   * create an n x 1 vector of symbolic variables of type real
%   * use the '%d' format specifier to customize the name of the elements
%     in Izz
%   * your answer should be in terms of |syms|, Izz, n, %d, and real

symbolic 'g'
%   * create a scalar symbolic variables of type real
%   * your answer should be in terms of syms, g, and real

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

%% Iterative (Recursive) Formulation of the Dyanmics
for i = 1:n
    phi = your recursive definition for phi
%       * phi_i = an expression in terms of phi_{i-1} and q(i)
%       * after the assignment phi should be interpreted as phi = phi_i
    
    % center of mass (com) of link i
    com = an expression in terms of p_i, r(i), and phi_i
    
    % compute velocities
    Jw = jacobian(phi, q);
    Jv = jacobian(com, q);
    
    phidot = qdot mapped into (projected onto) angular velocity space
%       * this is a primary function of the Jacobian
    comdot = qdot mapped into (projected onto) linear velocity space
%       * this is a primary function of the Jacobian
    
    % iteratively compute total PE and KE of links 1 to i
    pe = ???;
%       * pe_i = pe_{i-1} + pe of link i    
    ke = ???;
%       * ke_i = ke_{i-1} + ke of link i
%       * ke of a planar rigid body = 1/2 m * v^2 + 1/2 I_zz w^2; rewrite
%         using variables applicable to link i

    % update p to be origin of frame {i+1}
    p = ???
%       * p_{i+1} = an expression in R^2 in terms of p_i, L(i), and phi_i
end

%% Save Equations of Motion to File
%   We create a Matlab package |+rrr| and save the equations of motion to
%   the folder for use with rrr_dynamics_animation.m.

% compute Euler-Lagrange equations
ke = simplify(ke);
pe = simplify(pe);
eomTraditional = an instance of class EulerLagrange
%   * define in terms of ke and pe

% save the rrr package in this script's directory
dir = fileparts(which('rrr_dynamics_traditional.m'));
rrrdir = fullfile(dir, '+rrr');
eomTraditional.writeToFile(rrrdir) % returns the save directory location