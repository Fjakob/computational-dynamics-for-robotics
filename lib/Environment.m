classdef Environment < handle
    % Environment Represents a spatial environment
    %   The environment is a 3D 'physical' space with coordinates.  We
    %   assume that you have chosen an origin and length scale (e.g.,
    %   inches, meters, light-years) for your fixed space frame {s}.  All
    %   additional frames and vectors that you add to the environment
    %   are defined relative to {s}.
    %
    %   In practice, the environment is a Matlab figure.  The frame {s} is
    %   defined as the origin of the figure's graphical coordinate system
    %   by default.  The frame {s} can be customized to the user's liking,
    %   including its location in the graphical coordinate system.
    %
    %   Environment Properties:
    %       SpaceFrame - The fixed frame all objects are relative to
    %       Axes - The handle to the internal figure's axes
    %
    %   Environment Methods:
    %      Environment - The constructor for this class
    %      delete - Closes the figure and deletes the figure handle
    %      resetOutput - Resizes the axes limits
    %      show - shows the fixed frame
    %      hide - hides the fixed frame
    %
    %   See also EnvironmentObject

    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v22
    %   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21

    properties
        SpaceFrame % The envrionment's fixed frame in space

         % Axes - A reference to the axes handle of the underlying figure
         %  set.Axes Sets the x, y, z limits of the axes to the 6D array
         %  get.Axes Returns a handle to the figure's axes
         %
         %  Example:
         %      axis(obj.Axes, [-1 1 -5 5 -2 2]);
         %      axes = obj.Axes;
        Axes
    end
    % Private Properties
    properties (Access = private)
        light_handle
    end
    properties (Dependent, Access = private)
        Figure % The handle to the figure
    end    
    methods
        %% Constructor
        function obj = Environment(hAxes)
            if nargin < 1
                obj.Axes = axes(figure('Visible', 'off'));
            else
                obj.Axes = hAxes;
            end
            
            set(obj.Figure, 'Color', [0.95 0.95 0.95]);
                                  
            obj.light_handle = camlight('right');
            resetOutput(obj);
            
            obj.SpaceFrame = Frame(obj.Axes, eye(4));
            obj.SpaceFrame.RootGraphic.Tag = '{s}';
            obj.SpaceFrame.Name = 's';
            obj.SpaceFrame.hide();
            obj.resetOutput;
            obj.Figure.Visible = 'on';
        end
        %% Property Setter/Getter Methods
        %   The scope (private, protected, public) of these methods is
        %   defined in the related properties block.        
        function figure = get.Figure(obj)
            % get.Figure returns the axes' figure handle
                        
            figure = obj.Axes.Parent;
        end
        function set.Figure(obj, figure)
            % set.Figure change the parent of Axes object
            
            obj.Axes.Parent = figure;
        end
        %% Public Methods        
        function delete(obj)
        % delete Closes the figure upon deletion
        
            if isvalid(obj) && isvalid(obj.Figure)
                close(obj.Figure);
            end
        end
        function resetOutput(obj)
            % resetOutput Expands the axes limits to fit the displayed
            % graphics
            
            figure(obj.Figure);
            axes = obj.Axes;
            axis(axes, 'equal');
            view(axes, [-37.5,30])
            axis(axes, 'tight');
            a = axis(axes);
            axis(axes, a + [-1,1,-1,1,-1,1]);
            box(axes, 'on')
            grid(axes, 'on')
            camproj(axes, 'perspective');
            camlight(obj.light_handle, 'right')
            view(axes, [125, 25])
        end
        function show(obj)
            % show Shows the space frame in the figure
            obj.SpaceFrame.show();
        end
        function hide(obj)
            % hide Hides the space frame in the figure
            
            obj.SpaceFrame.hide();
        end
    end
end