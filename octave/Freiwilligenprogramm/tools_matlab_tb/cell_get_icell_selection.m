function [c] = cell_get_icell_selection(carr,iselection)
%
% cellarray = cell_get_icell_selection(carr,iselection)
%
% erstellt cellarray von carr{iselection} 
% iselection ist ein Array mit Inices
% 
%
  c = {};
  n = length(iselection);
  nc = length(carr);
  
  for i=1:n
    
    index = floor(double(iselection(i))+0.5);
    if( index <= nc )
      c = cell_add(c,carr{index});
    end
  end
end
