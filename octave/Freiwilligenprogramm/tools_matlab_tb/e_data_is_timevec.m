function flag = e_data_is_timevec(e,name)
%
% flag = e_data_is_timevec(e,name)
%
% Strukturelement ist ein Zeitvektor mit time und vec
%
% e                  e-Struktur
% name               e.(name)
%
% flag               1: ist Zeitvektor
%                    0: ist kein Zeitvektor

  flag = 0;
  if( isfield(e,name) )
    % Zeitvektor mit numerischen Vektor
    if(  check_val_in_struct(e.(name),'time','num',1) ...
      && check_val_in_struct(e.(name),'vec','num',1) ...
      )
      flag = 1;
    % Zeitcellarray mit numerischen Vektoren
    elseif(  check_val_in_struct(e.(name),'time','num',1) ...
          && check_val_in_struct(e.(name),'vec','cell',1) ...
          )
      flag = 1;
%       for j=1:length(e.(name).vec)
%         if( ~isempty(e.(name).vec{j}) && isnumeric(e.(name).vec{j}) )
%           flag = 1;
%           break;
%         end
%       end
    end
  end

end