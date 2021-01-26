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
    %       dAdt - acceleration in moving frame coordinates
    %       M - the transform in SE(3) from parent to rigid body
    %       LinkTransform - An EnvironmentObject for holding other graphics
    %       Joint - A graphical representation of the screw axis
    %       Link - A graphical representation of a link
    %       CenterOfMass - A graphical representation of the COM
    %
    %   RigidBody Methods:
    %      RigidBody - The constructor for this class
    %      fromUrdf - A static function for creating rigid bodies from URDF
    %      tree - Draws the kinematic tree in html
    
%     YOUR TODO LIST:
%     
%     * Define all of the properties listed in the documentation.  As part of
%     your design process, you are free to give these properties any desired
%     scope that you would like.  We've given user's of the library read-only
%     access.
%     
%     * Define the constructor RigidBody, the function prototype is obj =
%     RigidBody(name)
%         
%     * In the constructor, initialize 
%         * Name from the input `name` in RigidBody
%         * Parent and Children to RigidBody.empty()
%         * M to the identity element in SE(3)
%         * I to zero mass and zero rotational inertia
%         * A and dAdt to zero 6 x 1 vectors
%         * LinkTransform an EnvironmentObject with no parent (parent = [])
%         * Joint a ScrewAxis with LinkTransform as parent and A as the unit
%         screw and with origin coincident with LinkTransform (T = eye(4))
%         * Link a Frame with Joint as parent and coincident with Joint's frame
%         * CenterOfMass a CenterOfMass with Link as parent and I as its
%         spatial inertia
%     
%     * define the setter set.Parent(obj, parent).  This function takes in
%     the rigid body's parent and adds itself to the end of the parent's
%     Children array.  That is before returning from this function, we have:
%         parent.Children(end) = obj
%     Make sure to test that the parent isn't empty before attempting to add
%     obj as a child.
% 
%     * define fromUrdf as an externally defined static method.  You should 
%     not need to create an instance of RigidBody to use fromUrdf.  It is 
%     enough for users of your library to call RigidBody.fromUrdf(...).
%         * You can define extrnal methods by simply writing their function
%         prototype in the appropriate methods block.  E.g.,
%             methods (Static)
%                 [root, name] = fromUrdf(file)
%             end
%     
%     * define tree as an externally defined public class method.  You *will* 
%     need to create an instance of RigidBody to use tree.
%         * You can define extrnal methods by simply writing their function
%         prototype in the appropriate methods block.    
%     
%    
end