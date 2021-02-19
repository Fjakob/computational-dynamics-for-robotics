% DEMO_CONSTRAINTS_IMPACTS A demo showing a bouncing ball undergoing
% collisions inside a box.

clear;

%% Physical Parameters and Kinematic Constraints
% We define the physical properties and the joint axes of a robot in the
% plane.  In particular, this section defines the pivot point where the
% constraints are applied |p0| and the position of the robot's center of
% mass.  The pivot is rendered in green on the robot and the center of mass
% as blue dots respectively.

m = 1;
r = 1;
Icom = diag(m * r^2 * [1/4, 1/4, 1/2]);

% origin of robot at home position and center of mass
p0 = [0; 0; 0];
com = [0; 0; 0];

% joints
Ax = [0; 0; 0; 1; 0; 0];
Ay = [0; 0; 0; 0; 1; 0];
Az = [0; 0; 1; 0; 0; 0];

% spatial inertia
T = Math.Rp_to_T([], com);
I = Math.mIcom_to_spatial_inertia(1, eye(3), T);
Z = zeros(6);

% wall location (offset from origin in all directions)
wall = 4 * r;

%% Planar Rigid Body Model
% We define the various parts of the model here, including the graphics,
% constraints, and kinematic tree.

%%
% The robot's graphics

% ball
T = Math.Rps_to_T([], p0, [r; r; eps]);
mat = struct('Color', [1 0 1]);
g = struct('Name', '', 'FormatString', '.', 'T', T, 'Material', mat);

%%
% The wall graphics

% left
T = Math.Rps_to_T([], [-wall; 0; 0], [10 * eps; 2 * wall; 2 * r]);
mat = struct('Color', [0.5 0.5 0.5]);
gw(1) = struct('Name', '', 'FormatString', '#', 'T', T, 'Material', mat);
% bottom
T = Math.Rps_to_T([], [0; -wall; 0], [2 * wall; 10 * eps; 2 * r]);
mat = struct('Color', [0.5 0.5 0.5]);
gw(2) = struct('Name', '', 'FormatString', '#', 'T', T, 'Material', mat);
% right
T = Math.Rps_to_T([], [wall; 0; 0], [10 * eps; 2 * wall; 2 * r]);
mat = struct('Color', [0.5 0.5 0.5]);
gw(3) = struct('Name', '', 'FormatString', '#', 'T', T, 'Material', mat);
% top
T = Math.Rps_to_T([], [0; wall; 0], [2 * wall; 10 * eps; 2 * r]);
mat = struct('Color', [0.5 0.5 0.5]);
gw(4) = struct('Name', '', 'FormatString', '#', 'T', T, 'Material', mat);


%%
% The robot's kinematic tree
T = Math.Rp_to_T([], p0);
root = RigidBody('bouncing ball').set('Graphics', gw);
rbx = RigidBody('x').set('Parent', root, 'A', Ax, 'I', Z, 'M', T);
rby = RigidBody('y').set('Parent', rbx, 'A', Ay, 'I', I, 'Graphics', g);

%%
% The robot's constraints.
%
% We use InstantaneousCollision to represent collisions.  When representing
% collision constraints (the restitution map), the library is able to
% represent constraints in two flavors. We discuss the one used in this
% demo.  When we want to constrain a point c on rigid body b of a robot, we
% only need to specify the name of the rigid body, the transform T_bc in
% SE(3) to locate the point on the body, and the constraints A that we want
% to apply such that (ignoring coordinates)
%
%   A * Ad_{T} V = A * Ad_{T} * J(q) \dot{q} = 0
%
% where A is a constant m x 6 matrix (m <= 6), V is a 6 x 1 twist, and J(q)
% is a 6 x n Jacobian mapping joint velocities to twists.

ic = InstantaneousCollision(root);

Mleft = Math.Rp_to_T([], [-r; 0; 0]);
Mbottom = Math.Rp_to_T([], [0; -r; 0]);
Mright = Math.Rp_to_T([], [r; 0; 0]);
Mtop = Math.Rp_to_T([], [0; r; 0]);

