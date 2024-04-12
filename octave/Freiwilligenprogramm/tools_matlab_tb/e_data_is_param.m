function flag = e_data_is_param(e,name)
%
% flag = e_data_is_param(e,name)
%
% e                  e-Struktur
% name               e.(name)
%
% flag               1: ist Parameter
%                    0: ist kein Parameter

  flag = 0;
  if( isfield(e,name) )
    if( check_val_in_struct(e.(name),'param','num',1) )
      flag = 1;
    end
  end

end