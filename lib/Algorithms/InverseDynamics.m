% YOUR TODO LIST:
%   * We assume dynamics of the form: M(q) qdd + h(q, qd) = tau, where 
%     h(q, qd) = C(q, qd) * qdot + g(q).
%   + define InverseDynamics so that the class inherits from Algorithm
%   + keep tau = iD(obj, q, qd, qdd) as an abstract method (it doesn't hurt
%     to redefine in an abstract methods block for future maintainers).
%   + implement the following public methods
%       + h = h(obj, q, qd) - A function for computing the potential,
%         centripetal and Coriolis forces acting on the robot.  Your
%         code *must* use obj.iD to compute the output h.
%       + M = M(obj, q) - A function for computing the robot's mass matrix.
%         Your code *must* use obj.iD to compute the output M.
%       + qdd = fD(obj, q, qd, tau) - A function for computing the robot's
%         forward dynamics.  You *should* right your function in terms of
%         obj.M and obj.h.
%   * the class has no properties of its own
%   * the class does not need its own constructor.  Does a constructor
%     still get called?  Whose?
