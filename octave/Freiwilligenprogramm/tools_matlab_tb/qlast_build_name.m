function value_name = qlast_build_name(value_name)
%
% vname = qlast_build_name(value_name)
% vname = qlast_build_name(n)
% stellt variablen-Namen bereit, wenn z.B. numerisch
  if( isnumeric(value_name) )
    if( value_name(1) == 1 )
      value_name = 'last_used_mease_dir';
    elseif( value_name(1) == 2 )
      value_name = 'last_used_file_list';
    elseif( value_name(1) == 3 )
      value_name = 'last_used_carmaker_erg_dir';
    end
  end