bRT = {
    'y',  Ax', Mleft;
    'y',  Ay', Mbottom;
    'y',  Ax', Mright;
    'y',  Ay', Mtop};

gcontact = wall * [-1; -1; 1; 1];

% we set g = gcomputed - gcontact (where gcomputed are the computed terms
% defined by bRT)
ic.setAp(bRT);
implicit = @(q, qdot, t) deal(0, 0, -gcontact, 0);
ic.PhysicalConstraints.ImplicitConstraints = implicit;

%% Initial Conditions
% The robot's home position is at the origin of the world frame.  The
% function call |root.storeDefault| sets the root node's twist to zero and
% its acceleration to a spatial acceleration with gravity pointing in the
% negative y-hat direction.

n = 2;
T = 15;
q = [0; 0];
qd = [-2; 8];
root.storeDefault();

%% Simulate Model
% Here we simulate the rigid body until we've reached time T.  If there are
% any impacts within this time interval we need to stop the integration,
% compute the post-impact state (q+, qd+) of the robot, and restart the
% integration from our post-impact state.  The while loop accomplishes all
% of this.  In order to avoid having the same impact event trigger multiple
% times, we tell Matlab that we are only interested in impacts in a certain
% direction as defined by the variable |direction|.  The meaning of the
% values in the vector are:
%
%   -1 => trigger event when g(q) is decreasing when the event
%         detector finds a time t when g(q(t)) = 0,
%   +1 => trigger event when g(q) is increasing when g(q(t)) = 0, and
%   0 => trigger an event in either direction
%
% an event is a zero crossing of any element in the vector g(q).
%
% Read more about event detection in the docs:
%   web(fullfile(docroot, 'matlab/math/ode-event-location.html'))

direction = [-1; -1; 1; 1];

% get the ode function and the event detection function, which is stored in
% an ode options struct as required by the documentation.  You should look
% at InstantaneousCollision.odeFun for further details, but, in a nutshell,
% the event function computes g(q) and tells the ode solver to stop
% integration if any element of g(q) is zero.

[odefun, opts] = ic.odeFun(@(t, q, qd) 0, [], direction);
sol = ode45(odefun, [0, T], [q;qd], opts);

tol = 1e-8;
k = size(bRT, 1);
impulses = []; % save the impulses so we can plot later
while abs(T - sol.x(end)) > tol
    % the event detection has triggered, find the events and make them
    % active to compute the collision.  The event indices are stored in
    % sol.ie.  The events are in the same order that we added our collision
    % constraints.
    
    % get the active constraint
    i = sol.ie(end);
    
    % get the pre-impact state x- = x(t-) = (q(t-), qd(t-))
    q = sol.y(1:n, end);
    qd = sol.y(n + 1:n + n, end);
    
    % set the constraints to only the active constraint i
    ic.setAp(bRT(i, :));
    implicit = @(q, qdot, t) deal(0, 0, -gcontact(i), 0);
    ic.PhysicalConstraints.ImplicitConstraints = implicit;
    ic.CoefficientOfRestitution = 1;
    
    % compute the post-impact state x+ = x(t+)
    [qd, data] = ic.fD(q, qd); % post-impact velocity
    sol.y(:, end) = [q; qd];
    % note: we can only replace the last entry w/o affecting the struct
    
    impulses(end + 1, k) = 0; %#ok<SAGROW> % save for plot
    impulses(end, i) = data.iota; %#ok<SAGROW> % save for plot
    
    % we've updated to the post-impact state, let's continue the
    % simulation.  We need to have Matlab do event detection again.  For
    % event detection, we set all impact constraints as active again.  The
    % dynamics are *not* affected and are not subject to any continuous
    % constraints.  InstantaneousCollision relies on CompositeRigidBody to
    % create the ode function for the continuous dynamics.
    % InstantaneousCollision only handles the computation of the pre- to
    % post-impact map when its fD function is called (see line 175).
    
    ic.setAp(bRT);
    implicit = @(q, qdot, t) deal(0, 0, -gcontact, 0);
    ic.PhysicalConstraints.ImplicitConstraints = implicit;
    
    % start the simulation again
    sol = odextend(sol, odefun, T);
end

% update the final time
T = sol.x(end);

%% Animate Rigid Body

env = Environment(subplot(1, 2, 1));
view(env.Axes, [0; 0; 2]);
xlabel('$x$ (m)', 'Interpreter', 'Latex')
ylabel('$y$ (m)', 'Interpreter', 'Latex')

%%
% You can control the speed of the animation here.  If you want to slow
% things down, try multiplying N by a factor of 3 or 5.
framerate = 20;
r = rateControl(framerate);
N = T * framerate;

root.createGraphics(env);
bodies = root.toArray();

% set up phase portrait
ax = subplot(1, 2, 2);
stems = stem(ax, sol.xe, nan(size(impulses)), 'filled');
xlim([0, T]);
ylim([min(impulses(:)) - 1, max(impulses(:)) + 1]);
axis square;
xlabel('$t$ time (seconds)', 'Interpreter', 'Latex');
ylabel('$\iota(t)$ impulse (Ns)', 'Interpreter', 'Latex');
legend('left wall', 'bottom wall', 'right wall', 'top wall');

% add path and set plot properties
limits = [[-wall-0.1, wall+0.1, -wall-0.1, wall+0.1], -0.1 3];
axis(env.Axes, limits, 'square')
env.Axes.Parent.WindowState = 'maximized';

te = sol.xe;
t = linspace(0, T, N - length(te));
t = sort([t te]);
ii = 0;
for i = 1:N
    x = deval(sol, t(i));
    for j = 1:n
        b = bodies(j);
        M = Math.T_inverse(b.T(x(j)));
        b.Graphics.moveGraphic(M);
    end
    
    if ismember(t(i), te)
        ii = ii + 1;
        for j = 1:k
            % only draw nonzero impulses
            iota = impulses(ii, j);
            iota(iota == 0) = nan;
            stems(j).YData(ii) = iota;
        end
    end
    
    waitfor(r);
end