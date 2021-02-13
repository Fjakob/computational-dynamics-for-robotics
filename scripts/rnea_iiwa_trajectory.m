% RNEA_IIWA_TRAJECTORY A script for computing the torques that generate a
% desired trajectory.
%
%   The demo is built upon the Matlab generalized inverse kinematics demo:
%   openExample('robotics/GeneralizedInverseKinematicsExample')

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 02/09/2021, Matlab R2020a, v1

clear;

%% Load the Robot Arm
%   The robot arm consists of a 7-dof robot arm, a world frame and two
%   end-effector frames that are represented as links with zero mass.

dir = what('ext_lib').path;
urdf = fullfile(dir, 'iiwa_description', 'urdf', 'iiwa14.urdf');
world = RigidBody.fromUrdf(urdf);

%% Add Cup and Floor
% Let's mimic the Matlab demo code and add our own cup and floor; these are
% RigidBodies with zero spatial inertias and unit twists with world as
% their parent.

cupHeight = 0.2;
cupRadius = 0.05;
cupPosition = [-0.5, 0.5, cupHeight/2];
cupScale = [cupRadius, cupRadius, cupHeight];
T_worldcup = Math.Rp_to_T([], cupPosition);

cup = RigidBody('cup');
cup.set('Parent', world, 'M', T_worldcup);

T = Math.Rps_to_T([], [], cupScale);
Draw.what(cup.Link.RootGraphic, '-', T, [], {'FaceColor', 'Blue'});

floorPosition = [-0.2; 0.2; 0];
T_worldfloor = Math.Rp_to_T([], floorPosition);
floor = RigidBody('floor');
floor.set('Parent', world, 'M', T_worldfloor);
floorScale = [1, 1, eps];
T = Math.Rps_to_T([], [], floorScale);
Draw.what(floor.Link.RootGraphic, '#', T, [], {'FaceColor', '#888'});

%% Load Final Time and Waypoints
%   rnea_gravity_compensation.mat contains the final time |T| and waypoints
%   |q_waypoints| of a trajectory computed from the Matlab's generalized
%   inverse kinematics solver demo. You can read about the demo online:
%   robotics/ug/plan-a-reaching-trajectory-with-kinematic-constraints.html

waypoints = load('rnea_iiwa_trajectory.mat');

%%
% pad waypoints to length of the robot
%   Note:
%       q, qd, qdd are in R^7, we have 12 links in world (cup + floor + 2
%       frames associated with the end effector + robot base + robot
%       links), so we need these quantities to be in R^12.  The order of
%       the links can be inferred from world.toArray().Name

z = zeros(1, length(waypoints.t));
waypoints.q = [z; waypoints.q; z; z; z; z];

%%
%   Compute time and time steps
T = waypoints.t(end);
rate = 15;
N = rate * T;
t = linspace(0, T, N);

%% Compute Interpolated Motion Trajectories
n = size(waypoints.q, 1);
qpp = spline(waypoints.t, waypoints.q);
qdotpp = qpp;
qddotpp = qpp;

%%
%   Compute derivatives of polynomial, code modified from Matlab Central's
%   forum: https://www.mathworks.com/matlabcentral/answers/276471

D = diag([3, 2, 1], 1);
qdotpp.coefs = qpp.coefs * D;
qddotpp.coefs = qpp.coefs * D^2;

%%
%   Assign motion trajectories

nq = size(waypoints.q, 1);
q = ppval(qpp, t);
qd = ppval(qdotpp, t);
qdd = ppval(qddotpp, t);

%% Animate Trajectory
% For background information on the trajectory and how it was constructed
% read:
% robotics/ug/plan-a-reaching-trajectory-with-kinematic-constraints.html

env = Environment;
env.SpaceFrame.add(world.LinkTransform.RootGraphic);
env.resetOutput;
set(gcf, 'WindowState', 'maximized');

bodies = world.toArray();
B = length(bodies);

for i = 1:N
    for j = 1:B
        T = Math.T_inverse(bodies(j).T(q(j,i)));
        bodies(j).LinkTransform.moveGraphic(T);
    end
    drawnow;
end

%% Compute Torques that Would Generate the Trajectory
% Use the RNEA algorithm to compute the applied torques required to general
% the motion.  How can you test your code to ensure that your function is
% working correctly (at least for this use case)?  Consider what the
% equations of motion \tau = M(q) qdd + h(q, qd) must equal if you plugged
% your computed value of torques back into the equation.
%
% Note:
%   Don't forget to initialize the root to what we've been describing as
%   the "typical" values to the RNEA.
%
%   You can call either implementation of your RNEA algorithm (or both!)


rnea = RecursiveNewtonEulerRecursion(world, {world.toArray().Name});
% rnea = RecursiveNewtonEuler(world);
tau = zeros(nq, N);

error = zeros(N);

V0 = zeros(6,1);
Vdot0 = [zeros(3, 1); 0; 9.81; 0];
T0 = eye(4);
world.store('V', V0, 'Vdot', Vdot0, 'T0', T0);

for i = 1:N
    tau(:,i) = rnea.iD(q(:,i), qd(:,i), qdd(:,i));
    
    e = rnea.M(q(:,i)) * qdd(:,i) + rnea.h(q(:,i), qd(:,i)) - tau(:,i);
    error(i) = norm(e);
end

subplot(2,2,1)
plot(t, q')
title('t vs. q(t)');
legend(world.toArray().Name, 'Interpreter', 'none');
subplot(2,2,2)
plot(t, error)
title('t vs. ||error(t)||');
subplot(2,2,[3 4])
plot(t, tau)
title('t vs. \tau(t)');