function element = get_element(parent, tagName)
% GET_ELEMENT Gets an element.
%   ELEMENT = GET_ELEMENT(PARENT, TAGNAME) Returns the unique element node
%   ELEMENT that is a child of PARENT. If TAGNAME does not exist, then an
%   empty value is returned.  If more than one element is found, then an
%   assertion fails.
%
%   See also GET_ATTRIBUTE, GET_CHILD_ATTRIBUTE, and GET_VALUE

element = parent.getElementsByTagName(tagName);
assert(element.getLength() <= 1, 'element <%s> is not unique in %s', ...
    tagName, parent.getNodeName);
element = element.item(0);
end