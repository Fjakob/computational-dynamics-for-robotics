% DEMO_EX3_LIBRARY_UPDATES A quick tour of library updates as of Exercise 3
%
%   Note:
%       We recommend running this script as a live script.
%
%   See also ENVIRONMENT, ENVIRONMENTOBJECT, FRAME, COORDVECTOR, +Math,
%   UTILS.

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1


%% Changes to Environment
% 
% * Added properties SpaceFrame and Axes
% * Internally you are adding objects in the environment to SpaceFrame
% * SpaceFrame is like any other Frame object
% * Removed properties fig, R, p
% * Removed method toggleAxis

clear;
env = Environment();
env.SpaceFrame.show();

%%
% set axes limits of figure
env.Axes = [-3 3 -3 3 -2 2];

%%
env.hide() % wrapper function for SpaceFrame.hide()

%% Added EnvironmentObject
% In computer graphics speak, the Environment is a *scene* and we add a
% collection of *objects* to the scene.  Specifically, we add a collection
% of EnvironmentObjects to the Environment.  This will give us a common
% interface for animations and adding different types of objects to render
% in the Environment.
% 
% * EnvironmentObjects have a parent-child relationship to each other; you
%   can add a child EnvironmentObject to a parent EnvironmentObject.  All
%   of the child's transforms $T \in SE(3)$ are then relative to the
%   parent's frame.
% * An EnvironmentObject is a wrapper around the Transform object returned
%   from Matlab's hgtransform function.  In general, EnvironmentObject
%   would be a subclass of Transform.  This is not possible in Matlab.
% * You can create simple shapes using format strings
% * Another option is to use the Utils.m set of draw functions (e.g., draw,
%   drawFrame, drawArrow)

eo1 = EnvironmentObject(env);
eo2 = EnvironmentObject(eo1);

T = Math.Rps_to_T([], [0; 0; 3], 0.25 * [1; 1; 1]);
eo2.add('.', T); % creates a sphere
T = Math.Rps_to_T([], [3; 0; 3], 0.25 * [1; 1; 1]);
eo2.add('-', T); % creates a cylinder
T = Math.Rps_to_T([], [0; 3; 3], 0.25 * [1; 1; 1]);
eo2.add('<', T); % creates an arrowhead
T = Math.Rps_to_T([], [0; -3; 3], 0.25 * [1; 1; 1]);
eo2.add('>', T); % creates an arrowhead

eo3 = EnvironmentObject(env);
Utils.drawFrame(eo3);
T = Math.Rp_to_T([], [2; -2; 0]);
eo3.moveGraphic(T);

env.resetOutput;

%% Changes to Frame
% 
% * Changed constructor, no longer necessary to pass env; you can make any
%   graphics handle or EnvironmentObject the parent of a Frame object
% * Added properties T, Name
% * Added methods showAxes, hideAxes
% * Changed default colors for axes (x -> red, y -> green, z -> blue)
% * Frame is a subclass of EnvironmentObject
% * Removed properties R, p, name, color, and all Constant properties
% * Removed method delete, updateGraphics

env.show();

T = Math.expm6(Math.r6_to_se3([1; 0; 0; 0; 0; 0] * pi/2));
frame1 = Frame(env, T);
frame1.Color = 'red';
frame1.Name = '1';

T = Math.expm6(Math.r6_to_se3([1; 0; 1; 0; 3; 0] * 3*pi/4));
frame2 = Frame(frame1, T);
frame2.Color = '#15ff09'; % can use html color spec
frame2.Name = '2';

env.resetOutput;

%% Changes to CoordVector
% 
% * Changed constructor, no longer necessary to pass env; you can make any
%   graphics or EnvironmentObject handle the parent of a Frame object
% * The second parameter in setCoords updates the parent frame of the
%   CoordVector object; it can be any graphics or EnvironmentObject handle
% * Changed default colors for vector to default colors of surface(...)
% * Added properties Name
% * Added method moveGraphic (overrides superclass' method)
% * CoordVector is a subclass of EnvironmentObject
% * Removed properties name, color, and all Constant properties
% * Removed method delete, updateGraphics

p_2 = [1; 1; 0];
T = Math.Rp_to_T([], [-1; -3; 0]); % offset p_2 relative to parent frame
p = CoordVector(frame2, p_2, T);
p.Name = '$p_2$';

%% Location of a CoordVector
% Each method returns a transform in SE(3) or position vector in R^3
% relative to the referenced frame.  They each return T * p_2 in different
% coordinates.

% get coords in {s}; these two should be the same (well after completing a
% certain future Exercise problem)
p.getT_sb()
p.getCoords(env.SpaceFrame)

% get coords in {1}
p.getCoords(frame1)

% get coords in {2}; these two are the same
p.getCoords(frame2)
Math.Tx(T, p_2)

env.resetOutput;