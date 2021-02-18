function [qdd, data] = fD(obj, q, qd, t)

if nargin < 4
    t = -inf;
end

M = obj.CompositeRigidBody.M(q);
h = obj.CompositeRigidBody.h(q, qd);

p = obj.PhysicalConstraints;
v = obj.VirtualContraints;
b = obj.TransmissionMatrix;

if isempty(p)
    Ap = [];
    phip = [];
    k = 0;
else
    [Ap, phip] = p.calcImplicit(q, qd, t);
    k = size(Ap, 1);
end

if isempty(v) || isempty(b)
    Av = [];
    phiv = [];
    B = [];
    m = 0;
else
    [Av, phiv] = v.calcImplicit(q, qd, t);
    B = transpose(b.calcImplicit(q, qd, t));
    m = size(Av, 1);
end

n = length(q);

A = zeros(n + m + k);
b = zeros(n + m + k, 1);

A(1:n, 1:n) = M;
b(1:n) = -h;

if k > 0
    A(1:n, n+1:n+k) = transpose(Ap);
    A(n+1:n+k, 1:n) = Ap;    
    b(n+1:n+k) = -phip;
end

if m > 0
    A(1:n, n+k+1:n+k+m) = B;
    A(n + k + 1:n + k + m, 1:n) = Av;
    b(n + k + 1:n + k + m) = -phiv;
end

sol = A \ b;
qdd = sol(1:n);

if nargout > 1
    lambda = sol(n + 1:n + k);
    u = sol(n + k + 1:n + k + m);
    data = struct('M', M, 'h', h, ...
        'Ap', Ap,'phip', phip, 'lambda', lambda, ...
        'Av', Av, 'phiv', phiv, 'B', B, 'u', u);
end
end