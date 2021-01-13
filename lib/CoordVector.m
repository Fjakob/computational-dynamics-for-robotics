classdef CoordVector < EnvironmentObject
    % CoordVector Represents a coordinate vector in the environment
    %   A coordinate vector is defined relative to the "parent" frame of
    %   obj.Parent.  The Parent property for this class is inherited from
    %   the superclass EnvironmentObject. While the parent is often a Frame
    %   object, it does not have to be.
    %
    %   CoordVector Properties:
    %       Name - The name of the coordinate vector
    %
    %   CoordVector Methods:
    %      CoordVector - The constructor for this class
    %      setCoords - Sets the vector, parent, and transform to new values
    %      getCoords - Returns a copy of the vector in different coordinates
    %
    %   See also EnvironmentObject

    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/10/2021, Matlab R2020a, v23
    %   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21
    
    properties (Access = private)       
        % OP - A coordinate vector in R^3.  We can view OP as either
        %       - a free vector that describes magnitude and direction,
        %       - a vector in a body frame {b} with its tail at {b}'s
        %         origin (in which case T defines the relative
        %         configuration of {b} relative to the parent's frame), or
        %       - a vector in the parent's frame with its tail at the
        %         parent's origin (in which case T defines a displacement
        %         relative to the parent's frame).
        %   The first view is useful when rendering the graphic of the
        %   vector and the latter two when we want to displace the vector
        %   to another location in the parent frame via the transform T.
        OP
    end
    methods
        %% Constructor
        function obj = CoordVector(b, p_b, T_b)
            % CoordVector Creates a coordinate vector in the environment
            %   OBJ = CoordVector(B, P_B) Define coordinate vector as P_B
            %   in R^3 with coordinates in B.  B can be any
            %   EnvironmentObject or graphics handle.
            %
            %   OBJ = CoordVector(__, T_B) Apply transform T_B in SE(3) in
            %   order to place the vector at an offset in B.  T_B can be
            %   empty, which defaults to the identity element in SE(3).
            %
            %   Note:
            %       In space frame {s} coordinates, the vector is
            %       represented as
            %           p_s = T_sparent * T_b * p_b,
            %       where T_sparent is the configuration of the parent
            %       frame relative to {s}.  T_b is the identity transform
            %       if not specified.
            %
            %   See also setCoords EnvironmentObject and Draw.arrow
            
            % init graphics
            obj@EnvironmentObject(b, Draw.arrow([]));
            obj.hide();
            obj.RootGraphic.Tag = 'CoordVector';
            % setup properties
            if nargin < 3
                obj.setCoords(b, p_b);
            else
                obj.setCoords(b, p_b, T_b);
            end
            % show graphics
            obj.show();
        end
        %% Public Methods
        function obj = setCoords(obj, b, p_b, T_b)
            % setCoords Sets the coordinates of this vector to frame {b}
            %   OBJ = setCoords(OBJ, B, P_B) Sets the frame of the
            %   underlying coordinate vector to B with coordinate values
            %   P_B relative to the origin of B.  B can be any
            %   EnvironmentObject or graphics handle.
            %
            %   OBJ = setCoords(__, T_B) Apply a transform T_B in SE(3).
            %   The transform places the vector at an offset from B.
            %
            %   Note:
            %       CoordVector calls setCoords internally.  setCoords
            %       differs from moveGraphics in that B and P_B are
            %       required with T_B being optional and assumed to be the
            %       identity transform if not provided.
            %
            %   See also CoordVector and getCoords

            if nargin < 4
                T_b = eye(4);
            end
            
            obj.RootGraphic.Parent = obj.getGraphicsHandle(b);
            obj.OP = p_b;
            
            % update MyGraphics
            Draw.arrow(obj.MyGraphics, 'P', p_b);
            
            % update all graphics relative to this object's parent frame
            obj.moveGraphic(T_b);
        end
        function p_c = getCoords(obj, c)
            % getCoords Gets the coordinates of this vector in frame {c}
            %   P_C = getCoords(OBJ, C) Returns a vector in R^3 of the
            %   underlying coordinate vector in body coordinates {b}.  OBJ
            %   can be any EnvironmentObject or an object with a public
            %   getT_sb(OBJ) method.
            %
            %   See also CoordVector setCoords and getT_sb
            
            p_b = obj.OP;
            warning('get.T_sb has not been re-implemented yet.');
            T_sb = obj.T_sb;
            
            T_sc = c.T_sb;
            T_cs = Math.T_inverse(T_sc);
            p_c = Math.Tx(T_cs * T_sb, p_b);
        end
    end
end