% DEMO_CONSTRAINED_RIGID_BODY A demo showing a constrained mechanical
% system subject to physical and virtual holonomic constraints.
%   This script simulates a two-degree-of-freedom, variable-length pendulum
%   subject to a position constraint that restricts its motion.  The model
%   is duplicated twice, once with only physical holonomic constraints
%   (PHC) being applied and the other with only virtual holonomic
%   constraints (VHC) being applied.  There are no potential forces in this
%   system (gravity is zero).
%
%   Interpreting the PHC:
%       For the PHC model, imagine that the bob of the pendulum is placed
%       inside a pre-fabricated slot.  A constraint force ensures that the
%       bob moves within the slot.  We can model and simulate these types
%       of real-world interactions as long as we are dealing with workless
%       constraints.  As in the real-world, there is no such thing as
%       turning 'off' the constraint force.
%
%   Interpreting the VHC:
%       For the VHC model, the virtual constraints are enforced through the
%       control input u(t); there is *no* physical slot that constrains the
%       motion.  When the control input is off (u(t) = 0) the unconstrained
%       variable-length pendulum dynamics are in effect.
%
%   Note:
%       The source and further background information for the model can be
%       found here:
%       http://web.eecs.umich.edu/~grizzle/papers/Westervelt_biped_control_book_15_May_2007.pdf#page=135
%
%       Variables prefixed with phc are associated with the physical
%       constraints and similarly for vhc and virtual constraints.
%

clear;

%% Physical Parameters and Kinematic Constraints
% We define the physical properties and the joint axes of a robot in the
% plane.  In particular, the robot has two degrees of freedom (its joint
% angle and length).  This section defines the pivot point of the pendulum
% |p0|, the position of the robot's center of mass, and the (virtual) slot
% profile.  The pivot is rendered in green on the robot and the center of
% mass (pendulum bob) as blue dots, respectively.

m = 1;
L0 = 1.5;
w = 0.25;

% positions of the pivot point and center of mass
p0 = [0; 0; 0];
com = [0; 0; 0];

% joints
Az = [0; 0; 1; 0; 0; 0];
Ay = [0; 0; 0; 0; 1; 0];

% desired trajectory for L (the slot profile in θ-L space)
Ldesired = @(theta) sin(theta) + L0;

% spatial inertia (the center-of-mass is at the pendulum's bob)
T = Math.Rp_to_T([], com);
I = Math.mIcom_to_spatial_inertia(1, zeros(3), T);
Z = zeros(6);

%% Planar Rigid Body Model
% We define the various parts of the model here, including the graphics,
% constraints, and kinematic tree.  The model is duplicated twice to
% represent the two scenarios under consideration.

%%
% The robot's graphics (because zero scaling isn't possible, eps => 0)

T_zy = Math.R('x', pi/2);
T = Math.Rps_to_T(T_zy, p0, [w/8; eps; eps]);
mat = struct('Color', [0.5 0.5 0.5]);
gth(1) = struct('Name', '', 'FormatString', '-', 'T', T, 'Material', mat);
% pivot
T = Math.Rps_to_T([], p0, [w/4; w/4; eps]);
mat = struct('Color', [0 1 0]);
gth(2) = struct('Name', '', 'FormatString', '.', 'T', T, 'Material', mat);
% com
T = Math.Rps_to_T([], com, [w/2; w/2; eps]);
mat = struct('Color', [0 0 1]);
gL = struct('Name', '', 'FormatString', '.', 'T', T, 'Material', mat);

%%
% The robot's kinematic tree.

phcroot = RigidBody('PHC');
rb = RigidBody('θ').set('Parent', phcroot, 'A', Az, 'I', Z, 'Graphics', gth);
RigidBody('L').set('Parent', rb, 'A', Ay, 'I', I, 'Graphics', gL);

vhcroot = RigidBody('VHC');
rb = RigidBody('θ').set('Parent', vhcroot, 'A', Az, 'I', Z, 'Graphics', gth);
RigidBody('L').set('Parent', rb, 'A', Ay, 'I', I, 'Graphics', gL);

%%
% The robot's constraints.
%
% We use ConstrainedMechanicalSystem to represent a constrained mechanical
% system.  When representing constraints, the library is able to represent
% constraints in two flavors.  We discuss the one used in this demo.  In
% this demo, quantities needed to solve for a constrained mechanical system
% are computed symbolically and then passed as a function into the various
% constraints.  The specific quantites we need comprise the acceleration
% constraints:
%
%   A(q) * qdd + dA(q)dt qd + v(q, qd) = 0
%               \_____________________/
%                     phi(t, q, qd)
%
% where A(q) is a k x n constraint matrix, v(q, qd) is our linear feedback
% controller, and q, qd, qdd are the generalized positions, velocities, and
% accelerations, respectively.  We group all terms that do not include the
% unknown variable qdd into a catch-all variable phi(t, q, qd) \in R^k (t
% is time).

