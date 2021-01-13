function I = parse_inertial(inertialElement)
% PARSE_INERTIAL Extracts inertial parameters from an <inertial> element
% node.
%   I = PARSE_INERTIAL(INERTIALELEMENT) Returns a spatial inertia based on
%   the child element nodes of INERTIALELEMENT.
%
%   See also GET_VALUE, GET_ELEMENT, GET_CHILD_ATTRIBUTE, PARSE_ORIGIN, and
%   MICOM_TO_SPATIAL_INERTIA

if isempty(inertialElement)
    I = zeros(6, 6);
    warning('no inertial element specified.');
else
    I = Math.mIcom_to_spatial_inertia(....)
%       + all functions used to parse <inertial> are in the list of See 
%         also functions; use these to define the args T, Icom, and mass of
%         Math.mIcom_to_spatial_inertia.
end
end