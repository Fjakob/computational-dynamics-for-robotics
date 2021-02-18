function [J, phi, h, hdot] = calcImplicit(obj, q, qdot, t)
k = obj.K;
n = obj.N;
bodies = obj.Bodies;
parent = obj.Parent;
map = obj.RigidBodyMap;
constraints = obj.RigidBodyConstraints;
e = obj.Epsilon;
Kp = obj.ProportionalGainMatrix / e / e;
Kv = obj.DerivativeGainMatrix / e;

if nargin < 3
    qdot = zeros(n, 1);
end
if nargin < 4
    t = -inf;
end

J = zeros(k, n);
h = zeros(k, 1);
hdot = zeros(k, 1);
phi = zeros(k, 1);

for i = 1:obj.M
    [j, Ri, T_cb] = constraints{i, :};
    
    b = bodies(j);
    ii = map(i, 1):map(i, 2);
    
    % rotatation from {b} to {0} in SE(3)
    Trot = Math.T_inverse(b.var('T0'));
    Trot(1:3, 4) = 0;
    
    % {c} in {b} with axes aligned with {0}
    T = Trot * T_cb;
    V_c = Math.AdT(T) * b.var('V');
    V_c(1:3) = 0; % frame is not rotating
    
    [Jij, Jijdot] = calcJij(b, Ri, V_c, T);
    
    % update J and perform (branch-induced) sparse matrix multiplication to
    % compute phi and hdot from Jij and Jijdot
    J(ii, j) = J(ii, j) + Jij;
    phi(ii) = phi(ii) + Jijdot * qdot(j);
    hdot(ii) = hdot(ii) + Jij * qdot(j);
    
    % switch to parent
    T = T * b.T(q(j));
    j = parent(j);
    while j > 0
        b = bodies(j);
        [Jij, Jijdot] = calcJij(b, Ri, V_c, T);
        
        J(ii, j) = J(ii, j) + Jij;
        phi(ii) = phi(ii) + Jijdot * qdot(j);
        hdot(ii) = hdot(ii) + Jij * qdot(j);
        
        % continue up the path
        T = T * b.T(q(j));
        j = parent(j);
    end
    
    T = Math.T_inverse(T);
    h(ii) = h(ii) + Ri * [0; 0; 0; T(1:3, 4)];
end

% add given terms
if k > 0
    [J2, phi2, h2, h2dot] = obj.ImplicitConstraints(q, qdot, t);
    J = J + J2;
    phi = phi + phi2;
    h = h + h2;
    hdot = hdot + h2dot;
else
    [J, phi, h, hdot] = obj.ImplicitConstraints(q, qdot, t);
end

% compute feedback control law/constraint stabilization terms
phi = phi + Kp * h + Kv * hdot;
end

function [Jij, Jijdot] = calcJij(b, R, V, T)
% transform from {c} to {j}
X = Math.AdT(T);

% compute J(i, j)
A = b.A;
Jij = R * X * A;

% compute Jdot(i, j)
dAdt = b.dAdt;
Vj = b.var('V');
Vrel = X * Vj - V;
Xdot = Math.adV(Vrel) * X;
Jijdot = R * Xdot * A + R * X * dAdt;
end