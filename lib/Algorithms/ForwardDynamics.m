% YOUR TODO LIST:
%   * We assume dynamics of the form: M(q) qdd + h(q, qd) = tau, where 
%     h(q, qd) = C(q, qd) * qdot + g(q).
%   + define ForwardDynamics so that the class inherits from Algorithm
%   + keep qdd = fD(obj, q, qd, tau) as an abstract method (it doesn't hurt
%     to redefine in an abstract methods block for future maintainers).
%   + implement the following public methods
%       + a = Minvh(obj, q, qd) - A function for computing the acceleration 
%         due to potential, centripetal and Coriolis forces acting on the 
%         robot.  Your code *must* use obj.fD to compute the output a.
%       + Minv = Minv(obj, q) - A function for computing the inverse of the
%         robot's mass matrix.  Your code *must* use obj.iD to compute the 
%         output Minv.
%       + tau = iD(obj, q, qd, qdd) - A function for computing the robot's
%         inverse dynamics.  You *should* right your function in terms of
%         obj.Minv and obj.Minvh.
%   * the class has no properties of its own
%   * the class does not need its own constructor.  Does a constructor
%     still get called?  Whose?
