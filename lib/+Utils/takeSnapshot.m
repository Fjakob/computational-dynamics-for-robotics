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