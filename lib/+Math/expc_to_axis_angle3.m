function [unitAxis, angle] = expc_to_axis_angle3(expc)
% EXPC_TO_AXIS_ANGLE3 Converts from exponential coordinates to axis-angle.
%   [UNITAXIS, ANGLE] = EXPC_TO_AXIS_ANGLE3(EXPC) returns the exponential
%   coordinate EXPC in R^3 in axis-angle form such that 
%       - EXPC = UNITAXIS * ANGLE,
%       - norm(UNITAXIS) = 1, and 
%       - ANGLE = norm(EXPC).
%
%   Note: 
%       *Beware* that EXPC = [0; 0; 0] will produce a warning, but
%       computations will still continue.  The UNITAXIS will be a vector of
%       NaNs.
%
%   Example:
%       expc = [sqrt(1/3); sqrt(1/3); -sqrt(1/3)] * pi;
%       [axis, angle] = Math.expc_to_axis_angle3(expc)
%
%       >> axis = [0.5774; 0.5774; -0.5774]
%          angle = 3.1416
%
%   See also EXPC_TO_AXIS_ANGLE6

angle = norm(expc(1:3));
if(angle == 0)
    warning('expc does not have a unique rotation axis; theta = 0.');
end
unitAxis = expc / angle;
end