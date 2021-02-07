% INPUTS: obj, q, qd, qdd 
% OUTPUT: tau
% ASSUMPTIONS: obj.Robot has fields 'V' and 'Vdot' initialized and stored 
%              in Vars

% extract robot info from obj
n = ???;
bodies = ???;
%   * an array of RigidBody types
parent = ???;
%   * an array of integers
tau = zeros(???, 1);

for i = ???
    b = bodies(i);
    Ii = ???;
    Ai = ???;
    dAidt = ???;
    Fext0 = ???;
    T_ip = ???;
%       * what method can we use from b?
    X_ip = Ad of T_ip;
    
    if parent(i) == 0
        p = ???;
%           * the root of the RigidBody tree; it's stored somewhere in obj
    else
        p = the parent of i of type RigidBody
%           * it's somewhere in the bodies array
    end

%   ******* NOW LOOK AT THE LAST LINE OF THIS LOOP *******
%   you will extract p's version of these variables using p.var; remember
%   p's version of these variables are in {p} coordinates
    
    T_i0 = ???
%       * use T_ip and p.var, which has parent's transform from {p} to {0}
%       * look at the last line of this loop and infer the name of the
%         transform stored in p

    X_0i = Ad of T_0i;
    
    vJ = Ai * qd(i); % relative velocity
    Vi = absolute velocity of parent + relative velocity of body;
%       * Vi is the absolute velocity of body i in {i} coordinates
%       * use p.var to get parent's absolute velocity
%       * don't forget to represent Vp in {i} coordinates
%       * look at the last line of this loop and infer the name of the
%         absolute velocity stored in p
    
    adVi = ad of Vi;
    vJdot = time derivative of vJ
%       * don't forget to apply chain rule!
    Vidot = absolute acceleration of parent + relative acceleration of body
%       * this is the time derivative of Vi
%       * don't forget to apply chain rule (especially for Vp in {i} coordinates)!
%         Vpdot = d/dt (Ad of T_ip) * Vp + Ad of T_ip * Vpdot
    
    adTVi = transpose of ad of Vi;
    Fi = ???
%       * use formula for Fi
    
    b.???('X', X_ip, 'T0', T_i0, 'V', Vi, 'Vdot', Vidot, 'F', Fi);
%       * save these variables for later
%       * remember b is of type RigidBody; how do we save variables with
%         this type?
end
for i = ???
    b = i^th body
    Ai = ???;
    Fi = ???
%       * extract with method |var|
    tau(i) = ???
    k = parent(i);
    if k > ???
        X_ip = b's Ad of T_ip;
        p = parent RigidBody of b from bodies array;
        p.???('F', p's wrench Fp + b's wrench in {p} coordinates);
%           * we need to save the updated wrench value
    end
end
