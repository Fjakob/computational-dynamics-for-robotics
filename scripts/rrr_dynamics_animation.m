% RRR_DYNAMICS_ANIMATION Animates a 3R robot arm.
%
%   Note:
%       This script assumes the existance of an object, struct, package,
%       etc. named |rrr| that supports the use of calling a function
%       |ForwardDynamics| using dot notation in the animation loop.
%
%   See also +RRR RRR_DYNAMICS_SPATIAL and RRR_DYNAMICS_TRADITIONAL.

%% Model Parameters

clear;

m = 1;
L = 2/3;
r = L / 2;
Izz = 1/12 * m * L^2;
g = 9.81;

S1 = [0; 0; 1; 0; 0; 0];
S2 = [0; 0; 1; 0; -L; 0];
S3 = [0; 0; 1; 0; -2 * L; 0];

S1_mat = Math.r6_to_se3(S1);
S2_mat = Math.r6_to_se3(S2);
S3_mat = Math.r6_to_se3(S3);

p1 = [0; 0; 0];
p2 = [L; 0; 0];
p3 = [2 * L; 0; 0];
p4 = [3 * L; 0; 0];

M1 = Math.Rp_to_T([], p1);
M2 = Math.Rp_to_T([], p2);
M3 = Math.Rp_to_T([], p3);
M = Math.Rp_to_T([], p4);

%% Create the Environment
%   Draw the RRR robot.

env = Environment();

% the robot swings in the x-y plane; let's look down at it from the z-axis
view(env.Axes, [0; 0; 2]);

% create an alias to {s}
frame0 = env.SpaceFrame;

frame1 = Frame(frame0, M1);
frame1.Name = '1';
link1 = CoordVector(frame1, [L; 0; 0]); % link 1 in {1} coordinates
link1.Color = 'red';

frame2 = Frame(frame0, M2);
frame2.Name = '2';
link2 = CoordVector(frame2, [L; 0; 0]); % link 2 in {2} coordinates
link2.Color = 'green';

frame3 = Frame(frame0, M3);
frame3.Name = '3';
link3 = CoordVector(frame3, [L; 0; 0]); % link 3 in {3} coordinates
link3.Color = 'blue';

eeframe = Frame(frame0, M);
eeframe.Name = 'M';

% reduce visual clutter
env.Axes = 2.3 * [-1 1 -1 1 -1 1];
env.hide();
frame1.hideAxes();
frame2.hideAxes();
frame3.hideAxes();
eeframe.hideAxes();

%% Animate the Robot
%   Animate the RRR robot using an Euler integration method.

N = 500;
T = 5;

delta_t = T / N;

n = 3;
q = zeros(n, 1);
qdot = zeros(n, 1);
tau = zeros(n, 1);
params = [Izz  Izz  Izz  L  L  g m m m r r r];

snapshots = Utils.takeSnapshot(env); % save the current figure
for i = 1:N
    % solve for the accelerations and integrate up
    qddot = rrr.ForwardDynamics(q, qdot, tau, params);
    qdot = qdot + qddot * delta_t;
    q = q + qdot * delta_t;
    
    % update frame position
    T1 = Math.expm6(S1_mat * q(1));
    T2 = Math.expm6(S2_mat * q(2));
    T3 = Math.expm6(S3_mat * q(3));
    
    T01 = T1;
    T02 = T01 * T2;
    T03 = T02 * T3;
    
    frame1.moveGraphic(T01 * M1);
    frame2.moveGraphic(T02 * M2);
    frame3.moveGraphic(T03 * M3);
    eeframe.moveGraphic(T03 * M);
    
    drawnow();
    % add the frame so we can create an animation later
    snapshots = Utils.takeSnapshot(env, snapshots);
end

% save a video
Utils.saveSnapshots(snapshots, 'rrr_el.mp4');