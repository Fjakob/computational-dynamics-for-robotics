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
S1 = frame {1} joint (screw) axis in {0} coordinates
S2 = frame {2} joint axis in {0} coordinates
S3 = frame {3} joint axis in {0} coordinates

% and their matrix representations
S1_mat = se(3) representation of S1
%   * you should use the corresponding function in the Math package
S2_mat = se(3) representation of S2
S3_mat = se(3) representation of S3

% write the position of the origin of frame {4} relative to {0}
p4 = position of {4}'s origin relative to {0}

% define the end-effector frame M relative to {0} at q = 0
M = SE(3) representation of {4} relative to {0}
%   * you should use Math.Rp_to_T with p4 and [] as arguments

%% Create the Environment
env = Environment();

% create an alias to {s}
frame0 = env.SpaceFrame;


% represent the end-effector as a frame relative to frame {0}
eeframe = Frame(frame0, transform representing {4} relative to {0});
%   + also add a line to name the frame, 'M' would be a good choice

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
env.Axes = 3 * [-1 1 -1 1 -1 1];
env.show();

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
    T1 = exponential mapping of exponential coordinates S1 * q(1) to SE(3)
    T2 = exponential mapping of exponential coordinates S2 * q(2) to SE(3)
    T3 = exponential mapping of exponential coordinates S3 * q(3) to SE(3)
    
    % update frame position
    eeframe.moveGraphic(T04);
    %   * T04 = Product of Exponential formula in space form for
    %     end-effector frame = some function of T1, T2, T3, and M
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