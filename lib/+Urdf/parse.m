% PARSE Parses a subset of element tags of a URDF file.
%   [JOINTS, LINKS, MATERIALS, NAME] = PARSE(URDF) Returns the joint, link,
%   and material properties, JOINTS, LINKS, and MATERIALS, respectively, of
%   a robot and the robot's name NAME stored in the URDF file.
%
%   robot = PARSE(__) Returns the joints, links, materials, and name of the
%   robot as fields in the struct ROBOT.
%
%   Note:
%       The parser must support elements
%          <robot>
%               <joint>
%                   <origin>
%                   <parent>
%                   <child>
%                   <axis>
%               <link>
%                   <inertial>
%                   <visual>
%               <material>
%       their attributes, including optional ones, and nested elements of
%       the listed children elements of joint and link (including optional
%       elements).
%
%   See also PARSE_ROBOT, PARSE_LINK, PARSE_JOINT, and PARSE_MATERIAL

function [joints, links, materials, name] = parse(urdf)
ELEMENT_NODE = 1; % numeric value of an element node type
% read in the URDF file and set <robot> as the root of our search;
% underneath the hood, xmlread calls a JAVA library for processing XML
% files.  The package has several helper functions get_* for processing the
% XML.
dom = xmlread(urdf);
robot = Urdf.get_element(dom, 'robot');
n = robot.getLength();

% get the robot's name
name = Urdf.parse_robot(robot);

% create the maps
joints = containers.Map();
links = containers.Map();
materials = containers.Map();

% only traverse first level of robot for child tags
for i = 0:n - 1
    node = robot.item(i);
    if node.getNodeType() == ELEMENT_NODE
        switch char(node.getTagName())
            case 'joint'
                joint = Urdf.parse_joint(node);
                joints(joint.Name) = joint;
            case 'link'
                link = Urdf.parse_link(node);
                links(link.Name) = link;
            case 'material'
                material = Urdf.parse_material(node);
                materials(material.Name) = material;
        end
    end
end

% map names of material in a link to a struct
k = links.keys;
for i = 1:length(k)
    links(k{i}) = Urdf.resolve_material(links(k{i}), materials);
end

if nargout == 1
    joints = struct('Name', name, 'Links', links, ...
        'Joints', joints, 'Materials', materials);
end
end