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
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v22
    %   C. David Remy remy@inm.uni-stuttgart.de 10/12/2018, Matlab R2018a, v21
    
    properties (Dependent)
        Name % The display name of the coordinate vector when rendered
    end
    properties (Access = private)
        RelPos = 0.1; % tip of arrow head relative to tip of arrow shaft
        T % A transform in SE(3) in parent frame coordinates
        
        % OP - The vector's head in it's body frame rooted at the tail
        %	A point p defines the vector OP in R^3.  We can view OP as
        %	either
        %       - a free vector that describes magnitude and direction,
        %       - a vector in a body frame {b} with its tail at the frame's
        %         origin (in which case T defines the relative
        %         configuration of {b} relative to the parent's frame), or
        %       - a vector in the parent's frame with its tail at the
        %         frame's origin (in which case T defines a displacement
        %         relative to the parent's frame).
        %   The first view is useful when rendering the graphic of the
        %   vector and the latter two when we want to displace the vector
        %   to another location in the parent frame via the transform T.
        OP
    end
    properties (Dependent, Access = private)
        Label % The text object that displays Name in the environment
        ArrowHead % A handle to the graphic representing the arrow's head
        ArrowShaft % A handle to the graphic representing the arrow's shaft
    end
    methods
        %% Constructor
        function obj = CoordVector(b, p_b, T_b)
            % CoordVector Creates a coordinate vector in the environment
            %   OBJ = CoordVector(B, P_B) Define coordinate vector as P_B
            %   in R^3 with coordinates in B.  B can be any
            %   EnvironmentObject or graphics handle.
            %
            %   OBJ = CoordVector(..., T_B) Apply transform T_B in SE(3) in
            %   order to place the vector at an offset in B.
            %
            %   Note:
            %       In space frame {s} coordinates, the vector is
            %       represented as
            %           p_s = T_sparent * T_b * p_b,
            %       where T_sparent is the configuration of the parent
            %       frame relative to {s}.  T_b is the identity transform
            %       if not specified.
            %
            %   See also setCoords moveGraphics and EnvironmentObject
            
            % init graphics
            obj@EnvironmentObject(b);
            obj.hide();
            Utils.drawArrow(obj, obj.RelPos);
            % setup properties
            if nargin < 3
                obj.setCoords(b, p_b);
            else
                obj.setCoords(b, p_b, T_b);
            end
            % show graphics
            obj.show();
        end
        %% Property Setter/Getter Methods
        %   The scope (private, protected, public) of these methods is
        %   defined in the related properties block.
        function set.Name(obj, name)
            % set.Name Sets the object's name
            
            txt = obj.Label.RootGraphic.Children;
            set(txt, 'String', name);
        end
        function name = get.Name(obj)
            % get.Name Gets the object's name
            
            txt = obj.Label.RootGraphic.Children;
            name = get(txt, 'String');
        end
        function label = get.Label(obj)
            % get.Label Gets the arrow's label as an EnvironmentObject
            
            label = obj.getMyGraphicsChild(1);
        end
        function head = get.ArrowHead(obj)
            % get.ArrowHead Gets the arrow's head as an EnvironmentObject
            
            head = obj.getMyGraphicsChild(2);
        end
        function shaft = get.ArrowShaft(obj)
            % get.ArrowShaft Gets the arrow's shaft as an EnvironmentObject
            
            shaft = obj.getMyGraphicsChild(3);
        end
        %% Public Methods
        function obj = setCoords(obj, b, p_b, T_b)
            % setCoords Sets the coordinates of this vector to frame {b}
            %   OBJ = setCoords(OBJ, B, P_B) Sets the frame of the
            %   underlying coordinate vector to B with coordinate values
            %   P_B relative to the origin of B.  B can be any
            %   EnvironmentObject or graphics handle.
            %
            %   OBJ = setCoords(..., T_B) Apply a transform T_B in SE(3).
            %   The transform place the vector at an offset from B.
            %
            %   Note:
            %       CoordVector calls setCoords internally.  setCoords
            %       differs from moveGraphics in that B and P_B are
            %       required with T_B being optional and assumed to be the
            %       identity transform if not provided.
            %
            %   See also CoordVector moveGraphics and getCoords
            
            if nargin < 4
                T_b = eye(4);
            end
            obj.moveGraphic(b, p_b, T_b);
        end
        function p_c = getCoords(obj, c)
            % getCoords Gets the coordinates of this vector in frame {c}
            %   P_C = getCoords(OBJ, C) Returns a vector in R^3 of the
            %   underlying coordinate vector in body coordinates {b}.  OBJ
            %   can be any EnvironmentObject or an object with a public
            %   getT_sb(OBJ) method.
            %
            %   See also CoordVector setCoords and getT_sb
            
            T_sc = c.getT_sb();
            T_cs = Math.T_inverse(T_sc);
            T_sb = obj.getT_sb();
            [~, p_c] = Math.T_to_Rp(T_cs * T_sb);
        end
        function obj = moveGraphic(obj, b, p_b, T_b)
            % moveGraphic Updates the base graphic
            %   OBJ = moveGraphic(OBJ, T_B) Moves the underlying coordinate
            %   vector by displacing it with the transform T_B in SE(3)
            %   defined relative to underlying parent frame B.
            %
            %   OBJ = moveGraphic(OBJ, P_B, T_B) Sets the coordinate values
            %   of the underlying coordinate vector to P_B in the
            %   underlying parent's frame B displaced by an amount T_B in B
            %   coordinates.
            %
            %   OBJ = moveGraphic(OBJ, B, P_B, T_B) Sets the frame of the
            %   underlying coordinate vector to B with coordinate values
            %   P_B relative to the origin of B displaced by an amount T_B
            %   in B coordinates. B can be any EnvironmentObject or
            %   graphics handle.
            %
            %   See also CoordVector and setCoords
            
            narginchk(2, 4);
            if nargin == 2
                obj.T = b; % b is a transformation matrix
            elseif nargin == 3
                obj.OP = b; % b is a postion vector
                obj.T = p_b; % p_b is a transformation matrix
            elseif nargin == 4
                obj.Parent = b;
                obj.OP = p_b;
                obj.T = T_b;
            end
            
            % Usually we don't need a complicated function to update the
            % graphics, but we want to keep a fixed relative position of
            % the arrow head with respect to the arrow shaft, so we need to
            % be careful with how we scale the underlying unit arrow
            
            %% Update MyGraphics
            % get relevant values to update the graphic
            relPos = obj.RelPos;
            label = obj.Label;
            head = obj.ArrowHead;
            shaft = obj.ArrowShaft;
            zAxis = [0; 0; 1]; % base arrow's initial direction
            p_b = obj.OP;
            n = norm(p_b);
            
            % scale the unit arrow's shaft to the correct size in the unit
            % arrow's frame (i.e., along z-axis)
            s = [1; 1; n - relPos]; % shaft scaling
            Tscale = Math.Rps_to_T([], [], s);
            shaft.moveGraphic(Tscale);
            
            % position the label and arrow head in the scaled arrow's frame
            % (i.e., along z-axis)
            p = [0; 0; n - relPos]; % label and head translation
            Ttrans = Math.Rp_to_T([], p);
            label.moveGraphic(Ttrans);
            head.moveGraphic(Ttrans);
            
            % transform scaled arrow along z-axis to point in the direction
            % of p_b with the tip of scaled vector's head at the origin of
            % its coordinate system
            R = Math.R_a_to_b(zAxis, p_b);
            T_b = Math.Rp_to_T(R, -p_b);
            obj.MyGraphics.Matrix = T_b;
            
            %% Update RootGraphics.Children
            % move all graphics relative to this object's parent frame
            T_pb = obj.T * Math.Rp_to_T([], p_b);
            moveGraphic@EnvironmentObject(obj, T_pb);
        end
    end
end