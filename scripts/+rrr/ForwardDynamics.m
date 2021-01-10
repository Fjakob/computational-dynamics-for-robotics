function qdd = ForwardDynamics(q, qdot, tau, params)
% FORWARDDYNAMICS Computes acceleration
% 	QDDOT = FORWARDDYNAMICS(Q, QDOT, TAU, PARAMS)

% ✨ Automatically generated using EulerLagrange.m. ✨
M = rrr.MassMatrix(q, params);
c = rrr.CoriolisCentripetalForces(q, qdot, params);
g = rrr.GravitationalForces(q, params);
qdd = M \ (tau - c - g);
end
