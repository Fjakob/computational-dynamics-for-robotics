classdef Algorithm < handle
    % Algorithm Computes the dynamics of a RigidBody tree.
    %   An Algorithm is an abstract class for computing the dynamics of a
    %   robot of the form
    %       M(q) qdd + h(q, qd) = tau,
    %   where, if necessary, we assume
    %       h(q, qd) = C(q, qd) * qd + g(q).
    %
    %   Algorithm Properties:
    %       Robot - The root node of a RigidBody tree
    %
    %   Algorithm Methods:
    %      Algorithm - The constructor for this class
    %      iD - An abstract method for computing inverse dynamics
    %      fD - An abstract method for computing forward dynamics
    %      odeFun - Returns a function handle for use in Matlab's ODE suite
    %
    %   See also InverseDynamics and ForwardDynamics
    
    % AUTHORS:
    %   <------------ Add your info! ------------>
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/31/2021, Matlab R2020a, v1
    
    properties
        Robot % the root of a RigidBody tree
    end
    methods (Abstract)
        tau = iD(obj, q, qd, qdd) % computes the inverse dynamics
        qdd = fD(obj, q, qd, tau) % computes the forward dynamics
    end
    methods
        function obj = Algorithm(robot)
            obj.Robot = robot;
        end
        function set.Robot(obj, robot)
            % set.Robot Sets the Robot property and calls setRobot.
            obj.Robot = robot;
            obj.setRobot(robot);
        end
        function xd = odeFun(obj, taufun)
            % odeFun Returns a function handle for use in Matlab's ODE
            % suite.
            %   XD = odeFun(OBJ) Returns a handle to the robot's unforced
            %   dynamics (\tau = 0)
            %   XD = odeFun(OBJ, TAUFUN) Returns a handle to the robot's
            %   dynamics with force function TAUFUN = TAUFUN(t, q, qd),
            %   where t is the current time, q is the configuration of the
            %   robot at time t, and qd is the velocity of the robot at
            %   time t.
            %
            %   See also Algorithm>odefun
            
            if nargin < 2
                xd = @(t, x) odefun(obj, t, x);
            else
                xd = @(t, x) odefun(obj, t, x, taufun);
            end
        end
    end
    methods (Access = protected)
        function obj = setRobot(obj, robot) %#ok<INUSD>
            % setRobot Perform additional tasks whenever the robot is
            % updated.  Override with custom code in subclass if necessary.
        end
    end
end

function xdot = odefun(obj, t, x, taufun)
% odefun A parameterizable function for use in Matlab's ODE solve suite
%	XDOT = ODEFUN(OBJ, T, X) Returns XDOT based on time T, state X, and
%	OBJ's forward dynamics function.  The value of XDOT represents the
%	unforced dynamics ($M(q) + h(q, \dot{q}) = 0$).
%
%	XDOT = ODEFUN(__, TAUFUN) Same as above but the forcing function TAUFUN
%	is used to compute the input force $\tau = TAUFUN(T, Q, QD)$, where X =
%	(Q, QD).  The value of XDOT reflects the additional forces applied to
%	the system.
%
%   See also Algorithm.odeFun

nx = length(x);
nq = nx / 2;
q = x(1:nq);
qd = x(nq+1:nx);
if nargin < 4 || isempty(taufun)
    tau = zeros(n, 1);
else
    tau = taufun(t, q, qd);
end
xdot = [qd; obj.fD(q, qd, tau)];
end