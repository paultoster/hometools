function c = cell_scale_vec_in_cell(c,fac)
%
% c = cell_scale_vec_in_cell(c,fac)
%
% scale c{i} if numeric
%
%
 n = length(c);
 for i=1:n
   
   if( isnumeric(c{i}) )
     c{i} = c{i} * fac;
   end
 end