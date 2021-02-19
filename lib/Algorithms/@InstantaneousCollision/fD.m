function [qd, data] = fD(obj, q, qd)

M = obj.CompositeRigidBody.M(q);
E = obj.CoefficientOfRestitution;
p = obj.PhysicalConstraints;

if isempty(p)
    J = [];
    k = 0;
else
    J = p.calcImplicit(q, qd);
    k = size(J, 1);
end

n = length(q);
A = zeros(n + k);
b = zeros(n + k, 1);

A(1:n, 1:n) = M;
b(1:n) = M * qd;

if k > 0
    A(1:n, n+1:n+k) = -transpose(J);
    A(n+1:n+k, 1:n) = J;
    b(n+1:n+k) = - E * J * qd;
end

sol = A \ b;
qd = sol(1:n);

if nargout > 1
    iota = sol(n + 1:n + k);
    data = struct('M', M, 'J', J, 'iota', iota);
end
end