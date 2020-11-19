% UTILS Documentation pending
classdef Utils
    properties (Constant)
        NUMEL_T = 16;
        NUMEL_R = 9;
        NUMEL_P = 3;
        NUMEL_S = 3;
        NUMEL_RP = Utils.NUMEL_R + Utils.NUMEL_P; % 12
        NUMEL_PS = Utils.NUMEL_P + Utils.NUMEL_S; % 6
        NUMEL_RPS = Utils.NUMEL_R + Utils.NUMEL_P + Utils.NUMEL_S; % 15
        
        IMAGE_Q = 256;
        
        RED = [1;0;0];
        GREEN = [0;1;0];
        BLUE = [0;0;1];
        BLACK = [0;0;0];
        GRAY = [0.3;0.3;0.3];
        MAGENTA  = [1;0;1];
        YELLOW = [1;1;0];
    end
    
    methods (Static)
        function [R, p, S] = parseTransformInput(T)
            if isa(T, 'Frame')
                T = T.R;
            end
            
            switch numel(T)
                case Utils.NUMEL_R
                    R = T;
                    p = zeros(3,1);
                    S = eye(3);
                case Utils.NUMEL_P
                    R = eye(3);
                    p = T(:); % make sure we get column vector
                    S = eye(3);
                case Utils.NUMEL_PS
                    R = eye(3);
                    p = T(:,1);
                    S = diag(T(:,2));
                case Utils.NUMEL_RPS
                    R = T(1:3,1:3);
                    p = T(:,4);
                    S = diag(T(:,5));
                case {Utils.NUMEL_RP, Utils.NUMEL_T}
                    R = T(1:3,1:3);
                    p = T(:,4);
                    S = eye(3);
                otherwise
                    R = eye(3);
                    p = zeros(3,1);
                    S = eye(3);
            end
        end
        
        function v = applyTransform(T, vertices)
            [R, p, S] = Utils.parseTransformInput(T);
            
            n = size(vertices);
            if n(2) == 3 && n(1) ~= 3
                v = ((R * S) * vertices' + p)';
            else
                v = (R * S) * vertices' + p;
            end
            
        end
        
        %         function imgs = initsnapshots(env, n)
        %             if nargin < 2
        %                 n = 1;
        %             end
        %
        %             imgs.data = cell(n, 1);
        %             imgs.data{1} = frame2im(getframe(env.fig));
        %         end
        
        function frames = takesnapshot(env, frames, i)
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
            frames{i} = getframe(env.fig);
        end
        
        function savesnapshots(frames, filename, varargin)
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