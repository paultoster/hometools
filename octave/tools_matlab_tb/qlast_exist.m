function [flag,vname] = qlast_exist(value_name)
%
% flag = qlast_exist(value_name)
% flag = qlast_exist(n)
% if qlast.mat exist with qlast.dint = yyyymmtt of actual day
% and value_name or n-value exist then return true
%
% value_name     char     qlast.(value_name)
% n              int      1: qlast.last_used_mease_dir
%                         2: qlast.last_used_file_list
%                         3: qlast.last_used_carmaker_erg_dir
%
  flag         = 0;
  value_search = 1;
  
  if( ~exist('value_name','var') )
    value_name = '';
    value_search = 0;
  end
  
  % heutiges Datum prüfen
  if( exist(qlast_filename,'file') )
    load(qlast_filename);
    if( exist('qlast','var') && isfield(qlast,'dint') )
      if( qlast.dint == datum_heute_to_int )
        flag = 1;
      end
    end
  end
  value_name = qlast_build_name(value_name);  
  if( value_search && flag )
    flag = 0;
    if( ischar(value_name) )
      if( check_val_in_struct(qlast,value_name,'any',1) )
        flag = 1;
      end
    end
  end
  
  % zweiter Output
  if( nargout > 1 )
    vname = value_name;
  end
end