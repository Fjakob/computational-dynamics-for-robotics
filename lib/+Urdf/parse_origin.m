function T =  parse_origin(originElement)
% PARSE_ORIGIN Extracts transformation matrix T in SE(3) from an <origin>
% element node.
%   T = PARSE_ORIGIN(ORIGINELEMENT) Returns the transform T based on
%   the element nodes ORIGINELEMENT.
%
%   See also GET_VALUE, GET_ATTRIBUTE, R3_TO_SO3, EXPM3, and RP_TO_T

% shorthand calls to functions in URDF package
attr = @Urdf.get_attribute;
val = @Urdf.get_value;
rpy = val(attr(originElement, 'rpy', '0 0 0'));
xyz = val(attr(originElement, 'xyz', '0 0 0'));
assert(length(rpy) == 3 && length(xyz) == 3);

% compute roll-pitch-yaw in fixed/space/parent coordinates
what = eye(3);
R = eye(3);
for i = 1:3
    so3 = Math.r3_to_so3(what(:, i)) * rpy(i);
    R = Math.expm3(so3) * R;
end

% transform from parent to child
T = Math.Rp_to_T(R, xyz);
end