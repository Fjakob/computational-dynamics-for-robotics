% ROT Documentation pending
classdef Rot
    methods (Static)
        function w_mat = skew(w)
            % SKEW returns the so(3) representation of W as a
            % skew-symmetric matrix.
            %
            %   EXAMPLE:
            %       syms x1 x2 x3 real;
            %       w = [x1; x2; x3];
            %       Rot.skew(w)
            %       >> [0 -x3 x2; x3 0 -x1; -x2 x1 0]
            % ------------- ENTER YOUR CODE HERE -------------
            % 	add lines and change variable names as needed/preferred
            w_mat = ???;
        end
        function w = deskew(w_mat)
            % DESKEW returns the vector representation of the
            % skew-symmetric matrix W_MAT.
            w = [w_mat(3, 2); w_mat(1, 3); w_mat(2, 1)];
        end
        function R = axisangle(w_hat, theta)
            % AXISANGLE returns a rotation of THETA radians about the unit
            % vector W.
            % ------------- ENTER YOUR CODE HERE -------------
            % 	add lines and change variable names as needed/preferred
            w_mat = Rot.skew(w_hat);
            R = ???;            
        end
        function R = x(theta)
            % X returns a rotation of THETA radians about the coordinate
            % x-axis.
            %
            %   See also Y and Z.
            % ------------- ENTER YOUR CODE HERE -------------
            % 	add lines and change variable names as needed/preferred
            R = ???;
        end
        function R = y(theta)
            % Y returns a rotation of THETA radians about the coordinate
            % y-axis.
            %
            %   See also X and Z.
            % ------------- ENTER YOUR CODE HERE -------------
            % 	add lines and change variable names as needed/preferred
            R = ???;
        end
        function R = z(theta)
            % Z returns a rotation of THETA radians about the coordinate
            % z-axis.
            %
            %   See also X and Y.
            % ------------- ENTER YOUR CODE HERE -------------
            % 	add lines and change variable names as needed/preferred
            R = ???;
        end
        function R = cardan(alpha, beta, gamma)
            % CARDAN returns a rotation about the roll-pitch-yaw axes.
            %
            %   See also X, Y, and Z.
            R = Rot.z(gamma) * Rot.y(beta) * Rot.x(alpha);
        end        
        function R = froma2b(a, b)
            % FROMA2B returns a rotation matrix that rotates the vector A
            % into the vector B.  That is R satisfies B = R * A.
            na = norm(a);
            nb = norm(b);
            
            assert(na > 0 && nb > 0);
            
            a = a / na;
            b = b / nb;
            w = cross(a, b);
            
            d = dot(a, b);
            n = norm(w);
            theta = atan2(n, d);
            % https://groups.google.com/g/
            %   comp.soft-sys.matlab/c/zNbUui3bjcA/m/zfxWhJnhgLMJ
            
            if n > 0
                w = w / n;
            else
                % need to chose different axis
                w = eye(3, 1); % try the x axis
                if dot(w, a) == 1
                    % won't work a and w are parallel
                    w = w(end:-1:1); % go with z axis
                    fprintf('here! %f', w)
                end
                w = cross(a, w);
                w = w / norm(w);
            end
            
            R = Rot.axisangle(w, theta);
        end
    end
end