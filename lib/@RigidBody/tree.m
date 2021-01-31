function cmds = tree(obj, parentId)
% tree Creates a kinematic tree using graphviz's dot language
%   CMDS = tree(OBJ) Returns the dot language commands CMDS for drawing
%   the tree rooted at RigidBody object OBJ.
%
%   CMDS = tree(OBJ, PARENTID) Labels OBJ as node Nx in the resulting dot
%   syntax, where x is the node ID.  The ID must be greater than PARENTID
%   and unique to the tree.  PARENTID must be an integer.
%
%   CMDS = tree(OBJ, HTMLFILE) After drawing the kinematic tree output the
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
%   See also Draw.tree

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
if root
    color red
%       * take a look at lib/+Draw/tree.m for syntax
else if leaf
    color blue
else not a root or leaf
    color green

attr = [sprintf('%s,', attr{1:end-1}), attr{end}];
label = ???
%   * must equal [name of obj, label]
cmds = {sprintf('N%d [%s,label="%s"];', myId, attr, label)};

if myId > 0
    cmds = [cmds, {sprintf('N%d -> N%d;', myId, parentId)}];
end
for each child
    cmds = [cmds, result of calling tree on child];
end

if parentId is a character array
    cmds = ???
%       * save the file using Utils.saveGraphiVizTree
end
end