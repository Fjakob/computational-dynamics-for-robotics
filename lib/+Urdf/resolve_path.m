function path = resolve_path(node, file)
% RESOLVE_PATH Converts a path in a URDF file to a valid OS path.
%
%   Note:
%       All paths are relative to the URDF's DOM base URL (typically the
%       folder the file is in) unless the FILE is prefixed with package://,
%       in which case the root directory is ext_lib in the CDR top-level
%       folder.
%
%   See also RESOLVE_MATERIAL

packagePrefix = 'package://';
basePrefix = 'file:\';

if startsWith(file, packagePrefix)
    % get rid of package:// at beginning of fmt
    dir = what('ext_lib').path;
    n = strlength(packagePrefix) + 1;
    path = fullfile(dir, file(n:end));
else
    dir = fileparts(char(node.getBaseURI()));
    % get rid of file:\ at beginning of URI
    n = strlength(basePrefix) + 1;
    path = fullfile(dir(n:end), file);
end
end