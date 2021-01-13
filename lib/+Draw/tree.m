function cmds = tree(node, parentId)
% TREE Creates a scene graph using graphviz's dot language
%   CMDS = TREE(NODE) Returns the dot language commands CMDS for drawing
%   the scene graph rooted at graphics object NODE.
%
%   CMDS = TREE(NODE, PARENTID) Labels the nodes Nx in the resulting dot
%   syntax starting at PARENTID. PARENTID must be an integer.
%
%   CMDS = TREE(NODE, HTMLFILE) After drawing the scene graph output the
%   results into an html file HTMLFILE.
%
%   Note:
%       For future maintainers, keep in mind that the persistent variable
%       |id| is only valid as an ID for the current node *before* we make
%       the recursive function call.
%
%       The generated HTML file assumes the javascript library |viz.js| and
%       helper library |full.render.js| are installed in ext_lib/js.  The
%       html file will not render correctly if these files are not present.
%
%   See also HGTRANSFORM, WHAT, POINT, ARROW, FRAME, SHAPEF, and STL

% AUTHORS:
%   Nelson Rosa Jr. nr@inm.uni-stuttgart.de 01/13/2021, Matlab R2020a, v1

persistent id;
if nargin < 2 || ischar(parentId)
    id = 0;
    attr = {'style=bold'}; % make root node bold
    if nargin < 2
        parentId = '';
    end
else
    id = id + 1;
    attr = {};
end

% make a local copy of id; once we recurse id changes
myId = id;
label = '';
if strcmp(node.Type, 'hgtransform')
    attr = [attr, {'color=red'}];
elseif strcmp(node.Tag, '{s}')
    attr = [attr, {'color=blue'}];
elseif isgraphics(node)
    attr = [attr, {'color=orange'}];
else
    attr = [attr, {'color=black,style=dashed'}];
    label = ' (unknown handle)';
end

attr = [sprintf('%s,', attr{1:end-1}), attr{end}];
label = [node.Tag, label];
cmds = {sprintf('N%d [%s,label="%s"];', myId, attr, label)};

if myId > 0
    cmds = [cmds, {sprintf('N%d -> N%d;', myId, parentId)}];
end

c = node.Children;
for i = 1:length(c)
    cmds = [cmds, Draw.tree(c(i), myId)]; %#ok<AGROW>
end

if ischar(parentId)
    cmds = saveGraphiVizTree(parentId, cmds);
end
end

function html = saveGraphiVizTree(file, cmds)
indent = '  ';

dir = [what('ext_lib').path, filesep, 'js/'];

cmds = [{'rankdir=BT;', 'node [shape=box];'}, cmds];
cmds = cellfun(@(x) [repmat('  ', [1 4]), '''', x, ''' +'], cmds, ...
    'UniformOutput', false);
html = [{
    '<!DOCTYPE html>';
    '<html>';
    [indent, '<head>'];
    [indent, indent, '<meta charset="utf-8">'];
    [indent, '</head>'];
    [indent, '<body>'];
    [indent, indent, '<script src="', dir, 'viz.js"></script>'];
    [indent, indent, '<script src="', dir, 'full.render.js"></script>'];
    [indent, indent, '<script>'];
    [indent, indent, indent, 'var viz = new Viz();'];
    [indent, indent, indent, 'viz.renderSVGElement(''digraph CDR { '' +']};
    cmds'
    {
    [indent, indent, indent, '''}'')'];
    [indent, indent, indent, '.then(function(element) {'];
    [indent, indent, indent, indent, 'document.body', ...
    '.appendChild(element);'];
    [indent, indent, indent, '});'];
    [indent, indent, '</script>'];
    [indent, '</body>'];
    '</html>'
    }];

html = sprintf('%s\n', html{:});

if ~isempty(file)
    f = fopen(file, 'w');
    fprintf(f, '%s', html);
    fclose(f);
end
end