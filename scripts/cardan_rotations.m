% CARDAN_ROTATIONS A script for showing Cardan angle rotations.
%
%   See also DEMO_DOUBLE_ROTATION.

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/17/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 9/12/2013, Matlab R2012b, v11

%% Set the Matlab Path
% Run |cdr_addpath.m| in the LectureCDR root directory to set the path. See
% <matlab:open('demo_single_rotation.m') demo_single_rotation.m>.

%% Create an Environment
% We create the environment and show the space frame {s}.  {s} is also the
% origin of graphics coordinate system.

clear;
env = Environment();
env.show();

%% Create {g} Relative to {s}
% {g} is rotated $30^\circ$ about $\hat{z}_s$.

gamma = 30 * pi / 180;
R_sg = Rot.z(gamma);

g = Frame(env, R_sg);
g.color = Utils.GREEN;
g.name = 'g';

%% Create {b} Relative to {g}
% {b} is rotated $45^\circ$ about $\hat{y}_g$.
%
% Given this description, replace the pseudocode below with valid Matlab
% code.  In the code,
%
% * a |*| provides further context, like hints, about the piece
% of pseudocode you are trying to transform into valid code, and
% * a |+| represents additional lines of code you should write after your
% line of valid code.

beta = rotation angle about $\hat{y}$

R_gb = ???;
R_sb = ???;

b = Frame(???, orientation of {b} in {s})
%    + add a line that make the frame blue
%    + add a line that names the fram 'b'

%% Create {a} Relative to {b}
% {a} is rotated $60^\circ$ about $\hat{x}_b$.

alpha = ???;
%   + what rotation matrices would be useful to have defined?
%   + create a frame and store it in a variable |a|
%   + make |a| a RED frame with name 'a'

%% Create $v$ and represent it in different coordinate systems
% we can perform the change of coordinates using the rotation matrices or
% the |getCoords| method of the CoordVector class.

v_a = [1; 1; 1];
va = CoordVector(env, the frame {a}, the vector v in {a} coordinates);
va.color = Utils.MAGENTA;
va.name = '$v_a$'; % we can use LaTeX markup in string names

v_a %#ok<NOPTS> (tell Matlab we're OK with echoing output)
v_b = the free vector v in {b} coordinates
%   * you should write v_b in terms of v_a and your rotation matrices
v_g = the free vector v in {g} coordinates
v_s = the free vector v in {g} coordinates

%%
% alternatively (if you want to compare, remove semicolon to echo output)
va.getCoords(a);
va.getCoords(b);
va.getCoords(g);
va.getCoords(env.getframe());

%%
% take a snapshot of the final frame

frame = Utils.takesnapshot(env);
Utils.savesnapshots(frame, 'cardan_rotations.png');