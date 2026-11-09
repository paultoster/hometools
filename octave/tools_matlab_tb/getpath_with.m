function [c,n] = getpath_with(search_string)
%
% [c,n] = getpath_with(search_string)
%
% search in matlab-pathes for search_string
% assuming '\'  for delimit path-string
%
% c     cell list with found pathes
% n     number of findings (=0 nothing found)
 c    = {};
 n    = 0;
 cc = str_split(path,';');

 for i=1:length(cc)
   if( str_find_f(cc{i},search_string,'vs') > 0 )
     n    = n + 1;
     c{n} = cc{i};
   end
 end
 
end
  