classdef LibEulerLagrangeTest < matlab.unittest.TestCase
    % LibEulerLagrangeTest Tests the LectureCDR EulerLagrange class.
    %
    %   LibEulerLagrangeTest Methods:
    %       testEulerLagrange - Tests the equations of motion
    %
    %   Example:
    %       runtests('LibEulerLagrangeTest')
    
    % AUTHORS:
    %   <------------ Add your info! ------------>
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1
    
    methods (Test)
        function testEulerLagrange(testCase)
            % testEulerLagrange Tests the equations of motion of a
            % cart-pendulum system.
            
            syms x theta xdot thetadot g m M L real
            % positions
            q = [x; theta];
            pBlock = planar location of block in terms of x and theta
%               * pBlock \in R^2            
            pBob = planar location of block in terms of x and theta
%               * pBob \in R^2            
            % velocities
            qdot = [xdot; thetadot];
            vBlock = velocity of block (vBlock \in R^2)
%               * hint use jacobian(....) and qdot to compute values
            vBob = velocity of bob (vBob \in R^2)
%               * hint use jacobian(....) and qdot to compute values
            % energy
            peBlock = ???
%               * write the potential energy of the block with respect to 
%                 the symbolic variables x, theta, xdot, thetadot, g, m, M,
%                 and L.  Do the same for the other variables below.
            keBlock = ???
%               * write the kinetic energy of the block
            peBob = ???
%               * write the potential energy of the pendulum bob
            keBob = ???
%               * write the kinetic energy of the pendulum bob            
            pe = peBlock + peBob;
            ke = keBlock + keBob;            
            % get computed values
            el = EulerLagrange(ke, pe, q, qdot);
            qact = el.GeneralizedCoordinates;
            qdotact = el.GeneralizedVelocities;
            Mact = simplify(el.MassMatrix);
            cact = simplify(el.CoriolisCentripetalForces);
            gact = simplify(el.GravitationalForces);
            % compare against expected values
            Mexp = ???;
%               * you've computed this value!  Input your solution from the 
%                 corresponding exercise problem
            cexp = ???;
%               * input your solution from exercise problem
            gexp = ???;
%               * input your solution from exercise problem            
            testCase.verifyEqual(that qact is equal to q);
%               + add code to verify qdotact == qdot            
%               + add code to verify Mact == Mexp
%               + add code to verify cact == cexp            
%               + add code to verify gact == gexp
        end
    end
end