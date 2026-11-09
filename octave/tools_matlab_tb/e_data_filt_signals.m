function ee  = e_data_filt_signals(e,csig_liste,type)
%
% e  = e_data_filt_signals(e,csig_liste,type)
%
% filtert Signal aus
%
% e      e-Struktur mit e.sig_name1.time (Zeitvektor) und
%                       e.sig_name1.vec  (Signalvektor)
% 
% cig_liste             cellaray mit Sgnalnamen
%                       z.B. {'name1','name2','par*','*_01'}
%                      
%
% type                    0:   Durchlassen dieser Signale (default)
%                         1:   Sperren diser Signale
%
  ee = struct;

  if( ~exist('type','var') )
    type = 0;
  end
  
  % Namen der e-Struktur
  c_name = fieldnames(e);
  n      = length(c_name);
  
  cliste = cell_find_liste(c_name,csig_liste);
  
  if( type == 0 ) % durchlassen
    
    for i=1:length(cliste)
      
      ee.(cliste{i}) = e.(cliste{i});
    end
  else % sperren
    
    for i=1:n
      flag = 1;
      for j=1:length(cliste)
      
        if( strcmp(c_name{i},cliste{j}) )
          break;
        end
      end
      if( flag )
        ee.(c_name{i}) = e.(c_name{i});
      end
    end
            
  end

end
