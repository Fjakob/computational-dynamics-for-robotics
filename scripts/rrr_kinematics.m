% RRR_KINEMATICS A script for animating the kinematics of a 3R robot arm.
%
%   Note:
%       We recommend running this script as a live script.
%
%   See also DEMO_EX3_LIBRARY_UPDATES.

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

%% The Robot Model
% Our goal is to animate the kinematics of a revolute-revolute-revolute
% (RRR) robot arm.  We'll fill out this script in two passes, in which
% we'll
%
% # add code to animate only the end-effector frame, and then
% # add code to animate the links and end effector.
%
% As a reference, you can view an image of the model below.

clear;
imshow('docs/media/rrr-robot.png')

%% Describing the Kinematic Model
% We can animate the kinematics of the end-effector frame M using
%
% * the lengths of each link $L_1$, $L_2$, and $L_3$,
% * the three screw (or joint) axes $S_1$, $S_2$, and $S_3$, and
% * the end-effector frame M,
%
% where all quantities are with respect to fixed frame {0}, our space
% frame.  Given the robot model, fill out the missing kinematic data.

% define link lengths
L1 = 2/3;
L2 = 2/3;
L3 = 2/3;

% define screws axes of revolute joints in {0} (i.e., {s}) coordinates
S1 = [0; 0; 1; 0; 0; 0];
S2 = [0; 0; 1; 0; -L1; 0];
S3 = [0; 0; 1; 0; -L1 - L2; 0];

% and their matrix representations
S1_mat = Math.r6_to_se3(S1);
S2_mat = Math.r6_to_se3(S2);
S3_mat = Math.r6_to_se3(S3);

% write the position of the origin of each frame relative to {0}
p1 = [0; 0; 0];
p2 = [L1; 0; 0];
p3 = [L1 + L2; 0; 0];
p4 = [L1 + L2 + L3; 0; 0];

% define the joint frames {1}, {2}, and {3} relative to {0} at q = 0
M1 = Math.Rp_to_T([], p1);
M2 = Math.Rp_to_T([], p2);
M3 = Math.Rp_to_T([], p3);

% define the end-effector frame M relative to {0} at q = 0
M = Math.Rp_to_T([], p4);

%% Create the Environment
env = Environment();

% create an alias to {s}
frame0 = env.SpaceFrame;

frame1 = Frame(frame0, M1);
frame1.Name = '1';
link1 = CoordVector(frame1, [L1; 0; 0]); % link 1 in {1} coordinates
link1.Color = 'red';

frame2 = Frame(frame0, M2);
frame2.Name = '2';
link2 = CoordVector(frame2, [L2; 0; 0]); % link 2 in {2} coordinates
link2.Color = 'green';

frame3 = Frame(frame0, M3);
frame3.Name = '3';
link3 = CoordVector(frame3, [L3; 0; 0]); % link 3 in {3} coordinates
link3.Color = 'blue';

% represent the end-effector as a frame relative to frame {0} at q = 0
eeframe = Frame(frame0, M);
eeframe.Name = 'M';

%% Run Animation
% Let's animate the RRR robot.  The value for |n| is large.  If the
% animation runs too slowly for your liking, you can reduce |n| to a
% smaller value like |n = 100|.

n = 500;
delta_t = 2 * pi / n;

% vectors of configurations and velocities
q = [0; 0; 0];
qdot = [0; 0; 0];

% expand axes to capture entire animation
% reduce clutter in output
env.Axes = 2 * [-1 1 -1 1 -1 1];
env.hide();
frame1.hideAxes();
frame2.hideAxes();
frame3.hideAxes();
eeframe.hideAxes();

snapshots = Utils.takeSnapshot(env); % save the current figure
for t = 0:n
    qdot(:) = 0;
    if t < n/3
        qdot(1) = 1;

    elseif t < 2/3 * n
        qdot(2) = 1;
    else
        qdot(3) = 1;
    end
    
    q = q + qdot * delta_t;
        
    % move frame using Product of Exponentials formula
    T1 = Math.expm6(S1_mat * q(1));
    T2 = Math.expm6(S2_mat * q(2));
    T3 = Math.expm6(S3_mat * q(3));
    
    T01 = T1;
    T02 = T01 * T2;
    T03 = T02 * T3;
    
    % update frame position
    frame1.moveGraphic(T01 * M1);
    frame2.moveGraphic(T02 * M2);
    frame3.moveGraphic(T03 * M3);
    eeframe.moveGraphic(T03 * M);
    snapshots = Utils.takeSnapshot(env, snapshots);
    drawnow();
end

% save a video
Utils.saveSnapshots(snapshots, 'rrr_kinematics.mp4');

%% Next Steps
% Create the three links of the 3R robot with lengths L1, L2, and L3.
% We'll once again represent all quantities in frame {0} coordinates.  In
% order to animate the links proceed as follows:
%
% * create transform matrices M1, M2, and M3 (see how we defined M)
% * to make this easier add points p1, p2, and p3 in a manner similar to
%    p4 when creating M1-M3
% * we placed the code for M1-M3 above the definition of M and p1-p3 above
%    the definition of p4 in the solution script
% * create Frame objects frame1, frame2, and frame3 (see eeframe)
% * define all frames relative to frame0 (we placed our code after frame0
%    is defined in the script)
% * if you want to copy the animated video, we named the frames '1',
%    '2', and '3' with link colors red, green, and blue, respectively.
% * for each frame {i}, add a CoordVector to the frame (replace i with the 
%    appropriate frame number, $i \in \{1, 2, 3\}$)
%
%   framei = Frame(frame0, Mi);
%   framei.Name = 'i';
%   linki = CoordVector(framei, [Li; 0; 0]); % link i in {i} coordinates
%   linki.Color = color of link i;
%
% To reduce visual clutter, we also added the following lines before the
% animation loop (remove the previous env.Axes and env.show commands)
%
%   env.Axes = 2 * [-1 1 -1 1 -1 1];
%   env.hide();
%   frame1.hideAxes();
%   frame2.hideAxes();
%   frame3.hideAxes();
%   eeframe.hideAxes();
%
% If you any help, euler_lagrange_simulation.m implements a version of this
% code.