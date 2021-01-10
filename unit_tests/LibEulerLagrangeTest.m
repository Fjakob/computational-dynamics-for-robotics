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
            pBlock = [x; 0];
            pBob = [x + L * sin(theta); -L * cos(theta)];
            % velocities
            qdot = [xdot; thetadot];
            vBlock = jacobian(pBlock, q) * qdot;
            vBob = jacobian(pBob, q) * qdot;
            % energy
            peBlock = g * M * pBlock(2);
            keBlock = 0.5 * M * transpose(vBlock)*vBlock;
            peBob = g * m * pBob(2);
            keBob = 0.5 * m * transpose(vBob)*vBob;
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
            Mexp = [m + M, m * L * cos(theta)
                m * L * cos(theta), m * L^2];
            cexp = [-m * L * sin(theta) * thetadot^2; 0];
            gexp = [0; m * g * L * sin(theta)];
            testCase.verifyEqual(qact, q);
            testCase.verifyEqual(qdotact, qdot);
            testCase.verifyEqual(Mact, Mexp);
            testCase.verifyEqual(cact, cexp);
            testCase.verifyEqual(gact, gexp);
        end
    end
end