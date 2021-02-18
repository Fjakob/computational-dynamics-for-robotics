function R = R(expc3, theta)
% ROT Computes the rotation in SO(3) using exponential coordinats in R^3.
%   R = ROT(EXPC3) returns a matrix R in SO(3) given the exponential
%   coordinate EXPC3, which is the product of an axis \hat{w} and the
%   amount of rotation about the axis \theta.
%
%   R = ROT(axis, angle) same as above but with expc3 written separates as
%   an axis and an angle.
%
%   Example:
%

if nargin >= 2
    if ischar(expc3)
        expc3 = transpose(0:2 == (expc3 - 'x'));
    end
    expc3 = expc3 * theta;
end

so3 = Math.r3_to_so3(expc3);
R = Math.expm3(so3);
end