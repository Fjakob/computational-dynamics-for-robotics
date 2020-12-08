function [unitscrew, angle] = expc_to_axis_angle6(expc)
% EXPC_TO_AXIS_ANGLE6 Converts from exponential coordinates to axis-angle.
%   [UNITSCREW, ANGLE] = EXPC_TO_AXIS_ANGLE6(EXPC) returns the exponential
%   coordinate EXPC in R^6 in axis-angle form such that 
%       - EXPC = UNITSCREW * ANGLE, and either
%       - ANGLE = norm(EXPC(1:3)) if > 0 and norm(UNITSCREW(1:3)) = 1, or 
%       - ANGLE = norm(EXPC(4:6)) otherwise and norm(UNITSCREW(1:3)) = 1.
%
%   Note: 
%       *Beware* that EXPC = [0; 0; 0; 0; 0; 0] will produce a warning, but
%       computations will still continue.  The UNITSCREW will be a vector
%       of NaNs.
%
%       The "unit" screw is an abuse of terminology and should be taken to
%       mean a vector V = [v; w] normalized to either norm(w) or norm(v).
%
%   Example:
%       expc = [sqrt(1/3); sqrt(1/3); -sqrt(1/3); 1; 2; 3] * pi;
%       [axis, angle] = Math.expc_to_axis_angle6(expc)
%
%       >> axis = [0.5774; 0.5774; -0.5774; 1; 2; 3]
%          angle = 3.1416
%
%   See also EXPC_TO_AXIS_ANGLE6

w = expc(1:3);
v = expc(4:6);

% choose normalization factor
angle = ???;
%   * value depends on whether norm(w) is zero or not zero; maybe use an if
%     statement here?

if(angle == 0)
    warning('expc does not have a unique rotation axis; theta = 0.');
end

unitscrew = expc normalized to "unit" length;
end