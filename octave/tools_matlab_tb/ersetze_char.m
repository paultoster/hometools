function out_str = ersetze_char(in_str,such_char,ersetz_char)

index = strfind(char(in_str),char(such_char));
out_str = char(in_str);
out_str(index) = char(ersetz_char);