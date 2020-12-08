classdef Utils
    % UTILS Documentation pending
    properties (Constant)
        IMAGE_Q = 256;
    end
    
    methods (Static)
        function root = drawArrow(root, relPos)
            % drawArrow Draws a unit arrow with an empty label along
            % the z-axis of root and adds the graphic to root
            
            % tag root as CoordVector
            root.set('Tag', 'CoordVector');
            
            if nargin < 2
                relPos = 0.1;
            end
            
            % create a special container MyGraphics for this object's
            % graphics with root as parent (see EnvironmentObject.m for
            % description of MyGraphics property)
            g = EnvironmentObject(root);
            g.set('Tag', 'MyGraphics');
            root.add(g);
            
            % create components for an arrow and label.
            n = 4; % # of faces to draw
            
            % transformation properties for head of arrow
            headScale = 0.4;
            sHead = relPos * [headScale; headScale; 1];
            
            % transformation properties for shaft of arrow
            shaftScale = 0.02;
            sShaft = [shaftScale; shaftScale; 1];
            
            % transformation properties for label
            pTxt = [0; 0; relPos + 0.075];
            fontSize = 12;
            
            % transforms for base vector along z-axis; we rescale in
            % moveGraphic
            Thead = Math.Rps_to_T([], [], sHead);
            Tshaft = Math.Rps_to_T([], [], sShaft);
            
            % When adding graphics, the last graphic added appears first in
            % graphics.Children array; add children so that order is
            % [label, arrow head, arrow shaft]
            g.add('->', [Tshaft Thead], n);
            g.add(text('Position', pTxt, 'FontSize', fontSize, ...
                'Tag', 'Label'));
        end
        function root = drawFrame(root)
            % drawArrow Draws a unit arrow with an empty label and adds the
            % graphic to root
            
            % tag root as CoordVector
            root.set('Tag', 'Frame');
            
            % create container for graphics with root as parent
            g = EnvironmentObject(root);
            g.set('Tag', 'MyGraphics');
            root.add(g);
            
            color = {'red', 'green', 'blue'};
            name = {'$\hat{x}$', '$\hat{y}$', '$\hat{z}$'};
            I = eye(3);
            
            % add elements, so MyGraphics.Children = [Label, Origin, X, Y,
            % Z]
            for i = 3:-1:1
                axis = CoordVector(g, I(:, i));
                axis.Name = name{i};
                axis.Color = color{i};
            end
            
            % transformation properties for frame origin
            sOrigin = 0.05;
            Torigin = Math.Rps_to_T([], [], sOrigin);
            
            % transformation properties for label
            pTxt = [0; 0; -0.2];
            fontSize = 12;
            
            g.add('.', Torigin, 20);
            set(g.RootGraphic.Children(1).Children.Children, ...
                'FaceColor', 'black');
            g.add(text('Position', pTxt, 'FontSize', fontSize, ...
                'Tag', 'Label'));
        end
        function parent = draw(parent, fmt, T, n)
            if nargin < 3 || (nargin >= 3 && isempty(T))
                T = eye(4);
            end
            if nargin < 4 || (nargin >= 4 && isempty(n))
                n = 20;
            end
            
            nf = strlength(fmt);
            if length(T) == 4
                T = repmat(T, 1, nf);
            end
            
            if isscalar(n)
                n = repmat(n, 1, nf);
            end
            
            for i = 1:nf
                c = fmt(i);
                j = 4*(i-1)+1:4*i;
                switch c
                    case '.'
                        [X, Y, Z] = sphere(n(i));
                    case '>'
                        [X, Y, Z] = cylinder([1, 0], n(i));
                    case '<'
                        [X, Y, Z] = cylinder([0, 1], n(i));
                    case '-'
                        [X, Y, Z] = cylinder(1, n(i));
                    otherwise
                        warning('Unknown format %c; skipping.', fmt(i));
                        continue;
                end
                EnvironmentObject(parent) ...
                    .set('Tag', c).add(X, Y, Z, T(:, j));
            end
        end        
        function frames = takeSnapshot(env, frames, i)
            if nargin == 1 % dynamically add imgs
                i = 1;
                frames = {};
            elseif ~iscell(frames) % imgs is a preallocation size
                i = 1;
                frames = cell(frames, 1);
            elseif nargin < 3
                i = length(frames) + 1;
            end
            % add the image
            frames{i} = getframe(env.Axes);
        end
        function saveSnapshots(frames, filename, varargin)
            [~, ~, ext] = fileparts(filename);
            if strcmpi(ext, '.mp4')
                savemp4(frames, filename, varargin{:});
            elseif strcmpi(ext, '.gif')
                savegif(frames, filename, varargin{:});
            else
                saveimgs(frames, filename, varargin{:});
            end
        end
    end
end

function savemp4(frames, filename, varargin)
v = VideoWriter(filename, 'MPEG-4');
if nargin > 2
    set(v, varargin{:});
end
v.open();

n = length(frames);
for i = 1:n
    v.writeVideo(frames{i});
end
v.close();
end

function savegif(frames, filename, varargin)
im = frame2im(frames{1});
[im, map] = rgb2ind(im, Utils.IMAGE_Q);
imwrite(im, map, filename, 'gif', varargin{:});

% remove LoopCount option to avoid warnings when appending images
n = find(cellfun(@(x) ischar(x) && strcmpi(x, 'LoopCount'), varargin));
if ~isempty(n)
    varargin(n:n+1) = [];
end

n = length(frames);
for i = 2:n
    im = frame2im(frames{i});
    im = rgb2ind(im, map);
    imwrite(im, map, filename, 'gif', 'WriteMode', 'append', varargin{:});
end
end

function saveimgs(frames, filename, varargin)
[path, name, ext] = fileparts(filename);

im = frame2im(frames{1});
[im, map] = rgb2ind(im, Utils.IMAGE_Q);

n = length(frames);
if n == 1
    imwrite(im, map, filename, varargin{:});
else
    for i = 1:n
        fn = [path, name, num2str(i), ext];
        im = frame2im(frames{i});
        im = rgb2ind(im, map);
        imwrite(im, map, fn, varargin{:});
    end
end
end