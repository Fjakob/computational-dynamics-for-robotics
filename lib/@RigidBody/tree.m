function cmds = tree(obj, parentId)
% TREE Creates a kinematic tree using graphviz's dot language
%   CMDS = TREE(OBJECT) Returns the dot language commands CMDS for drawing
%   the kinematic tree rooted at rigid body OBJECT.
%
%   CMDS = TREE(OBJECT, PARENTID) Labels the nodes Nx in the resulting dot
%   syntax starting at PARENTID. PARENTID must be an integer.
%
%   CMDS = TREE(OBJECT, HTMLFILE) After drawing the kinematic tree output
%   the results into an html file HTMLFILE.
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
%   See also DRAW.TREE

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
if obj is a root node then make it red
    attr = [attr, {'color=red'}];
elseif obj is a leaf node then make it blue
    attr = [attr, {'color=blue'}];
else
% make all other nodes green
%   * notice the syntax for how the other nodes are assigned their color
end

attr = [sprintf('%s,', attr{1:end-1}), attr{end}];
label = ????
%   * label should equal the name of the rigid body
cmds = {sprintf('N%d [%s,label="%s"];', myId, attr, label)};

if myId > 0
    cmds = [cmds, {sprintf('N%d -> N%d;', myId, parentId)}];
end

for c = obj.Children
    cmds = ???
%       * cmds should equal cmds and the result of calling tree on child c    
%       * see Draw.tree for ideas here
end

if ischar(parentId)
    cmds = Utils.saveGraphiVizTree(parentId, cmds);
end
end