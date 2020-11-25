% INTEGRATE_NONUNIFORM_CARDAN A script for animating a frame by integrating
% the time rate of change of the Cardan angles $(\alpha, \beta, \gamma)$.
%
%   See also DEMO_COMPUTE_RDOT and CARDAN_ROTATIONS.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/22/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

%% Non-Uniform Motion
% why did we go through all of this trouble to map the angular velocity to
% the Cardan velocities?  Why not just use the Cardan velocities directly?
% This script does just that.  When you watch the resulting animation,
% you'll see that the motion is non-uniform and is not smooth.

% there is a lot of code overlap with integrate_cardan.m, so let's call
% that first to reuse some of the data created.  A better approach would be
% to put the common parts of both files into a function. 
%
% NOTE: You'll see the animation from |integrate_cardan.m| first and then
% the animation from this script

run integrate_cardan.m;

%%
% make $[\omega_c]$ into a function

omega_c_mat_fct = matlabFunction(omega_c_mat, ...
    'Vars', [alpha, beta, gamma, alpha_dot, beta_dot, gamma_dot]);

%%
% set up the numerical variables
alpha_num = 0;
beta_num = 0;
gamma_num = pi / 2;

alpha_dot_num = 1;
beta_dot_num = 1;
gamma_dot_num = 1;

%% Setup Another Environemnt
% reset {c} (and change its color) and $\omega_b$ to their values at t = 0

env2 = Environment();
env2.show();

R_sc_num = R_sc_fct(alpha_num, beta_num, gamma_num);
c = Frame(env2, R_sc_num);
c.color = Utils.BLUE;
c.name = 'c';

omega_c_mat_num = omega_c_mat_fct(alpha_num, beta_num, gamma_num, ...
    alpha_dot_num, beta_dot_num, gamma_dot_num);

omega_c_num = Rot.deskew(omega_c_mat_num);

v_omega = CoordVector(env2, c, omega_c_num);
v_omega.color = Utils.YELLOW;
v_omega.name = '$v_\omega$';

%% Animate the Frame
% integrate directly with the cardan velocities in the Euler integration

snapshots = Utils.takesnapshot(env2); % save the current figure
for i = 1:n
    % Euler integration
    alpha_num = alpha + \dot{alpha} * delta_t;
    beta_num = ...;
    gamma_num = ...;
    
    R_sc_num = R_sc_fct(alpha_num, beta_num, gamma_num);

    omega_c_mat_num = omega_c_mat_fct(alpha_num, beta_num, gamma_num, ...
        alpha_dot_num, beta_dot_num, gamma_dot_num);
    
    omega_c_num = Rot.deskew(omega_c_mat_num);
    
    % updated the frame
    c.R = R_sc_num;
    % update the vector
    v_omega.setCoords(c, omega_c_num);
    % update graphics
    drawnow();
    snapshots = Utils.takesnapshot(env2, snapshots);
end

% save a video
Utils.savesnapshots(snapshots, 'integrate_nonuniform_cardan.mp4');