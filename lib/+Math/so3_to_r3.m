function w = so3_to_r3(wmat)
% SO3_TO_R3 Convert [w] in so(3) into w in R^3.
%   W = SO3_TO_R3(WMAT) returns the R^3 vector representation of WMAT in
%   so(3).
%
%   Example:
%       syms w1 w2 w3 real;
%       wmat = [0 -w3 w2; w3 0 -w1; -w2 w1 0];
%       w = Math.so3_to_r3(wmat)
%
%       >> [w1; w2; w3]
%
%   See also R3_TO_SO3

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

w = [wmat(3, 2); wmat(1, 3); wmat(2, 1)];
end