syms q 'q%dd' [2, 1] real
syms t real

g = q(2) - Ldesired(q(1));
A = jacobian(g, q);
phi = transpose(qd) * jacobian(A, q) * qd;
gdot = A * qd;

% for virtual constraints, we need to specify A(q) and transmission matrix
% B(q) \in \R^{n x k}

Bcon = @(q, qd, t) deal([0 1], 0, 0, 0);

%%
% convert symbolic constraints into a numeric function
implicit = matlabFunction(A, phi, g, gdot, 'Vars', {q, qd, t});

%%
% assign the function to the physical and virtual constraints
phccms = ConstrainedMechanicalSystem(phcroot);
phccms.setAp({});
phccms.PhysicalConstraints.ImplicitConstraints = implicit;

vhccms = ConstrainedMechanicalSystem(vhcroot);
vhccms.setAvB({}, {});
vhccms.VirtualContraints.ImplicitConstraints = implicit;
vhccms.TransmissionMatrix.ImplicitConstraints = Bcon;

%%
% We set the gain matrices manually because the library can't determine the
% size of the matrices needed to assign the gains default values when we
% only specify ImplicitConstraints in a ConstrainedMechanicalSystem.
% Setting these values to zero will turn off the feedback control law.  The
% constraints will still be active, but if there are any perturbations in
% in q or qd that push the robot off the constraint surface g(q) = 0 then
% the robot will not converge back to g(q) = 0.

phccms.PhysicalConstraints.ProportionalGainMatrix = 1;
phccms.PhysicalConstraints.DerivativeGainMatrix = 1;

vhccms.VirtualContraints.ProportionalGainMatrix = 1;
vhccms.VirtualContraints.DerivativeGainMatrix = 1;

%% Initial Conditions
% The robot's home position is along the vertical with the link pointing
% upwards.  The function call |root.storeDefault| sets the root node's
% spatial velocity and acceleration to zero (there is no gravity in this
% system).  We assign the initial conditions to ensure that the constraints
% are satisfied from the beginning.  You can introduce initial conditions
% that violate the constraints to see the feedback controllers in action.
%
% Note:
%   Setting L = 0 will lead to a singular mass matrix.

theta = 0;
thetadot = 1;

L = -subs(g, [q1, q2], [theta 0]);
Ldot = -subs(gdot, [q1, q2, q1d, q2d], [theta 0, thetadot, 0]);

n = 2;
q = double([theta; L]);
qd = double([thetadot; Ldot]);

phcroot.storeDefault([0;0;0]);
vhcroot.storeDefault([0;0;0]);

%% Simulate Model

T = 15;
odefun = phccms.odeFun(@(t, q, qd) t);
phcsol = ode45(odefun, [0, T], [q; qd]);

odefun = vhccms.odeFun(@(t, q, qd) t);
vhcsol = ode45(odefun, [0, T], [q; qd]);

%% Animate Rigid Body

%%
% add visuals to first column of subplot

phcenv = Environment(subplot(2, 3, 1));
view(phcenv.Axes, [0; 0; 2]);
xlabel('$x$ (m)', 'Interpreter', 'Latex')
ylabel('$y$ (m)', 'Interpreter', 'Latex')

vhcenv = Environment(subplot(2, 3, 4));
view(vhcenv.Axes, [0; 0; 2]);
xlabel('$x$ (m)', 'Interpreter', 'Latex')
ylabel('$y$ (m)', 'Interpreter', 'Latex')

%%
% add acceleration vs time in second column of subplot

ax = subplot(2, 3, 2);
phcthetadd = animatedline(ax, 'Color', 'c');
phcLdd = animatedline(ax, 'Color', 'b');
legend('$\ddot{\theta}(t)$', '$\ddot{L}(t)$', 'Interpreter', 'Latex');
xlabel('$t$ (seconds)', 'Interpreter', 'Latex');
ylabel('$\ddot{q}(t)$', 'Interpreter', 'Latex');

ax = subplot(2, 3, 5);
vhcthetadd = animatedline(ax, 'Color', 'm');
vhcLdd = animatedline(ax, 'Color', 'r');
legend('$\ddot{\theta}(t)$', '$\ddot{L}(t)$', 'Interpreter', 'Latex');
xlabel('$t$ (seconds)', 'Interpreter', 'Latex');
ylabel('$\ddot{q}(t)$', 'Interpreter', 'Latex');

%%
% add constraint forces and control inputs in third column of subplot

phclambda = animatedline(subplot(2, 3, 3), 'Color', 'b');
legend('$\lambda(t)$', 'Interpreter', 'Latex');
xlabel('$t$ (seconds)', 'Interpreter', 'Latex');
ylabel('$\lambda(t)$ (constraint force)', 'Interpreter', 'Latex');

