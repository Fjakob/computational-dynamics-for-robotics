function attribute = get_attribute(element, attrName, optional)
% GET_ATTRIBUTE Gets an atrribute.
%   ATTRIBUTE = GET_ATTRIBUTE(ELEMENT, ATTRNAME, OPTIONAL) Returns a char
%   array ATTRIBUTE representing the string value of ELEMENT's ATTRNAME. If
%   ATTRNAME does not exist, then the string OPTIONAL is returned.  ELEMENT
%   can be an empty value.
%
%   Important:
%         An error is thrown if ATTRNAME does not exist and there is no
%         optional value.  ATTRNAME is treated as a required attribute.
%
%   See also GET_CHILD_ATTRIBUTE, GET_ELEMENT, and GET_VALUE

if isempty(element)
    attribute = '';
else
    % getAttribute(...) returns java.lang.String object
    % convert java.lang.String to Matlab char type
    attribute = char(element.getAttribute(attrName));
end

if isempty(attribute)
    if nargin >= 3
        attribute = optional;
    elseif isempty(element)
        msg = 'no urdf tag for required attribute %s.';
        error(msg, attrName);
    else
        msg = 'urdf tag <%s> is missing required attribute %s.';
        error(msg, char(element.getTagName()), attrName);
    end
end
end