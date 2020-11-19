% DEMO_DOUBLE_ROTATION A demo on how to chain together two rotations.
%   This script demonstrates how to perform a change of coordinates of a
%   frame {c} into the space frame {s} using an intermediate frame {b}.
%
%   See also DEMO_SINGLE_ROTATION.

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de
%   11/17/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de
%   9/12/2013, Matlab R2012b, v11

%% Set the Matlab Path
% Run |cdr_addpath.m| in the LectureCDR root directory to set the path.  You
% can find out more about setting the path in
% <matlab:open('demo_single_rotation.m') demo_single_rotation.m>.

%% Create an Environment
% We create the environment and show the space frame {s}.  {s} is also the
% origin of graphics coordinate system.

clear;
env = Environment();
env.show();

%% Create {b} Relative to {s}
% {b} is rotated $20^\circ$ about $\hat{z}_s$.  If you don't have Rot.z
% working, then replace R_sb with
%
% R_sb = [cos(gamma), -sin(gamma), 0;
%         sin(gamma),  cos(gamma), 0;
%         0,           0,          1];

gamma = 20 * pi / 180;
R_sb = Rot.z(gamma);

b = Frame(env, R_sb);
b.color = Utils.RED;
b.name = 'b';

%% Incorrectly Create {c} Relative to {s}
% {c} is rotated $15^\circ$ about $\hat{y}_b$.  If you don't have Rot.y
% working, then replace R_bc with
%
% R_bc =[cos(beta), 0, +sin(beta);
%     0         , 1,  0;
%     -sin(beta), 0, +cos(beta)];

beta = 15 * pi / 180;
R_bc = Rot.y(beta);

c = Frame(env, R_bc); % hmmm, is this how we define {c} relative to {s}?
c.color = Utils.BLUE;
c.name = 'c';

%% The Correct Way to Create {c} Relative to {s}
% Oops!  The previous cell didn't do what we wanted.  We need to define
% R_sc.  In this example, note that we don't have to create a new frame;
% just update the |R| of the previous object |c| representing {c}.

R_sc = R_sb * R_bc; % is this right?  Try the subscript cancellation rule.
c.R = R_sc; % set R to the correct orientation

%% Create a Vector $v$ and represent it in different coordinate systems
% Let's represent $v$ in {s} and {c}.

%%
% output v_c ($v$ in {c} coordinates)

v_c = [1; 1; 0] %#ok<NOPTS> (tell Matlab we're OK with echoing output)
v1 = CoordVector(env, c, v_c);
v1.color = Utils.BLACK;
v1.name = 'v1';

%%
% output v_s ($v$ in {s} coordinates)

v_s = R_sb * R_bc * v_c %#ok<NOPTS>
v2 = CoordVector(env, env.R, v_s);
v2.color = Utils.GRAY;
v2.name = 'v2';

%%
% take a snapshot of the final frame

frame = Utils.takesnapshot(env);
Utils.savesnapshots(frame, 'demo_double_rotation.png');