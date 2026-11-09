function [ifound,iitem] = str_find_multiple_search_text(text_string,ctext_such,regel)
%
%  [ifound,iitem] = str_find_multiple_search_text(text_string,ctext_such,regel)
%
% Sucht ctext_such{i} in text_string nach der Regel:
% 'first' erste übereinstimmung default
% 'last' letzte übereinstimmung
%
% Gibt die gesuchte Stelle zurück
% wenn nicht gefunden, dann ifound = 0 zurückgegeben
% und item ist das gefundene item ctext_such{i}
%
% Beispiel
% [ifound,iitem] = str_find_multiple_search_text('abc//def{',{'//','{'},'first')
% ifound = 4
% iitem = 1
% [ifound,iitem] = str_find_multiple_search_text('abcdef',{'//','{'},'first')
% ifound = 0
% iitem = 0
% [ifound,iitem] = str_find_multiple_search_text('abc//def{',{'//','{'},'last')
% ifound = 9
% iitem = 2
% 
  ifound = 0;
  iitem = 0;
  
  if( ~exist('regel','var' ) )
    regel = 'first';
  elseif( (regel(1) ~= 'f') && (regel(1) ~= 'l') )
    error('regel nicht richtig')
  end
    
  ifoundvec  = [];
  
  iend   = length(text_string)+1;
  istart = 0; 
  
  for i=1:length(ctext_such)
    
    ifound = str_find_f(text_string,ctext_such{i},'vs');
    if( ifound )
      ifoundvec = [ifoundvec;ifound];
    elseif( regel(1) == 'f' )
       ifoundvec = [ifoundvec;length(text_string)+1];
    else
       ifoundvec = [ifoundvec;0];
    end
  end
  
  if( regel(1) == 'f' )    
    if( ~isempty(ifoundvec) )
      [ifound,iitem] = min(ifoundvec);
    end
  else
    if( ~isempty(ifoundvec) )
      [ifound,iitem] = max(ifoundvec);
    end
  end
  
  if( (ifound == iend) || (ifound == istart) )
    ifound = 0;
    iitem = 0;
  end
  
  
end
    
    
    