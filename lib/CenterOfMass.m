classdef CenterOfMass < EnvironmentObject
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/24/2021, Matlab R2020a, v1
    
    % set names
    % set colors
    properties
        SpatialInertia
    end
    properties (Access = private)
        CenterOfMassFrame
        PrincipalAxes
        InertiaEllipsoid
    end
    methods
        function obj = CenterOfMass(parent, I)
            % create an empty graphics container
            myGraphics = hgtransform('Parent', []);
            obj@EnvironmentObject(parent, myGraphics);
            % set spatial inertia to update graphics
            obj.SpatialInertia = I;
            
        end
    end
end
