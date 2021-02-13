function [root, n, bodies, parent] = kinematicTree(d, k)

parent = create_parent_array(d, k, 0);
n = length(parent) - 1;
A = [0; 0; 1; 0; 0; 0];
I = eye(6);

b = @(i) RigidBody(num2str(i)).set('I', I, 'A', A);
bodies = arrayfun(b, 0:n);

root = bodies(1);

for i = 2:n + 1
    p = parent(i);
    bodies(i).set('Parent', bodies(p));
end

if nargout > 2
    bodies = bodies(2:n);
end

if nargout > 3
    parent = parent(2:n);
end
end

function tree = create_parent_array(d, k, parent)

persistent id;

if parent == 0
    id = 1;
else
    id = id + 1;
end

node = id;

if d == 0
    tree = parent;
else
    if nargin < 2
        k = 1;
    end
    
    if isscalar(k)
        k = repmat(k, 1, d);
    end
    
    n = k(end - d + 1);
    if n < 0
        % generate random # of children
        n = randi([0, -n]);
    end
    
    tree = parent;
    for i = 1:n
        tree = [tree, create_parent_array(d - 1, k, node)]; %#ok<AGROW>
    end
end
end