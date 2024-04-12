function  cell_array = cell_reduce_with_liste(cell_array,cell_liste,regel)
%
% cell_array = cell_reduce_with_liste(cell_array,cell_liste,regel)
% 
% sucht die strings aus cell_liste in cell_array und löscht diese
%
% regel         char        'f' oder 'v' full oder voll. d.h such_muster muß
%                             vollständig mit einer cell übereinstimmen (default)
%                             'n'  muß nicht vollständig übereinstimmen
%                             'fl','vl','nl' vergleicht den Text mit lower()
%    
  for i=1:length(cell_liste)
    ifound = cell_find_f(cell_array,cell_liste{i},regel);
    if( ~isempty(ifound) )
      cell_array = cell_delete(cell_array,ifound);
    end
  end
          
end