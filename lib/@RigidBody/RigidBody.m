classdef RigidBody < handle
    % RigidBody Represents a rigid body
    %   A rigid body can be connected to other rigid bodies to form a
    %   kinematic tree.
    %
    %   RigidBody Properties:
    %       Name - The name of the rigid body
    %       Parent - The rigid body's parent
    %       Children - The rigid body's children
    %       Vars - A struct to store user-specific variables
    %       I - the body's spatial inertia R^{6x6} in link coordinates
    %       A - the body's screw in R^6 in link coordinates
    %       dAdt - derivative of A in a moving frame
    %       M - the transform in SE(3) from parent to rigid body
    %       LinkTransform - An EnvironmentObject for holding other graphics
    %       Joint - A graphical representation of the screw axis
    %       Link - A graphical representation of a link
    %       CenterOfMass - A graphical representation of the COM
    %
    %   RigidBody Methods:
    %      RigidBody - The constructor for this class
    %      set - Sets the various properties of the class    
    %      fromUrdf - A static function for creating rigid bodies from URDF
    %      tree - Draws the kinematic tree in html
    %      clear - Delete the user-defined fields in Vars
    %      var - Returns the value of a user-defined field in Vars    
    %      fetch - Returns a struct with fields and values from Vars
    %      store - Stores a new value in Vars
    %      toArray - Converts a linked list into an array
    %      toMap - Converts a linked list into an associative array
    %
    %   See also Frame, ScrewAxis, EnvironmentObject, CenterOfMass
    
% YOUR TODO LIST:
%    
%   * Define all of the properties listed in the documentation.  We've 
%     defined them with read-only access in our solution code.  As part of 
%     your design process, you are free to give these properties any 
%     desired scope that you think appropriate.
%
%   * Define the constructor RigidBody, the function signature is 
%       obj = RigidBody(name),
%     where name is the rigid body's name (this can come from a link name
%     in a URDF, for example).  The function returns an instance of 
%     RigidBody with default property values listed below.
%
%   * In the constructor, initialize
%       * Name from the input `name` in RigidBody
%       * Parent and Children to RigidBody.empty()
%           * see https://www.mathworks.com/help/matlab/ref/empty.html for
%             more details; this way we can use isempty(...) and have the
%             correct object type.
%       * M to the identity element in SE(3)
%       * I to zero mass and zero rotational inertia
%       * A and dAdt to zero 6 x 1 vectors
%       * LinkTransform an EnvironmentObject with no parent (parent = [])
%       * Joint a ScrewAxis with LinkTransform as parent and A as the unit 
%         screw; the axis passes through the origin of LinkTransform 
%         (T = eye(4))
%       * Link a Frame with Joint as parent and frame coincident with 
%         Joint's frame
%       * CenterOfMass a CenterOfMass with Link as parent and I as its
%         spatial inertia    
%
%   * Define the setter set.Parent(obj, parent).  This function takes in
%     the rigid body's parent and appends itself to the end of the parent's
%     Children array.  That is before returning from this function, we 
%     have:
%         parent.Children(end) = obj
%       * Make sure to test that the parent isn't empty before attempting 
%         to add obj as a child.
%       * Also, beware of your interpretation of what the parent array 
%         should be and what you need to do in order to make it true.  You 
%         want to *append* obj to the end of parent.Children as a new 
%         element.  There are several ways of doing this in Matlab.
%
%   * Define the function signature for the class method fromUrdf.  The 
%     method is a static method that has to go in a static method block.  
%     You can read the Matlab OOP docs regarding static methods and a
%     static method block.
%       * https://www.mathworks.com/help/matlab/matlab_oop/static-methods.html
%
%   * Define the function signature of the RigidBody method tree in public 
%     methods block.
%       * cmds = tree(obj, parentId), where obj is the current node in the
%         RigidBody tree and parentId is either the parent's ID number or,
%         for the root node, the name of an html file to create after the
%         recursion is done.
    
end