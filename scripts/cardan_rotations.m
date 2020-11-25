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
% {b} is rotated $45^\circ$ about $\hat{y}_s$.
%
% Given this description, replace the pseudocode below with valid Matlab
% code.  In the code,
%
% * a |*| provides further context, like hints, about the piece
% of pseudocode you are trying to transform into valid code, and
% * a |+| represents additional lines of code you should write after your
% line of valid code.

beta = 45 * pi / 180;
R_gb = Rot.y(beta);
R_sb = R_sg * R_gb;

b = Frame(env, R_sb);
b.color = Utils.BLUE;
b.name = 'b';

%% Create {a} Relative to {b}
% {a} is rotated $60^\circ$ about $\hat{x}_s$.

alpha = 60 * pi / 180;
R_ba = Rot.x(alpha);
R_sa = R_sb * R_ba;

a = Frame(env, R_sa);
a.color = Utils.RED;
a.name = 'a';

%% Create $v$ and represent it in different coordinate systems
% we can perform the change of coordinates using the rotation matrices or
% the |getCoords| method of the CoordVector class.

v_a = [1; 1; 1];
va = CoordVector(env, a, v_a);
va.color = Utils.MAGENTA;
va.name = '$v_a$';

v_a %#ok<NOPTS> (tell Matlab we're OK with echoing output)
v_b = R_ba * v_a %#ok<NOPTS>
v_g = R_gb * R_ba * v_a %#ok<NOPTS>
v_s = R_sa * v_a %#ok<NOPTS>

%%
% alternatively

va.getCoords(a);
va.getCoords(b);
va.getCoords(g);
va.getCoords(env.getframe());

%%
% take a snapshot of the final frame

frame = Utils.takesnapshot(env);
Utils.savesnapshots(frame, 'cardan_rotations.png');