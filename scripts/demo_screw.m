% DEMO_SCREW A demo showing a screw motion
%   This script demonstrates how a screw rotates and translates a rigid
%   body with respect to a screw axis.
%
%   See also ScrewAxis

clear;

env = Environment;
env.show();

xlabel('x');
ylabel('y');
zlabel('z');

%% Define location of the screw
%  We define a screw that rotates and translates a moving frame {b} that is
%  initially coincident with {s} at \theta = 0.  The axis of the screw is
%  defined in {s} coordinates and is kept at the same location for each of
%  the examples below.

% screw axis offset
pscrew = [1;0;0];
Tscrew = Math.Rp_to_T([], pscrew);

%% Exponential Coordinates in R^6
% We use exponential coordinates to represent the screw motion.  We will
% animate n revolutions of the screw motion.

n = 5; % # of revolutions of \theta
N = 500; % # of points to animate
theta = linspace(0, n*2*pi, N);

%% A pure rotation

s = ScrewAxis.fromType(env, 'ry', Tscrew);
s.Axis.Color = 'magenta';
s.Axis.Name = 'S';

% compute point on the body that "translates" along the screw axis; for a
% pure rotation points on the body only translate because of the rotating
% moving frame, so the linear velocity is zero when we are on the screw
% axis.  Notice that p_b has to be somewhere on the screw axis to not
% rotate about the axis (have a linear velocity orthogonal to the screw
% axis).

wb = s.UnitScrew(1:3);
vb = s.UnitScrew(4:6);
p_b = Math.r3_to_so3(wb) * vb;
T = Math.Rps_to_T([], p_b, 0.1);

% draw point on the body (body is initially coincident with {s})
Draw.what(s.RootGraphic, '.', T, [], {'FaceColor', 'r'});

s.visualize(theta);

%% A pure translation

s = ScrewAxis.fromType(env, 'py', Tscrew);
s.Axis.Color = 'magenta';
s.Axis.Name = 'S';

% compute point on the body that translates along the screw axis; for a
% pure translation all points on the body translate because of the moving
% frame, so the linear velocity is the same at all point even off the screw
% axis.  The point p_b is chosen because of the desire to choose a point
% that satisfies dot(w_b, p_b) = 0;

wb = s.UnitScrew(1:3);
vb = s.UnitScrew(4:6);
p_b = Math.r3_to_so3(wb) * vb;
T = Math.Rps_to_T([], p_b, 0.1);

% draw point on the body (body is initially coincident with {s})
Draw.what(s.RootGraphic, '.', T, [], {'FaceColor', 'b'});

s.visualize([theta flip(theta)]/20); % go forwards and backwards

%% A generic screw motion
axis = [1;1;1]; % screw axis; the internal code also normalizes the axis
h = 0.02; % pitch

s = ScrewAxis.fromAxisPitchPos(env, axis, h, Tscrew);

% compute point on the body that translates along the screw axis; for a
% coupled translation and rotation points on the body only translate along
% the axis.

wb = s.UnitScrew(1:3);
vb = s.UnitScrew(4:6);
p_b = Math.r3_to_so3(wb) * vb;
T = Math.Rps_to_T([], p_b, 0.1);

% draw point on the body (body is initially coincident with {s})
Draw.what(s.RootGraphic, '.', T, [], {'FaceColor', 'g'});

s.visualize(theta);