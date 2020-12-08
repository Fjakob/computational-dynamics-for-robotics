function y = Tx(T, x)
% TX Applies the transform in SE(3) to a vector in R^3.
%   Y = TX(T, X) returns a vector Y in R^3 such for T = [R p; 0 1] in
%   SE(3), Y = R * X + p.
%
%   Example:
%       x = [1; 0; 0];
%       T = [0.7071 0 0.7071 1; 0 1 0 2; -0.7071 0 0.7071 -3; 0 0 0 1];
%       y = Math.Tx(T, x)
%
%       >> [1.7071; 2; -3.7071]
%
%   See also T_TO_RP

% AUTHORS:
%   <------------ Add your info! ------------>
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

[R, p] = T decomposed;
%   * there's a function in the Math package that will do this for you
y = ???;
end