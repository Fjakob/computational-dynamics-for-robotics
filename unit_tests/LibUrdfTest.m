classdef LibUrdfTest < matlab.unittest.TestCase
    % LibUrdfTest Tests functions in the LectureCDR Urdf package
    %   The tests cover the functions in the URDF library, which parses a
    %   URDF file.  The example test files are in ext_lib folder.
    %
    %   LibUrdfTest Methods:
    %       testGetAttribute - Tests getting an attribute
    %       testGetChildAttribute - Tests getting a child's attribute
    %       testGetElement - Tests getting an element
    %       testGetBadElement - Tests getting nonexistent element
    %       testResolvePath - Tests file paths
    %       testResolveMaterial - Tests material
    %       testParseGeometry - Tests <geometry>
    %       testParseOrigin - Tests <origin>
    %       testParseMaterial - Tests <material>
    %       testParseVisual - Tests <visual>
    %       testParseInertial - Tests <inertial>
    %       testParseLink - Tests <link>
    %       testParseJoint - Tests <joint>
    %       testParseRobot - Tests <robot>
    %       testParse - Tests parser
    %
    %   
    %   Example:
    %       runtests('LibUrdfTest')
    
    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1
    
    methods (Test)
        function testGetAttribute(testCase)
            % testGetAttribute Extract an attribute node from the URDF
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('link');
            element = elements.item(0);
            % name is required for a <link>, so generate an error if not
            % found.
            expected = 'base_link';
            actual = Urdf.get_attribute(element, 'name');
            testCase.verifyEqual(actual, expected);
        end
        function testGetChildAttribute(testCase)
            % testGetChildAttribute Extract an attribute node from the URDF
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('visual');
            element = elements.item(1);
            % example of calling a get_* function with an optional
            % variable.
            actual = Urdf.get_child_attribute(element, ...
                'origin', 'rpy', '0 0 0');
            expected = '0 1.57075 0';
            testCase.verifyEqual(actual, expected);
        end
        function testGetElement(testCase)
            % testGetElement Extract an element node from the URDF
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('visual');
            element = elements.item(1);
            actual = Urdf.get_element(element, 'geometry');
            testCase.verifyNotEmpty(actual);
        end
        function testGetBadElement(testCase)
            % testGetElement Extract an element node from the URDF
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('visual');
            element = elements.item(1);
            actual = Urdf.get_element(element, 'blorp');
            testCase.verifyEmpty(actual);
        end
        function testGetValue(testCase)
            % testGetValue Convert from string to double array
            
            actual = Urdf.get_value('1 -9.81 0');
            expected = [1 -9.81 0];
            testCase.verifyEqual(actual, expected);
        end
        function testResolvePath(testCase)
            % testResolvePath Normalizes path in URDF
            node = struct('getBaseURI', 'file:\');
            file = 'file.ext';
            
            % relative to URDF
            actual = Urdf.resolve_path(node, file);
            expected = file;
            testCase.verifyEqual(actual, expected);
            
            % relative to package
            dir = what('ext_lib').path;
            file = 'package://my/made/up/path/to/file.ext';
            actual = Urdf.resolve_path(node, file);
            expected = fullfile(dir, 'my/made/up/path/to/file.ext');
            testCase.verifyEqual(actual, expected);
        end
        function testResolveMaterial(testCase)
            % testResolveMaterial Tests replacement of placeholder material
            material = struct('Name', 'linkColor', ...
                'Color', [0.1 0.2 0.3 1], 'Texture', '');
            
            map = containers.Map({material.Name}, {material});
            link = struct('Graphic', struct('Material', 'linkColor'));
            actual = Urdf.resolve_material(link, map);
            expected = material;
            testCase.verifyEqual(actual.Graphic.Material, expected);
        end
        function testParseGeometry(testCase)
            % testParseGeometry Tests geometry struct
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('geometry');
            element = elements.item(2);
            geometry = Urdf.parse_geometry(element);
            
            actual = geometry.FormatString;
            expected = '#';
            testCase.verifyEqual(actual, expected);
            
            actual = geometry.T;
            expected = diag([0.4 0.1 0.1 1]);
            testCase.verifyEqual(actual, expected);
        end
        function testParseOrigin(testCase)
            % testParseOrigin Tests transformation matrix
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('origin');
            element = elements.item(1);
            
            actual = Urdf.parse_origin(element);
            expected = [1 0 0 0; 0 1 0 -0.22; 0 0 1 0.25; 0 0 0 1];
            testCase.verifyEqual(actual, expected);
        end
        function testParseMaterial(testCase)
            % testParseMaterial Tests material struct
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('material');
            element = elements.item(1);
            
            actual = Urdf.parse_material(element);
            expected = struct('Name', 'black', 'Color', [0 0 0 1], ...
                'Texture', '');
            testCase.verifyEqual(actual, expected);
        end
        function testParseVisual(testCase)
            % testParseMaterial Tests material struct
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('visual');
            element = elements.item(1);
            
            % example chaining
            T = [0 0 0.2 0; 0 0.1 0 0; -0.6 0 0 -0.3; 0 0 0 1];
            actual = Urdf.parse_visual(element);
            expected = struct('Name', '', 'FormatString', '#', 'T', T,  ...
                'Material', 'white');
            testCase.verifyEqual(actual, expected, 'AbsTol', 10^-4);
        end
        function testParseInertial(testCase)
            % testParseInertial Tests spatial inertia
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'humanoid_urdf', 'sm_humanoid.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('inertial');
            element = elements.item(0);
            
            T = Math.Rp_to_T([], [0 0 -0.109]);
            m = 0.369;
            Icom = diag([1.334e-3 1.935e-3 6.712e-4]);
            
            actual = Urdf.parse_inertial(element);
            expected = Math.mIcom_to_spatial_inertia(m, Icom, T);
            testCase.verifyEqual(actual, expected);
        end
        function testParseLink(testCase)
            % testParseLink Tests link struct
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('link');
            element = elements.item(0);
            
            w = warning();
            warning('off');
            actual = Urdf.parse_link(element);
            warning(w);
            
            m = 'blue';
            g = struct('Name', '', 'FormatString', '-', ...
                'T', diag([0.2 0.2 0.6 1]), 'Material', m);
            expected = struct('Name', 'base_link', 'I', zeros(6, 6), ...
                'Graphic', g);
            testCase.verifyEqual(actual, expected);
        end
        function testParseJoint(testCase)
            % testParseJoint Tests joint struct
            
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            dom = xmlread(urdf);
            elements = dom.getElementsByTagName('joint');
            element = elements.item(0);
            
            actual = Urdf.parse_joint(element);
            
            T = Math.Rp_to_T([], [0 -0.22 0.25]');
            A = zeros(6,1);
            expected = struct('Name', 'base_to_right_leg', 'T', T, ...
                'Parent', 'base_link', 'Child', 'right_leg', 'Screw', A);
            testCase.verifyEqual(actual, expected);
        end
        function testParseRobot(testCase)
            dir = what('ext_lib').path;
            urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
            
            robot = Urdf.parse(urdf);
            actual = robot.Name;
            expected = 'visual';
            
            testCase.verifyClass(robot, 'struct');
            testCase.verifySubstring(actual, expected);
        end        
%         function testParse(testCase) % b/c of hardcoded path won't work
%             dir = what('ext_lib').path;
%             urdf = fullfile(dir, 'mystery_robot', 'mystery_robot.urdf');
%             
%             [joints, links, materials] = Urdf.parse(urdf);
%             actual = struct('joints', joints, 'links', links, ...
%                 'materials', materials);
%             expected = load('mystery_robot_parsed_urdf.mat');
%             % we could also just test all keys and values, but the loop
%             % leads to a more detailed error message where the structs are
%             % displayed if there is a failure point
%             for i = {'joints', 'links', 'materials'}
%                 n = i{:};
%                 a = actual.(n);
%                 e = expected.(n);
%                 testCase.verifyLength(a, e.Count);
%                 for j = e.keys
%                     m = j{:};
%                     testCase.verifyTrue(a.isKey(m));
%                     testCase.verifyEqual(a(m), e(m));
%                 end
%             end
%         end
    end
end