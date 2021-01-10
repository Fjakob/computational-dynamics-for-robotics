function adV = adV(V)
% ADV Computes the little adjoint of a twist in R^6.
%   ADV = ADV(V) returns the 6x6 little adjoint representation of the
%   twist V in R^6, where V = [w; v] and adV = [[w] 0; [v] [w]] in R^{6x6}.
%
%   Example:
%       syms w v [3 1] real
%       V = [w; v];
%       adV = Math.adV(V)
%
%       >> [  0 -w3  w2    0   0   0; 
%            w3   0 -w1    0   0   0; 
%           -w2  w1   0    0   0   0;
%             0 -v3  v2    0 -w3  w2;
%            v3   0 -v1   w3   0 -w1;
%           -v2  v1   0  -w2  w1  0
%          ]

wmat = Math.r3_to_so3(V(1:3));
vmat = Math.r3_to_so3(V(4:6));
Z = zeros(3, 3);
adV = [wmat Z; vmat wmat];
end