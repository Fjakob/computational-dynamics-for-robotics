function R = R_a_to_b(a, b)
% R_A_TO_B Computes a rotation matrix from vector A to B.
%   R = R_A_TO_B(A, B) returns a rotation matrix R in SO(3) that rotates
%   the vector A in R^3 into the vector B in R^3 such that B = R * A.
%
%	Example:
%       a = [1; 0; 0];
%       b = [0; 0; 1];
%       R = Math.R_a_to_b(a, b)
%
%       >> [0 0 -1; 0 1 0; 1 0 0];

na = norm(a);
nb = norm(b);

assert(na > 0 && nb > 0);

a = a / na;
b = b / nb;
w = cross(a, b);

d = dot(a, b);
n = norm(w);

% use of atan2 taken from https://groups.google.com/g/
%   comp.soft-sys.matlab/c/zNbUui3bjcA/m/zfxWhJnhgLMJ
theta = atan2(n, d);

if n > 0
    w = w / n;
else
    % vectors are coplanar; need to chose different axis
    w = [1; 0; 0]; % try the x axis
    if dot(w, a) == 1
        % won't work a and w are parallel
        w = [0; 1; 0]; % go with y axis
    end
    w = cross(a, w);
    w = w / norm(w);
end

so3 = Math.r3_to_so3(w * theta);
R = Math.expm3(so3);
end