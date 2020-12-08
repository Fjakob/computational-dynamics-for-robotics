classdef LibMathTest < matlab.unittest.TestCase
    % LibMathTest Tests functions in the LectureCDR Math package
    %   The tests cover the functions in the Math library that operate on
    %   6D spatial quantities and matrices in SE(3).  The 3D spatial
    %   quantities and SO(3) are implicitly tested through these
    %   higher-dimensional functions.
    %
    %   LibMathTest Methods:
    %       testR3ToLilSo3 - Tests conversion from R^3 to so(3)
    %       testAdjoint - Tests mapping from T to Ad(T)
    %       testExpc6WithAngularVelocity - Tests exponential coordinates
    %       testExpc6WithNoAngularVelocity - Tests exponential coordinates
    %       testExpm6PureRotation - Test matrix exp of zero pitch screw
    %       testExpm6PureTranslation - Test matrix exp of inf pitch screw
    %       testExpm6IdentityElement - Test matrix exp for identity mapping
    %       testR6ToLilSe3 - Test conversion from R^6 to se(3)
    %       testRAToB - Test construction of R_ba in SO(3) from vectors
    %       testRAToBCoplanar - Test construction of R_ba in SO(3)
    %       testRPToT - Test construction of (R, p) in SO(3) x R^3 to SE(3)
    %       testLilSe3ToR6 - Test conversion from se(3) to R^6
    %       testTInverse - Tests computation of the inverse of T in SE(3)
    %       testTToRp - Tests computation of the inverse of T in SE(3)
    %       testTx - Test multiplication of T in SE(3) to x in R^3
    %
    %   Note:
    %       The numerical tolerances for equality has default values that
    %       are used.  Certain tests require changing these defaults.  Read
    %       the matlab.unittest.qualifications.verifiable.verifyequal and
    %       related documenation on how to change default tolerances.
    %
    %   Example:
    %       runtests('LibMathTest')
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1
    
    methods (Test)
        function testR3ToLilSo3(testCase)
            % testR3ToLilSo3 Compares symbolic definition of w to [w].
            
            syms w1 w2 w3 real;
            w = [w1; w2; w3];
            actual = Math.r3_to_so3(w);
            expected = [0 -w3 w2; w3 0 -w1; -w2 w1 0];
            testCase.verifyEqual(actual, expected);
        end
        function testAdjoint(testCase)
            % testAdjoint Compares numeric output to known solution
            
            T = [1 0 0 1; 0 0 1 2; 0 -1 0 3; 0 0 0 1];
            actual = Math.adjoint(T);
            expected = [
                1  0  0  0  0  0;
                0  0  1  0  0  0;
                0 -1  0  0  0  0;
                0 -2 -3  1  0  0;
                3  1  0  0  0  1;
                -2  0  1  0 -1  0];
            testCase.verifyEqual(actual, expected);
        end
        function testExpc6WithAngularVelocity(testCase)
            % testExpc6WithAngularVelocity Compares to known solution
            %   This particular case tests non-zero angular velocity.  We
            %   test to make sure for screw S = [w; v] and angle theta
            %       - norm(w) = 1
            %       - theta = norm(V(1:3)), and
            %       - V = S * theta
            
            V = [1; 2; 3; 4; 5; 6];
            [S, theta] = Math.expc_to_axis_angle6(V);
            actual = S * theta;
            expected = V;
            testCase.verifyEqual(norm(S(1:3)), 1);
            testCase.verifyEqual(theta, norm(V(1:3)));
            testCase.verifyEqual(actual, expected);
        end
        function testExpc6WithNoAngularVelocity(testCase)
            % testExpc6WithNoAngularVelocity Compares to known solution
            %   This particular case tests zero angular velocity.  We
            %   test to make sure for screw S = [w; v] and angle theta
            %       - w = 0
            %       - norm(v) = 1
            %       - theta = norm(V(4:6)), and
            %       - V = S * theta
            
            V = [0; 0; 0; 4; 5; 6];
            [S, theta] = Math.expc_to_axis_angle6(V);
            actual = S * theta;
            expected = V;
            testCase.verifyEqual(norm(S(1:3)), 0);
            testCase.verifyEqual(norm(S(4:6)), 1);
            testCase.verifyEqual(theta, norm(V(4:6)));
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end
        function testExpm6PureRotation(testCase)
            % testExpm6PureRotation Compares to known solution
            %   This particular cases tests a transformation with zero
            %   translation.
            
            S = [0; 0; 1; 0; 0; 0];
            theta = pi / 2;
            se3 = Math.r6_to_se3(S * theta);
            actual = Math.expm6(se3);
            expected = [
                0 -1 0 0;
                1  0 0 0;
                0  0 1 0;
                0  0 0 1
                ];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end
        function testExpm6PureTranslation(testCase)
            % testExpm6PureTranslation Compares to known solution
            %   This particular cases tests a transformation with zero
            %   rotation.
            
            S = [0; 0; 0; 0; 5; 0];
            theta = 1;
            se3 = Math.r6_to_se3(S * theta);
            actual = Math.expm6(se3);
            expected = [
                1 0 0 0;
                0 1 0 5;
                0 0 1 0;
                0 0 0 1
                ];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end
        function testExpm6IdentityElement(testCase)
            % testExpm6IdentityElement Compares to known solution
            %   This particular cases tests for the identity
            %   transformation.
            
            S = [0; 0; 1; 0; 5; 0];
            theta = 0;
            se3 = Math.r6_to_se3(S * theta);
            actual = Math.expm6(se3);
            expected = [
                1 0 0 0;
                0 1 0 0;
                0 0 1 0;
                0 0 0 1
                ];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end        
        function testR6ToLilSe3(testCase)
            % testR6ToLilSe3 Compares to a known solution
            %   We test to make sure for screw V = [w; v]
            %       - [V] = [[w] v; 0 0]
            %       - [w] = -[w]^T
            
            V = [1; 2; 3; 4; 5; 6];
            V_mat = Math.r6_to_se3(V);
            v = V_mat(1:3, 4);
            w_mat = V_mat(1:3, 1:3);
            % is [w] skew symmetric? => [w] = -[w]^T
            isskew = w_mat == -transpose(w_mat);
            % is v in correct spot?
            isvel = v == V(4:6);
            result = all([isskew(:); isvel(:)]);
            testCase.verifyTrue(result);
        end
        function testRAToB(testCase)
            % testRAToB Compares to a known solution
            %   This case tests for rotation of noncoplanar vectors
            
            a = [1; 0; 0];
            b = [0; 0; 1];
            actual = Math.R_a_to_b(a, b);
            expected = [0 0 -1; 0 1 0; 1 0 0];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end
        function testRAToBCoplanar(testCase)
            % testRAToBCoplanar Compares to a known solution
            %   This case tests for rotation of coplanar vectors
            
            a = [1; 0; 0];
            b = [-1; 0; 0];
            actual = Math.R_a_to_b(a, b);
            expected = [-1 0 0; 0 -1 0; 0 0 1];
            testCase.verifyEqual(actual, expected, 'AbsTol', 1e-9);
        end     
        function testRPToT(testCase)
            % testRPToT Compares to a known solution
            
            R = [0.7071 0 0.7071; 0 1 0; -0.7071 0 0.7071];
            p = [1; 2; 3];
            actual = Math.Rp_to_T(R, p);
            expected = [0.7071 0 0.7071 1; 0 1 0 2; 
                -0.7071 0 0.7071 3; 0 0 0 1];
            testCase.verifyEqual(actual, expected);
        end
        function testLilSe3ToR6(testCase)
            % testLilSe3ToR6 Compares to a known solution
            
            V = [1; 2; 3; 4; 5; 6];
            actual = Math.se3_to_r6(Math.r6_to_se3(V));
            expected = V;
            testCase.verifyEqual(actual, expected);
        end
        function testTInverse(testCase)
            % testRPToT Compares to a known solution
            
            T = [1 0 0 1; 0 0 1 2; 0 -1 0 3; 0 0 0 1];
            actual = Math.T_inverse(T); 
            expected = [1 0 0 -1; 0 0 -1 3; 0 1 0 -2; 0 0 0 1];
            testCase.verifyEqual(actual, expected);
        end
        function testTToRp(testCase)
            % testRPToT Compares to a known solution
            
            T = [0.7071 0 0.7071 1; 0 1 0 2; -0.7071 0 0.7071 3; 0 0 0 1];
            [Ract, pact] = Math.T_to_Rp(T);
            Rexp = [0.7071 0 0.7071; 0 1 0; -0.7071 0 0.7071];
            pexp = [1; 2; 3];
            testCase.verifyEqual(Ract, Rexp);
            testCase.verifyEqual(pact, pexp);
        end        
        function testTx(testCase)
            % testLilSe3ToR6 Compares to a known solution
            
            x = [1; 0; 0];
            T = [0.7071 0 0.7071 1; 0 1 0 2; -0.7071 0 0.7071 -3; 0 0 0 1];
            actual = Math.Tx(T, x);
            expected = [1.7071; 2; -3.7071];
            testCase.verifyEqual(actual, expected);
        end
    end
end