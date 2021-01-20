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
    val = @Urdf.get_value;
    
    origin = Urdf.get_element(inertialElement, 'origin');
    T = Urdf.parse_origin(origin);
        
    mass = val(Urdf.get_child_attribute(inertialElement, 'mass', 'value'));
    Ixx = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'ixx'));
    Ixy = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'ixy'));
    Ixz = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'ixz'));
    Iyy = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'iyy'));
    Iyz = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'iyz'));
    Izz = val(Urdf.get_child_attribute(inertialElement, 'inertia', 'izz'));
    Icom = [Ixx Ixy Ixz; Ixy Iyy Iyz; Ixz Iyz Izz];
    
    I = Math.mIcom_to_spatial_inertia(mass, Icom, T);
end
end