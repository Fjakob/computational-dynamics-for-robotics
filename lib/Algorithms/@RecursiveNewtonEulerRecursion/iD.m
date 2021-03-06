function tau = iD(obj, q, qd, qdd)
% iD Compute a robot's inverse dynamics.
%   TAU = iD(OBJ, Q, QD, QDD) Returns the generalized forces required to
%   generate the motion specified by generalized coordinates Q, velocity
%   QD, and acceleration QDD.  The generalized coordinates are linear
%   arrays that are internally converted into an associative array using
%   OBJ.Mapping.  The output TAU is a linear array where TAU(i) is the
%   generalized force applied to rigid body with name OBJ.Mapping{i}.

% AUTHORS:
%   Nelson Rosa nr@inm.uni-stuttgart.de 02/07/2021, Matlab R2020a, v1

map = obj.Mapping;
if isempty(map)
    warning('No mapping exists for this robot.  Set obj.Mapping.');
end

n = length(q);
root = obj.Robot;
z = zeros(n, 1);

q = containers.Map(map, q);
qd = containers.Map(map, qd);
qdd = containers.Map(map, qdd);
tau = containers.Map(map, z);

for c = root.Children
    recurse(c, tau, q, qd, qdd);
end

tau = transpose(cellfun(@(x) tau(x), map));
end

function tau = recurse(b, tau, q, qd, qdd)
%   YOUR TODO LIST:
%       + This is largely a copy-and-paste of iD.m from
%         @RecursiveNewtonEuler with a few modifications, so start by 
%         pasting that code here.
%       * Instead of indexing into an array, you index into a map using the
%         name of the RigidBody.  In other words, the index i is no longer
%         an integer, but a string.
%       * you will eventually call |recurse| again. consider what part of 
%         the code comes before the recursive call and what comes after the
%         recursive call.
%       * you don't need the if/else statement found in the first pass of 
%         the RNEA.  Why?
%       * for the second pass, instead of |if k > 0|, how else can we avoid 
%         assigning values to the root body using isempty(...).
%       * instead of relying on a parent array, simply use b.Parent
%       + An important addition is that you |recurse| on the children of b!
%       * You need to make sure that the variables that the children of b
%         depend on have been set before you make the recursive call.
%         Consider the order of how variables are set in pass 1 and/or 
%         pass 2 of the RNEA in order to determine what variables a parent 
%         has to have computed before a child can compute its own data.
%       * Finally, keep in mind that there is only one instance of a 
%         containers.Map object and its values.  Changes made to tau
%         in |recurse| are also seen by the same reference of tau used in 
%         iD(...) (not a copy of tau as with other object types, like 
%         numeric arrays).
end