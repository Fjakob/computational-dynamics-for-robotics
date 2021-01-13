function n = get_value(s)
% GET_VALUE Converts a string value of numbers to their numeric values.
%   N = GET_VALUE(s) Returns an array of doubles of the converted string.
%
%   See also GET_ATTRIBUTE, GET_CHILD_ATTRIBUTE, and GET_ELEMENT

s = strsplit(s);
i = ~cellfun(@isempty, s);
n = str2double(s(i));
end