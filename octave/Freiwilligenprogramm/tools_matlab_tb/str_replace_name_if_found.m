function name_new = str_replace_name_if_found(name_old,name_search,name_replace)
%
%  
%
% z.B. name_new = str_replace_name_if_found('ABC_minLateralWidth','*_minLateralWidth','*_min_lateral_width');
% name_new = 'ABC_min_lateral_width';
% z.B. name_new = str_replace_name_if_found('ABC_blabla','*_minLateralWidth','*_min_lateral_width');
% name_new = 'ABC_blabla';

[~,cnew] = cell_find_names(name_old,name_search,name_replace);

if( ~isempty(cnew) )
  name_new = cnew{1};
else
  name_new = name_old;
end