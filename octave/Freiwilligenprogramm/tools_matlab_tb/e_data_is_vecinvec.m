function flag = e_data_is_vecinvec(e,name)
%
% flag = e_data_is_vecinvec(e,name)
%
% Strukturelement ist ein Zeitvektor mit time und vector in vec (cellarray)
%
% e                  e-Struktur
% name               e.(name)
%
% flag               1: ist Zeitvektor mit vector in vec (cellarray)
%                    0: ist kein 

  flag = 0;
  if( isfield(e,name) )
    if( e_data_is_timevec(e,name) )
      if( check_val_in_struct(e.(name),'vec','cell',0) )
        flag = 1;
      end
    end
  end

end