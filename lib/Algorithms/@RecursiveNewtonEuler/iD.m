function tau = iD(obj, q, qd, qdd)
% iD Compute a robot's inverse dynamics.
%   TAU = iD(OBJ, Q, QD, QDD) Returns the generalized forces required to
%   generate the motion specified by generalized coordinates Q, velocity
%   QD, and acceleration QDD.

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 02/07/2021, Matlab R2020a, v1

n = obj.N;
bodies = obj.Bodies;
parent = obj.Parents;
tau = zeros(n, 1);
for i = 1:n
    b = bodies(i);
    Ii = b.I;
    Ai = b.A;
    dAidt = b.dAdt;
    Fext0 = b.Fext0;
    T_ip = b.T(q(i));
    X_ip = Math.AdT(T_ip);
    
    if parent(i) == 0
        p = obj.Robot;
    else
        p = bodies(parent(i));
    end
    
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
end
for i = n:-1:1
    b = bodies(i);
    Ai = b.A;
    Fi = b.var('F');
    tau(i) = transpose(Ai) * Fi;
    k = parent(i);
    if k > 0
        X_ip = b.var('X');
        p = bodies(k);
        p.store('F', p.var('F') + transpose(X_ip) * Fi);
    end
end
end
