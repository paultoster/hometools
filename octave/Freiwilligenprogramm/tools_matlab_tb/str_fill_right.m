function str = str_fill_right(str,text,n)
%
% str_fill_right(str,text,n)
% F�llt str rechts mit text auf, bis n Zeichen erreicht oder �berschritten
% werden
  if( (length(str) < n) && (isempty(text)) )
    error(' text ist leer')
  end
  while(length(str) < n )
    str = [str,text];
  end
end