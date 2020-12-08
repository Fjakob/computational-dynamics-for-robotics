classdef LibCoordVectorTest < matlab.unittest.TestCase
    % LibCoordVectorTest Tests the LectureCDR CoordVector class.
    %
    %   LibCoordVectorTest Methods:
    %       testName - Tests the Name property
    %       testMyGraphicsLength - Tests the tree structure of MyGraphics
    %       testLabel - Tests the tree structure of the Label graphic
    %       testArrow - Tests the tree structure of the Arrow graphics
    %       testColor - Tests that color changes for all graphics
    %       testCoords - Tests coordinate values in  different frames
    %
    %   Example:
    %       runtests('LibCoordVectorTest')

    % AUTHORS:
    %   Nelson Rosa nr@inm.uni-stuttgart.de 12/08/2020, Matlab R2020a, v1

    methods (Test)
        function testName(testCase)
            % testName Tests the property Name.
            
            expected = 'a vector';
            env = Environment;
            p = CoordVector(env, [1;1;0]);
            p.Name = expected;
            txt = findobj(env.SpaceFrame.RootGraphic, 'String', expected);
            % graphics tree (left to right, top to bottom, parent to child)
            % Transform (CoordVector) <- Transform (MyGraphics) <-
            % Transform (Label) <- Text (Label)
            parent = txt.Parent.Parent.Parent.UserData.envObject;
            testCase.verifyEqual(p.Name, expected);
            testCase.verifySameHandle(p, parent);
        end        
        function testMyGraphicsLength(testCase)
            % testMyGraphicsLength Tests the property MyGraphics.
            
            env = Environment;
            p = CoordVector(env, [1;1;0]);
            % added extra graphic handles
            p.add(text());
            p.add(surface());
            p.add(patch());
            testCase.verifyEqual(p.MyGraphics.Tag, 'MyGraphics');
            testCase.verifyLength(p.MyGraphics.Children, 3);
        end            
        function testLabel(testCase)
            % testLabel Tests the property Label.
            
            env = Environment;
            p = CoordVector(env, [1;1;0]);
            % add extra graphic handles
            p.add(text());
            p.add(surface());
            p.add(patch());
            % expected order is [Label Head Shaft], so Label is first
            c = p.MyGraphics.Children;
            i = 1;
            testCase.verifyClass(c(i), class(hgtransform()));
            testCase.verifyClass(c(i).Children, class(text()));
            testCase.verifyEqual(c(i).Tag, 'Label');
            testCase.verifyEqual(c(i).Children.Tag, 'Label');
        end
        function testArrow(testCase)
            % testArrow Tests the properties ArrowHead and ArrowShaft.
            
            env = Environment;
            p = CoordVector(env, [1;1;0]);
            % add extra graphic handles
            p.add(text());
            p.add(surface());
            p.add(patch());
            % expected order is [Label Head Shaft], so Head is second
            c = p.MyGraphics.Children;
            fmt = ' >-';
            prop = 'Children';
            hgt = class(hgtransform());
            for i = 2:3
                testCase.verifyClass(c(i), hgt);
                testCase.verifyClass(c(i).(prop), hgt);
                testCase.verifyClass(c(i).(prop).(prop), class(surface()));
                testCase.verifyEqual(c(i).Tag, fmt(i));
                testCase.verifyEqual(c(i).(prop).Tag, fmt(i));
                testCase.verifyEqual(c(i).(prop).(prop).Tag, fmt(i));
            end
        end      
        function testColor(testCase)
            % testColor Tests the property Color.
            
            color = '#996633'; % shade of brown
            env = Environment;
            p = CoordVector(env, [1;1;0]);
            
            % added extra graphic handles w/ Color or FaceColor properties
            p.add(text());
            p.add(surface());
            p.add(patch());
            
            p.Color = color;                     
            c = p.RootGraphic.Children;
            
            expected(1) = double(hex2dec(color(2:3))) / 255;
            expected(2) = double(hex2dec(color(4:5))) / 255;
            expected(3) = double(hex2dec(color(6:7))) / 255;
            actual = findobj(c, ...
                'FaceColor', expected, '-or', 'Color', expected);
            
            testCase.verifyLength(actual, 6);
        end
        function testCoords(testCase)
            % testCoords Tests coordinate values to known quantities
            
            env = Environment;
            T = Math.Rp_to_T([], [0; 1; 0]);
            p = CoordVector(env, [0; 1; 0], T);
            
            expected = [0; 2; 0];
            testCase.verifyEqual(p.getCoords(env.SpaceFrame), expected);
            
            T = Math.Rp_to_T(rotx(90), [0; 0; 0]);
            f = Frame(env, T);
            
            expected = [0; 0; -2];
            testCase.verifyEqual(p.getCoords(f), expected);
        end
    end
end