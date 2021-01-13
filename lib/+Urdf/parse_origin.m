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
% transform from parent to child
T = Math.Rp_to_T(...);
%       + all functions used to parse <origin> are in the list of See 
%         also functions.
end