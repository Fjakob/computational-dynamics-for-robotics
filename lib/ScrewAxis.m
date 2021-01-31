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
        end
        
        function obj = setScrew(obj, S, T)
            obj.UnitScrew = S;
        end
    end
end