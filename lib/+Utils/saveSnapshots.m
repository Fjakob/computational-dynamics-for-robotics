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
IMAGE_Q = 256;

im = frame2im(frames{1});
[im, map] = rgb2ind(im, IMAGE_Q);
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
IMAGE_Q = 256;

[path, name, ext] = fileparts(filename);

im = frame2im(frames{1});
[im, map] = rgb2ind(im, IMAGE_Q);

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