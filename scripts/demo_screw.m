% DEMO_SCREW A demo showing a screw motion
%   This script demonstrates how a screw rotates and translates a rigid
%   body with respect to a screw axis.  The demo animates a frame {b}
%   attached to the body as the body undergoes a screw motion and a point p
%   in {b} that moves along (or parallel to) the screw axis.
%
%   Using exponential coordaintes (S, \theta) in R^6, we define a screw
%   that rotates and translates a frame {b} that is initially coincident
%   with {s} at \theta = 0.  For simiplicity, the location of the screw in
%   Cartesian space is kept at the same location for each of the examples
%   below.  We keep the screw axis fixed in {s} coordinates as {b}
%   undergoes the screw motion.
%
%   We have several options for defining a screw, see lib/ScrewAxis.m for
%   details.  A helper function at the end of this script shows how we can
%   call ScrewAxis and determines the point p on the rigid body that
%   effectively only translates (has a linear velocity) in the direction of
%   the screw axis (as oppose to a linear velocity that is orthogonal to
%   the axis as in rotational motion).
%
%   Twists and screws are covered in Modern Robotics (Section 3.3.2).
%
%   Note:
%       We assume familiarity with Exercse 3.7.  For example, we use the
%       same notation for naming certain variables such as wb, p, and
%       \dot{p} without defining them in this script.
%
%       Make sure to read the corresponding text carefully as S can be
%       defined in different frames.  In particular, ScrewAxis represents
%       the the screw as a unit twist (the ScrewAxis property UnitScrew) in
%       {b} coordinates.  If the screw axis is defined explicitly, the axis
%       is defined in "local" coordinates in a frame with an origin at the
%       base of the vector (see final twist example in this script).  The
%       code in ScrewAxis then redefines the screw in {b} coordinates.
%
%   See also ScrewAxis

clear;

%% Define location of the screw
% screw axis offset relative to {b} at \theta = 0 => {b} and {s} are
% aligned

pscrew = [1;0;0];
Tscrew = Math.Rp_to_T([], pscrew);

%% A pure rotation
% visualize a pure rotatation and compute a point on the body that
% "translates" along the screw axis.
%
% For pure rotation, points on a rigid body only translate because of the
% rotating frame (\dot{p} = 0), so the linear velocity of a point is zero
% when we are on the screw axis.  Notice that any point off the axis
% defined relative to {b} (including points that make up the point and
% frame graphics) has a non-zero linear velocity in a direction orthogonal
% to the screw axis, \dot{p} = [wb] p.  You can confirm this by curling
% your fingers from the screw axis to the point p using your right hand.

[S, p] = create_screw_and_point_p('ry', Tscrew, 'r');
sprintf('p for a screw axis with zero pitch: (%f, %f, %f)', p)

%%
% We use exponential coordinates to represent the screw motion.  We will
% animate n revolutions of the screw motion.

n = 2; % # of revolutions of \theta
N = 300; % # of points to animate
theta = linspace(0, n*2*pi, N);

% get handle to Envrionment.Axes and resize plot to avoid off screen
% animation

Axes = S.RootGraphic.Parent.Parent;
axis(Axes, 2.5 * [-1 1 -0.5 0.5 -1 1]);

% the point p is a red sphere on the screw axis
S.visualize(theta);

%% A pure translation
% visualize a pure translation and compute point on the body that
% translates along the screw axis; for a pure translation all points on the
% body translate because of the moving frame, so the linear velocity is in
% the same direction at all point even off the screw axis.
%
% Note:
%   Given the equation in Exercise 3.7, the point p will be zero because wb
%   = 0.  We do not take into consideration a screw with infinite pitch.
%   This is due to the fact that this problem is borrowed from previous
%   years and not noticing until now this particular edge case.  It should
%   be straightforward to modify your result to cover the case of pure
%   translation using the material we covered this term (see your notes and
%   code for defining a unit twist when ||w|| = 0 as a guide), so that p is
%   on the screw axis as required in the problem statement.

[S, p] = create_screw_and_point_p('py', Tscrew, 'b');
sprintf('p for a screw axis with infinite pitch: (%f, %f, %f)', p)

n = 2; % # of revolutions of \theta
N = 300; % # of points to animate
theta = linspace(0, n*2*pi, N);

% get handle to Envrionment.Axes and resize plot to avoid off screen
% animation
Axes = S.RootGraphic.Parent.Parent;
ylim(Axes, [-0.1 3]);

% the point p is a blue sphere at the origin of {b}
S.visualize([theta flip(theta)] / 7);

%% A generic screw motion
% visualize a generic screw motion and compute a point on the body that
% translates along the screw axis.  For coupled translation and rotation,
% points on the body only translate along the axis.

% define the screw axis, which is defined in "local" coordinates (i.e., a
% frame with origin at the base of the axis); the class ScrewAxis
% normalizes the axis to create a unit screw in {b} coordinates
axis = [1;1;1];

% screw pitch
h = 0.02;

[S, p] = create_screw_and_point_p({axis, h}, Tscrew, 'g');
sprintf('p for a screw axis with pitch h = %f: (%f, %f, %f)', h, p)

n = 10; % # of revolutions of \theta
N = 300; % # of points to animate
theta = linspace(0, n*2*pi, N);

% the point p is a green sphere on the screw axis
S.visualize(theta);

% ------------------------------------------

function [S, pb] = create_screw_and_point_p(type, T, color)
% create a new environment, show {s}, and add labels
env = Environment();
env.show();

xlabel('x');
ylabel('y');
zlabel('z');

% create the screw axis and label the moving frame
if iscell(type)
    axis = type{1}; % screw axis (does not have to be scaled)
    h = type{2}; % screw pitch
    S = ScrewAxis.fromAxisPitchPos(env, axis, h, T);
    type = sprintf('h = %0.2f', h);
else
    S = ScrewAxis.fromType(env, type, T);
end
S.Axis.Color = color;
S.Axis.Name = ['$\mathcal{S}_{', type, '}$'];
S.MovingFrame.Name = 'b';

% draw point p on the body; this uses the formula in Problem 3.7, which
% assumes norm(wb) ~= 0. We do not test to see if this is true.

wb = S.UnitScrew(1:3); % S.UnitScrew is in {b} coordinates => S_b
vb = S.UnitScrew(4:6);
pb = Math.r3_to_so3(wb) * vb;

% visualize the point p and add a label
T = Math.Rps_to_T([], pb, 0.1);
Draw.what(S.RootGraphic, '.', T, [], {'FaceColor', color});

T = Math.Rp_to_T([], pb + [0; 0; 0.4]);
Draw.what(S.RootGraphic, 'L', T, [], {'Color', color, 'String', '$p_b$'});
end