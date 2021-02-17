% DEMO_CONSTRAINED_RIGID_BODY A demo showing a constrained mechanical system subject
% to physical holonomic constraints.
%   This script simulates a planar rigid body subject to position
%   constraints that restricts its motion to that of a pendulum when
%   the constraint is applied.  The rigid body is under the influence of a
%   uniform gravitational field.
%

clear;

%% Physical Parameters and Kinematic Constraints
% We define the physical properties and the joint axes of a robot in the
% plane.  In particular, this section defines the pivot point where the
% constraints are applied |p0| and the position of the robot's center of
% mass.  The pivot is rendered in gree on the robot and the center of mass
% as blue dots respectively.

m = 1;
L = 2;
w = 0.25;
Icom = diag([0, 0, (L^2 + w^2)/12]);

% positions of the pivot point and center of mass
p0 = [0; 0; 0];
com = [0; -L / 2; 0];

% joints
Ax = [0; 0; 0; 1; 0; 0];
Ay = [0; 0; 0; 0; 1; 0];
Az = [0; 0; 1; 0; 0; 0];

% spatial inertia
T = Math.Rp_to_T([], com);
I = Math.mIcom_to_spatial_inertia(1, eye(3), T);
Z = zeros(6);

%% Planar Rigid Body Model
% We define the various parts of the model here, including the graphics,
% constraints, and kinematic tree.

%% 
% The robot's graphics

T = Math.Rps_to_T([], com, [w; L; eps]);
mat = struct('Color', [0.5 0.5 0.5]);
g(1) = struct('Name', '', 'FormatString', '#', 'T', T, 'Material', mat);
% com
T = Math.Rps_to_T([], com, [w/4; w/4; eps]);
mat = struct('Color', [0 0 1]);
g(2) = struct('Name', '', 'FormatString', '.', 'T', T, 'Material', mat);
% pivot
T = Math.Rps_to_T([], p0, [w/2; w/2; eps]);
mat = struct('Color', [0 1 0]);
g(3) = struct('Name', '', 'FormatString', '.', 'T', T, 'Material', mat);

%% 
% The robot's kinematic tree
root = RigidBody('planar body');
rbx = RigidBody('x').set('Parent', root, 'A', Ax, 'I', Z);
rby = RigidBody('y').set('Parent', rbx, 'A', Ay, 'I', Z);
rbz = RigidBody('θ').set('Parent', rby, 'A', Az, 'I', I, 'Graphics', g);

%% 
% The robot's constraints.
%
% We use ConstrainedMechanicalSystem to represent a constrained mechanical
% system.  When representing constraints, the library is able to represent
% constraints in two flavors.  We discuss the one used in this demo.  When
% we want to constrain a point c on rigid body b of a robot, we only need
% to specify the name of the rigid body, the transform T_bc in SE(3) to
% locate the point on the body, and the constraints A that we want to apply
% such that (ignoring coordinates)
%
%   A * Ad_{T} V = A * Ad_{T} * J(q) \dot{q} = 0
%
% where A is a constant m x 6 matrix (m <= 6), V is a 6 x 1 twist, and J(q)
% is a 6 x n Jacobian mapping joint velocities to twists.

M = Math.Rp_to_T([], p0);
bRT = {'θ',  [Ax Ay]', M};

cms = ConstrainedMechanicalSystem(root);

%%
% Comment/uncomment the line below to toggle off/on the constraint.

% cms.setAp(bRT);

if ~isempty(cms.PhysicalConstraints)
    implicit = @(q, qdot, t) deal(0, 0, -p0(1:2), 0);
    cms.PhysicalConstraints.ImplicitConstraints = implicit;
    cms.PhysicalConstraints.ProportionalGainMatrix = 0;
    cms.PhysicalConstraints.DerivativeGainMatrix = 0;
end

%% Initial Conditions
% The robot's home position is along the vertical with the link pointing
% down.  The function call |root.storeDefault| sets the root node's twist
% to zero and its acceleration to a spatial acceleration with gravity
% pointing in the negative y-hat direction.

n = 3;
q = [0; 0; pi/2];
qd = [0; 0; 0];
root.storeDefault();

%% Simulate Model

T = 15;
odefun = cms.odeFun(@(t, q, qd) t);
sol = ode45(odefun, [0, T], [q;qd]);

%% Animate Rigid Body

env = Environment;
view(env.Axes, [0; 0; 2]);
xlabel('x')
ylabel('y')
subplot(1, 2, 1, env.Axes);

%%
% You can control the speed of the animation here.  If you want to slow
% things down, try multiplying N by a factor of 3 or 5.
framerate = 30;
r = rateControl(framerate);
N = T * framerate;

root.createGraphics(env)
bodies = root.toArray();

ax = subplot(1, 2, 2);
hline = animatedline(ax, 'Color', 'b');
hdotline = animatedline(ax, 'Color', 'r');
legend('$||g||$', '$||\dot{g}||$', 'Interpreter', 'Latex');

ax.Parent.WindowState = 'maximized';

for t = linspace(0, T, N)
    x = deval(sol, t);
    for i = 1:n
        b = bodies(i);
        T = Math.T_inverse(b.T(x(i)));
        b.Graphics.moveGraphic(T);
    end
    
    if ~isempty(cms.PhysicalConstraints)
        q = x(1:n);
        qd = x(n + 1: 2 * n);
        [~, ~, h, hdot] = cms.PhysicalConstraints.calcImplicit(q, qd, t);
        addpoints(hline, t, norm(h));
        addpoints(hdotline, t, norm(hdot));
    end
    waitfor(r);
end