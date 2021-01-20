function robot = parse_robot(robotElement)
% PARSE_ROBOT Extracts robot attributes from a <robot> element node.
%   ROBOT = PARSE_ROBOT(ROBOTELEMENT) Returns the name of the robot.
%
%   See also PARSE_LINK, PARSE_JOIN, and PARSE_MATERIAL

robot = Urdf.get_attribute(robotElement, 'name');
end

