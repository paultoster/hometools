function  cell_array = cell_reduce_with_liste(cell_array,cell_liste,regel)
%
% cell_array = cell_reduce_with_liste(cell_array,cell_liste,regel)
% 
% sucht die strings aus cell_liste in cell_array und l�scht diese
%
% regel         char        'f' oder 'v' full oder voll. d.h such_muster mu�
%                             vollst�ndig mit einer cell �bereinstimmen (default)
%                             'n'  mu� nicht vollst�ndig �bereinstimmen
%                             'fl','vl','nl' vergleicht den Text mit lower()
%    
  for i=1:length(cell_liste)
    ifound = cell_find_f(cell_array,cell_liste{i},regel);
    if( ~isempty(ifound) )
      cell_array = cell_delete(cell_array,ifound);
    end
  end
          
end