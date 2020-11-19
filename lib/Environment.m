% ENVIRONMENT Documentation pending.
classdef Environment < handle
    % Public Properties
    properties
        fig % handle to the figure where the graphical output happens
    end
    % Constant Properties
    properties (Constant)
        R = eye(3);
        p = zeros(3,1);
        % T = [Environment.R Environment.p; zeors(1,3) 1];
    end
    % Private Properties
    properties (SetAccess = private, GetAccess = private)
        % Handles to the graphical output
        ax;
        light_handle;
        % Indicates whether the graphical (inertial) axis are visible or
        % not.
        axVisible = 1;
        S;
    end
    
    % Public Methods
    methods
        % Constructor creates a graphics environment
        function obj = Environment()
            obj.fig = figure;
            set(obj.fig, 'Color', [0.95 0.95 0.95]);
            
            % from https://www.mathworks.com/matlabcentral/answers/254964
            set(obj.fig, 'DefaultTextInterpreter', 'latex');
            
            obj.ax  = axes;
            obj.light_handle = camlight('right');
            resetOutput(obj);
        end
        % Destructor closes the figure upon deletion
        function delete(obj)
            if isvalid(obj.fig)
                close(obj.fig);
            end
        end
        % Update output
        function resetOutput(obj)
            figure(obj.fig);
            if obj.axVisible
                axis(obj.ax, 'on');
            else
                axis(obj.ax, 'off');
            end
            axis(obj.ax, 'equal');
            view(obj.ax, [-37.5,30])
            axis(obj.ax, 'tight');
            a = axis(obj.ax);
            axis(obj.ax, a+[-1,1,-1,1,-1,1]);
            box(obj.ax, 'on')
            grid(obj.ax, 'on')
            camproj(obj.ax, 'perspective');
            camlight(obj.light_handle, 'right')
            view(obj.ax, [125, 25])
        end
        % Toggle the visibility of the graphical axis:
        function toggleAxis(obj)
            obj.axVisible = 1 - obj.axVisible;
            resetOutput(obj);
        end
        function show(obj)
            if isa(obj.S, 'Frame')
                obj.S.show();
            else
                obj.S = Frame(obj, Environment.R);
                obj.S.name = '{s}';
                % and it shows upon creation
            end
        end
        function hide(obj)
            if isa(obj.S, 'Frame')
                obj.S.hide();
            end
        end
    end
    methods(Static) 
        function T = getframe()
            T = Environment.R;
        end
    end
    % Private Methods
    % - none
end