function [vec,index] = e_data_vecinvec_get_first_vec(e,signame)
%
%  [vec,index] = e_data_vecinvec_get_first_vec(e,signame)
%
% Suche ersten Vektor n > 0 in e.signame (muss ein vecinvec Datenelement
% sein) Rückgabe
%
% vec = e.signame.vec{index}
% Wenn nicht vorhanden vec = []; index = 0;

  vec   = [];
  index = 0;
  
  if( ~isfield(e,signame) )
    error('Der Signalname :<%s> ist nicht vorhanden!! ',signame);
  end
  
  if( ~e_data_is_vecinvec(e,signame) )
    error('Das Signal e.%s ist kein vecinvec- Signal',signame);
  end
  
  for i=1:length(e.(signame).time)
    
    if( length(e.(signame).vec{i}) > 0 )
      index = i;
      vec   = e.(signame).vec{i};
      break;
    end
  end
end
  