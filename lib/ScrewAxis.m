classdef ScrewAxis < EnvironmentObject
    properties (SetAccess = private)
        UnitScrew
        MovingFrame
        Axis
    end
    methods
        function obj = ScrewAxis(parent, S, T)
            myGraphics = hgtransform('Parent', []);
            obj@EnvironmentObject(parent, myGraphics);
            obj.MovingFrame = Frame(myGraphics, eye(4));
            obj.Axis = CoordVector(myGraphics, [0; 0; 0]);
            if nargin < 3
                obj.setScrew(S, eye(4));
            else
                obj.setScrew(S, T);
            end
        end
        
        function obj = setScrew(obj, S, T)
            if nargin < 3
                T = eye(4);
            end
            S = Math.AdT(T) * S;
            if norm(S(1:3)) > 0
                axis = S(1:3);
            else
                axis = S(4:6);
            end
            obj.UnitScrew = S;
            obj.Axis.setCoords(obj.MyGraphics, axis, T);
        end
        function path = visualize(obj, theta)
            if nargin < 2 || isscalar(theta)
                if nargin < 2
                    theta = 50;
                end
                n = theta;
                theta = linspace(0, 2*pi, n);
                theta = [theta flip(theta)];
            end
            M = obj.T;
            Ma = obj.Axis.T;
            S = obj.UnitScrew;
            path = animatedline();
            Smat = Math.r6_to_se3(S);
            for t = theta
                T = Math.expm6(Smat * t) * M;
                obj.moveGraphic(T);
                obj.Axis.moveGraphic(Math.T_inverse(T) * Ma);
                T(1:3, 4);
                addpoints(path, T(1, 4), T(2, 4), T(3, 4));
                drawnow;
            end
        end
    end
    methods (Static)
        function obj = fromAxisPitchPos(parent, axis, pitch, T)
            if nargin < 4
                T = eye(4);
            end
            if isinf(pitch)
                w = [0; 0; 0];
                v = axis;
            else
                w = axis;
                v = pitch * w;
            end
            S = [w; v];
            obj = ScrewAxis(parent, S, T);
        end
        function [obj, thetadot] = fromTwist(parent, V, T)
            %
            %   [obj, theta] = fromTwist(parent, V, T)
            %   [obj, thetadot] = fromTwist(parent, V, T)
            
            [S, thetadot] = Math.expc_to_axis_angle6(V);
            if nargin < 3
                if norm(S(1:3)) == 0
                    T = eye(4);
                else
                    s = S(1:3);
                    v = S(4:6);
                    pos = Math.r3_to_so3(v) * s;
                    T = Math.Rp_to_T([], pos);
                end
            end
            obj = ScrewAxis(parent, S, T);
        end
        function obj = fromType(parent, type, T)
            % assume fixed joint
            shat = [0; 0; 0];
            switch type
                case {'px', 'py', 'pz', 'rx', 'ry', 'rz'}
                    if type(1) == 'p'
                        pitch = inf;
                    else
                        pitch = 0;
                    end
                    % takes advantage of ASCII mapping to numbers
                    i = type(2) - 'x';
                    shat(i + 1) = 1;
                otherwise
                    pitch = 0;
                    if ~strcmp(type, 'fixed')
                        warning(['unknown joint type %s; returning ', ...
                            'fixed joint'], type);
                    end
            end
            if nargin < 3
                obj = ScrewAxis.fromAxisPitchPos(parent, shat, pitch);
            else
                obj = ScrewAxis.fromAxisPitchPos(parent, shat, pitch, T);
            end
        end
    end
end