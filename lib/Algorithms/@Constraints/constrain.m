function obj = constrain(obj, bRT)
% constraint Adds constraint row to the Jacobian
%   OBJ = constrain(OBJ, BRT) Adds up to m rows to the
%   constraint Jacobian, where m = length(BRT) and BRT is a m x
%   3 cell matrix, where each row is a cell array of the form
%       BRT{i, :} = {name, r, T},
%   where {i} represents the body-attached frame to name (a
%   rigid body in OBJ.Robot), r is the constraint in frame {c}
%   such that transform T = T_ic in SE(3), and the r represents
%   the constraint
%       r Vc = 0,
%   where Vc is the twist of frame {c} in {c} coordinates. If
%   name is found in OBJ.Robot, then constraint i is added to
%   the Jacobian such that J(i, j) = r * Aj, where Aj is
%   body j's screw axis in {i} coordinates.

m = size(bRT, 1);
[~, names] = obj.Robot.toMap();
b = 0;
for i = 1:m
    [n, R, T] = bRT{i, :};
    k = find(strcmp(names, n), 1);
    if isempty(k)
        warning('%s not found; skipping constraint %d.', n, k);
    else
        T = Math.T_inverse(T); % we want T = T_ci
        obj.RigidBodyConstraints = [obj.RigidBodyConstraints; {k, R, T}];
        obj.RigidBodyMap = [obj.RigidBodyMap; b + 1, b + size(R, 1)];
        b = b + size(R, 1);
    end
end
end