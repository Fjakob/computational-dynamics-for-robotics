% DEMO_SINGLE_ROTATION A demo on how to represent a frame in space.
%   This script demonstrates how to perform a change of coordinates for a
%   vector defined in a body frame {b}.  It also shows how to use the core
%   LectureCDR library to set up a 3D environment and add frames and
%   coordinate vectors to it.
%
%   See also ENVIRONMENT, FRAME, COORDVECTOR, ROT, UTILS.

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 11/16/2020, Matlab R2020a, v22
%   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

%% Set the Matlab Path
% Set Matlab's path to include the LectureCDR library, scripts, and test
% files.  You can do this easily by running |cdr_addpath.m| in the
% LectureCDR root directory.  You have various options with how you want to
% execute this file.  A few options are
%
% * every time Matlab starts, see <matlab:doc('startup') startup>,
% * manually at the start of a new Matlab session, or
% * make LectureCDR/scripts your _Current Folder_, uncomment the line
% below, and execute the cell.

%run ../cdr_addpath.m;

%% Create an Environment
% The environment is a 3D 'physical' space with coordinates.  We assume
% that you have chosen an origin and length scale (e.g., inches, meters,
% light-years) for your *fixed space frame* {s}.  All additional *frames* and
% *vectors* that you add to the environment *are defined relative to* {s}.
%
% In practice, the environment is a Matlab figure (see
% <matlab:open('Environment.m') Environment>).  The frame {s} is defined as
% the origin of the figure's graphical coordinate system.  The graphical
% representation of any entities that can be added to the environment, like
% frames and vectors, draw themselves in the environment's figure.

clear;
env = Environment();

%% Showing and Hiding Graphics
% You can show or hide the graphical representation of the environment, a
% frame, or a vector.  This can be helpful in reducing the clutter of a
% crowded figure.  All graphics display themselves by default with the
% exception of the environment, which is represented as a frame {s}.
% Execute the following cell to show {s}.  Afterwards, hide it by
% calling |env.hide()|.  We will assume for the rest of this
% tutorial that {s} is hidden.

env.show()

%%
env.hide() % don't forget to hide {s} again!

%% Adding a Frame to the Environment
% We call |Frame| to create an instance of the class
% <matlab:open('Frame.m') Frame>.  The result is an object |c| of type
% Frame. You can think of a class object as a container filled with
% variables and functions associated with it. You can access the variables
% and functions using dot notation (e.g., c.color).
%
% In this example, we create a frame {c} that is coincident with the space
% frame {s}.

R_sc = eye(3); % the rotation matrix that defines {c} relative to {s}

c = Frame(env, R_sc);
c.color = Utils.GREEN;
c.name = 'c';

%% Create a Rotated Frame Relative to {s}
% In this example, we create a frame {b} relative to {s}.  The frame {b} is
% rotated by $30^\circ$ about the $\hat{y}_s$ axis.  Notice how we've just
% made use of one of the methods you defined in an earlier problem in
% |Rot.y|!  If you haven't gotten |Rot.y| to work yet, you can replace the
% definition for |R_sb| with
%
% R_sb = [cos(beta),  0, sin(beta);
%        0,           1,         0;
%        -sin(beta),  0, cos(beta)];

beta = 30 * pi / 180;
R_sb = Rot.y(beta);
b = Frame(env, R_sb);
b.name = 'b';

%% Rotation Matrices in Action
% Echoing the values of R_sb to the command window is a simple visual check
% to see if the columns of R_sb are indeed the unit vectors of {b}
% expressed in {s}.  Try to verify this by clicking the dot that appears at
% the end of axis $\hat{x}_b$'s arrow in the plot; the resulting data tip
% will equal the first column of |R_sb|.  If you're using the live editor,
% you might have to click the figure to give it focus or pop the figure out
% of the editor to select the point.

R_sb

%%
% We can also see that the columns of the inverse rotation matrix $R_{bs} =
% R_{sb}^{-1} = R_{sb}^T$ are the unit vectors of {s} expressed in {b}.

R_bs = R_sb'

%%
% For now, let's ignore the fact that there exists a graphical coordinate
% system in our plot.  Let's consider frames {s} and {b} in physical space.
% They are both fixed inertial frames and are both relative descriptions of
% the other. Neither frame is more important than the other. In physical
% space, the frame {s} has been arbitrarily chosen as our origin in the
% environment.  Now, if Matlab had chosen a different representation for
% its graphical coordinates, then in an alternate universe {b} might be the
% practical choice for defining our origin.  We rotate the environment, so
% we can see this more easily.  Notice that {b} now appears to align with
% our perception of a frame defined at the origin.
%
% Note: *If you're running this as a live script*, you might have to
% execute the next cell and then run this cell in order to see the view
% change with $\hat{z}_b$ pointing up.  If that doesn't work, then you
% might have to run the script in the original .m file.
%
% *After you are done with this cell, don't forget that you must run the
% next cell in order to restore the up direction in future plots.*

bizarro_z = R_sb(:, 3)'; % orientate the environment with this z axis as up.
camup(bizarro_z)

%%
% But this is just the environment in bizarro world, so let's rotate back.

camup([0, 0, 1])

%% Viewing Properties and Methods of a Class
% The variables in a Matlab class are known as properties and the functions
% are called methods.  You can use the built-in functions
% <matlab:doc('properties') properties> and <matlab:doc('methods') methods>
% to list them.  You can also find the current values of the properties by
% echoing the value of an object to the command window. Execute the
% following cell to see the properties and methods associated with the
% class |Utils| and the Frame object |b| as well as the current property
% values for |b|.

%%
% example for a class
properties Utils
methods Utils

%%
% example for an object
properties(b)
methods(b)
b

%% Using Properties and Methods of a Class
% Let's use the color constants in the <matlab:open('Utils.m') Utils> class
% to set the color of {b} to red.

b.color = Utils.RED;

%% Adding a Vector to the Environemnt
% We call |CoordVector| to create an instance of the class
% <matlab:open('CoordVector.m') CoordVector>.  The result is an object |v1|
% of type CoordVector.  The object internally represents a free vector with
% coordinates in {s}. In this example, |v1| internally represents the
% coordinate vector |v_b| in {s} coordinates.  It does this by applying the
% appropriate transformation given frame {b} and |v_b| as inputs (see
% <matlab:open('CoordVector.m') CoordVector>).

v_b = [0.5; 0; 0.5];
v1 = CoordVector(env, b, v_b);
v1.color = Utils.BLACK;
v1.name = '$v1$';

%% Incorrectly Representing the Same Vector in Two Different Frames
% Let's try to represent the free vector $v$ in {c} using the same numeric
% values we used for |v_b|. Taking a closer look, we'll see that |v2|
% points in a different direction.  Why?  Even though they have the same
% numeric values, do |v1| and |v2| represent the same coordinate free
% vector $v$ in the underlying space?  In other words, do they have the
% same direction and magnitude?

v_c = v_b;
v2 = CoordVector(env, c, v_c);
v2.color = Utils.GRAY;
v2.name = '$v2$';

%%
% By applying |R_cb|, we properly represent the same $v$ in {b} coordinates
% and {c} coordinates.

R_cb = R_sb; % {c} and {s} are coincident frames.
v_c = R_cb * v_b;
v2.setCoords(c, v_c);