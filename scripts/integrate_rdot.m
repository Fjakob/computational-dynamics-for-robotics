% INTEGRATE_RDOT A script for animating a frame by integrating Rdot(t), the
% time rate of change of a rotation matrix R(t).
%
%   See also DEMO_COMPUTE_RDOT.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/17/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

%% Prerequisites
% If you haven't already, familiarize yourself with
%
% * Adding the LectureCDR files to Matlab's path using |cdr_addpath.m|.
% * Have Rot.skew, Rot.x, Rot.y, and Rot.z in <matlab:open('Rot.m') Rot.m>
% implemented and working correctly.
% * Familiarize yourself with <matlab:open('demo_single_rotation.m')
% demo_single_rotation.m> for simple examples of setting up the environment
% and <matlab:open('demo_compute_rdot.m') demo_compute_rdot.m> for
% computing \dot{R}.

%% The Environment and C(t)
% Replace the pseudocode in the cell below with valid Matlab code in order
% to create an environment and frame {c}.
%
% In the code,
%
% * a |*| provides further context, like hints, about the piece
% of pseudocode you are trying to transform into valid code, and
% * a |+| represents additional lines of code you should write after your
% line of valid code.

env = an Environment
%   * set env to be an instance of class Environment
%   + then add an extra line to show {s} in the environment

gamma = pi / 2;
R_sc = {c} rotated by gamma about the \hat{z}_s axis of {s}
%   * hint use Rot.z

c = Frame(an Environment object, a description of {c} relative to {s})
%   + add a line to set color to red (hint use the RED property in Utils)
%   + add a line to set the name to 'c'


%% The Angular Velocity
% Let's define frame {c} as rotating about a unit axis in {s} at 1 rad/s:
% $(\hat{\omega}_s, \dot{\theta}) = (\sqrt{1/3}[1, 1, 1]^T, 1)$.  In order
% to do so, replace the pseudocode in the cell below with valid Matlab code
% that
%
% # defines the angular velocity $\omega \in \mathbb{R}^3$ in {s}
% coordinates, and
% # defines its matrix representation.
% # draws $\omega_s$ in the environment.

omega_s = \hat{omega}_s * \dot{\theta}
omega_s_mat = matrix representation of omega_s
%   * hint use Rot.skew

v_omega = CoordVector(env, env.getframe(), the vector omega in {s});
%   + add a line to represent omega_s as a yellow vector
%   + add a line that names the vector '$\omega_s$ (which will render the
%     name using LaTeX markup)


%% Animate the Frame
% Now we just need to compute the R_dot and we're done!  Make use of the
% following relations to compute R_dot
%
% # $\omega_{c} = R_{cs} [\omega_s] R_{sc}$
% # $\dot{R}_{sc} = R_{sc} [\omega_c]$
% # $\dot{R}_{sc} = [\omega_s] R_{sc}$
%
% HINT: To decide which equation to use in your assignment of $\dot{R}$
% below, ask yourslef: which coordinate frame are we representing $\omega$
% in?

n = 100;
delta_t = 2*pi/n;
snapshots = Utils.takesnapshot(env); % save the current figure
for i = 1:n
    % Compute derivative using one of the equations above
    R_dot_sc = ???;
    
    % computer the Euler step
    R_sc = R_sc + R_dot_sc  * delta_t;
    c.R = R_sc;
    drawnow();
    
    % add the frame so we can create an animation later
    snapshots = Utils.takesnapshot(env, snapshots);
end

% save a video
Utils.savesnapshots(snapshots, 'integrate_rdot.mp4');