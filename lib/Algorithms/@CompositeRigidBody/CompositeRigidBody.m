% YOUR TODO LIST:
%   + write the class so that it inherits from RecursiveNewtonEuler
%   + there are no properties in this class; the constructor just calls the 
%     super class' constructor
%   + overwrite tau = iD(obj, q, qd, qdd), so that it uses the CRB to
%     compute M and the RNEA to compute h; place the method in this file.
%     The code is one line long as you are simply computing:
%       tau = M(q) * qdd + h(q, qd)
%   + define the function signature for M = M(obj, q); define the function 
%     in an external function, where you'll implement the CRB.