vhcu = animatedline(subplot(2, 3, 6), 'Color', 'r');
legend('$u(t)$', 'Interpreter', 'Latex');
ylabel('$u(t)$ (control input)', 'Interpreter', 'Latex');

%%
% add constraint surface to each plot

theta = linspace(-2 * pi, 2 * pi, 100);
x = -Ldesired(theta) .* sin(theta);
y = Ldesired(theta) .* cos(theta);
z = zeros(size(y));

subplot(phcenv.Axes)
hold on;
plot3(x, y, z);
hold off;
subplot(vhcenv.Axes)
hold on;
plot3(x, y, z);
hold off;

limits = [[min(x)-0.1, max(x)+0.1, min(y)-0.1, max(y)+0.1], -0.1 3];
axis(phcenv.Axes, limits, 'square')
axis(vhcenv.Axes, limits, 'square')

%%
% Maximize plot (can grab any handle that gives access to subplot figure)
vhcenv.Axes.Parent.WindowState = 'maximized';
drawnow;

%%
% You can control the speed of the animation here.  If you want to slow
% things down, try multiplying N by a factor of 3 or 5.

framerate = 30;
r = rateControl(framerate);
N = T * framerate;
t = linspace(0, T, N);

%%
% Create robot graphics

phcroot.createGraphics(phcenv);
phcbodies = phcroot.toArray();

vhcroot.createGraphics(vhcenv);
vhcbodies = vhcroot.toArray();

%%
% Animate results
phcpower = zeros(1, N);
vhcpower = zeros(1, N);
for i = 1:N
    phcx = deval(phcsol, t(i));
    vhcx = deval(vhcsol, t(i));
    
    for j = 1:n
        b = phcbodies(j);
        M = Math.T_inverse(b.T(phcx(j)));
        b.Graphics.moveGraphic(M);
        
        b = vhcbodies(j);
        M = Math.T_inverse(b.T(vhcx(j)));
        b.Graphics.moveGraphic(M);
    end
    
    % scale rod (indices figured out through inspection of tree)
    L = phcx(2);
    M = Math.Rps_to_T(T_zy, [0; L / 2; 0], [w/8; eps; L]);
    rod = phcbodies(1).Graphics.RootGraphic.Children(3).Children;
    rod.Matrix = M;
    
    L = vhcx(2);
    M = Math.Rps_to_T(T_zy, [0; L / 2; 0], [w/8; eps; L]);
    rod = vhcbodies(1).Graphics.RootGraphic.Children(3).Children;
    rod.Matrix = M;
    
    q = phcx(1:n);
    qd = phcx(n + 1: 2 * n);
    [qdd, forces] = phccms.fD(q, qd, t(i));
    addpoints(phcthetadd, t(i), qdd(1));
    addpoints(phcLdd, t(i), qdd(2));
    addpoints(phclambda, t(i), forces.lambda);
    phcpower(i) = transpose(forces.lambda) * forces.Ap * qd;
    
    q = vhcx(1:n);
    qd = vhcx(n + 1: 2 * n);
    [qdd, forces] = vhccms.fD(q, qd, t(i));
    addpoints(vhcthetadd, t(i), qdd(1));
    addpoints(vhcLdd, t(i), qdd(2));
    addpoints(vhcu, t(i), forces.u);
    vhcpower(i) = transpose(qd) * forces.B * forces.u;
    waitfor(r);
end

%%
% recreate plots in Figure 5.3 of Feedback Control of Dynamic Bipedal Robot
% Locomotion (link below) and plot power as a function of time for both
% constraints.
%
% http://web.eecs.umich.edu/~grizzle/papers/Westervelt_biped_control_book_15_May_2007.pdf#page=135

figure;
subplot(2, 2, 1)
plot(deval(phcsol, t, 1), deval(phcsol, t, 2), '--', ...
    deval(vhcsol, t, 1), deval(vhcsol, t, 2));
title('Kinematic behavior', 'Interpreter', 'Latex');
xlabel('$\theta$ (rad)', 'Interpreter', 'Latex');
ylabel('$l$ (m)', 'Interpreter', 'Latex');

subplot(2, 2, 2)
plot(t, deval(phcsol, t, 2), '--', t, deval(vhcsol, t, 2));
title('Dynamic behavior', 'Interpreter', 'Latex');
xlabel('$t$ (sec)', 'Interpreter', 'Latex');
ylabel('$l$ (m)', 'Interpreter', 'Latex');

% plot power
subplot(2, 2, [3, 4])
plot(t, phcpower, '--', t, vhcpower);
title('Power Injected to Enforce the Constraints', 'Interpreter', 'Latex');
xlabel('$t$ (sec)', 'Interpreter', 'Latex');
ylabel('Power (J)', 'Interpreter', 'Latex');
legend('$\lambda^T A_p \dot{q}$ (PHC)', '$\dot{q}^T B u$ (VHC)', ...
    'Interpreter', 'Latex');