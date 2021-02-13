function tau = iD(obj, q, qd, qdd)
% iD Compute a robot's inverse dynamics.
%   TAU = iD(OBJ, Q, QD, QDD) Returns the generalized forces required to
%   generate the motion specified by generalized coordinates Q, velocity
%   QD, and acceleration QDD.  The generalized coordinates are linear
%   arrays that are internally converted into an associative array using
%   OBJ.Mapping.  The output TAU is a linear array where TAU(i) is the
%   generalized force applied to rigid body with name OBJ.Mapping{i}.

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 02/07/2021, Matlab R2020a, v1

map = obj.Mapping;
if isempty(map)
    warning('No mapping exists for this robot.  Set obj.Mapping.');
end

n = length(q);
root = obj.Robot;
z = zeros(n, 1);

q = containers.Map(map, q);
qd = containers.Map(map, qd);
qdd = containers.Map(map, qdd);
tau = containers.Map(map, z);

for c = root.Children
    recurse(c, tau, q, qd, qdd);
end

tau = transpose(cellfun(@(x) tau(x), map));
end

function tau = recurse(b, tau, q, qd, qdd)
p = b.Parent;

i = b.Name;
Ii = b.I;
Ai = b.A;
dAidt = b.dAdt;
Fext0 = b.Fext0;
T_ip = b.T(q(i));
X_ip = Math.AdT(T_ip);

T_i0 = T_ip * p.var('T0');
X_0i = Math.AdT(Math.T_inverse(T_i0));

vJ = Ai * qd(i);
Vi = X_ip * p.var('V') + vJ;

adVi = Math.adV(Vi);
vJdot = dAidt * qd(i) + Ai * qdd(i);
Vidot = X_ip * p.var('Vdot') + adVi * vJ + vJdot;

adTVi = transpose(adVi);
Fi = Ii * Vidot - adTVi * (Ii * Vi) - transpose(X_0i) * Fext0;

b.store('X', X_ip, 'T0', T_i0, 'V', Vi, 'Vdot', Vidot, 'F', Fi);

for c = b.Children
    recurse(c, tau, q, qd, qdd);
end

Fi = b.var('F');
tau(i) = transpose(Ai) * Fi;
if ~isempty(p.Parent)
    p.store('F', p.var('F') + transpose(X_ip) * Fi);
end
end