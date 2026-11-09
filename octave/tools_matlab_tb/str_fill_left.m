function str = str_fill_left(str,text,n)
%
% str_fill_left(str,text,n)
% Füllt str links mit text auf, bis n Zeichen erreicht oder überschritten
% werden
  if( (length(str) < n) && (isempty(text)) )
    error(' text ist leer')
  end
  while(length(str) < n )
    str = [text,str];
  end
end