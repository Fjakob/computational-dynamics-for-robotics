function [J, T_cj] = Jacobian(obj, q, i)
if nargin < 3
    i = 1;
end

constraints = obj.RigidBodyConstraints;
assert(i > 0 && i <= obj.K);

k = 6;
n = obj.N;
bodies = obj.Bodies;
parent = obj.Parent;

J = zeros(k, n);
[j, r_c, T_cb] = constraints{i, :};

% transform from {c} to {j}
T_cj = T_cb;
while j > 0
    % get body j
    b = bodies(j);
    A_j = b.A;
    
    % compute J(i, j)
    X_cj = Math.AdT(T_cj);
    J(i, j) = r_c * X_cj * A_j;
    
    % update transform from {c} to {j}
    T_cj = T_cj * b.T(q(j));

    % update j to continue up the path
    j = parent(j);
end
end