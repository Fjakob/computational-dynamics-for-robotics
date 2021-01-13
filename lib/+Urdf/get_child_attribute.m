function attribute = get_child_attribute(parent, tagName, attrName, opt)
% GET_CHILD_ATTRIBUTE Gets a child element node's atrribute.
%   ATTRIBUTE = GET_CHILD_ATTRIBUTE(PARENT, TAGNAME, ATTRNAME, OPT) Returns
%   a char array ATTRIBUTE representing the string value of ATTRNAME of the
%   element TAGNAME which is a child of the element node PARENT. If
%   ATTRNAME does not exist, then the string OPT is returned.  PARENT can
%   be an empty value.
%
%   Important:
%         An error is thrown if ATTRNAME does not exist and there is no
%         optional value.  ATTRNAME is treated as a required attribute.
%
%   See also GET_ATTRIBUTE, GET_ELEMENT, and GET_VALUE

element = Urdf.get_element(parent, tagName);
if nargin < 4
    attribute = Urdf.get_attribute(element, attrName);
else
    attribute = Urdf.get_attribute(element, attrName, opt);
end
end