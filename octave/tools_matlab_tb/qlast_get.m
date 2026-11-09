function value = qlast_get(value_name,default_value)
%
% value = qlast_get(n)
% value = qlast_get(value_name)
% value = qlast_get(value_name,defaul_value)
% 
% search for qlast-mat with information qlast.(value_name) or
% with n special names
%
% value_name     char     qlast.(value_name)
% n              int      1: qlast.last_used_mease_dir
%                         2: qlast.last_used_file_list
%                         3: qlast.last_used_carmaker_erg_dir
%
% if not stored return []

  if( ~exist('default_value','var') )
    default_value = [];
  end

  [flag,vname] = qlast_exist(value_name);
  if( flag )
    load(qlast_filename);
    value = qlast.(vname);
  else
    value = default_value;
  end
end