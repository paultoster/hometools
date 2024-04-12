function [u,c] = d_data_check_u_c(d,u,c)
%
% [u,c] = d_data_check_u_c(d,u,c)
% [u] = d_data_check_u_c(d,u)
%
% d                 Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%                   d.time = [0;0.01;0.02; ... ]
%                   d.F    = [1;1.05;1.10; ... ]
%                   ...
% u                 Unitstruktur mit Unitnamen
%                   u.time = 's'
%                   u.F    = 'N'
%                    ...
% c                Kommentar-Struktur  (normalerweise in h-cellarray h{2}
  
  c_names_d = {};
  c_names_u = {};
  c_names_c = {};
  if( ~isstruct(d) )
      error('%s_error: d muss eine Struktur sein',mfilename)
  end
  if( ~isstruct(u) )
      error('%s_error: u muss eine Struktur sein',mfilename)
  end
  if( exist('c','var') )
    c_flag = 1;
  else
    c_flag = 0;
  end
  if( nargout == 1 )
    c_flag = 0;
  end
  if( c_flag && ~isstruct(c) )
      error('%s_error: c muss eine Struktur sein',mfilename)
  end
    
    
  c_names_d = fieldnames(d);
  c_names_u = fieldnames(u);
  if( c_flag )
    c_names_c = fieldnames(c);
  end

  for i=1:length(c_names_d)
    found_flag = 0;
    for j=1:length(c_names_u)
        
        if( strcmp(c_names_d{i},c_names_u{j}) )
            found_flag = 1;
            break;
        end
    end
    
    if( ~found_flag )
        u.(c_names_d{i}) = '-';
    end
    if( c_flag )
      found_flag = 0;
      for j=1:length(c_names_c)
        
        if( strcmp(c_names_d{i},c_names_c{j}) )
            found_flag = 1;
            break;
        end
      end
    
      if( ~found_flag )
        c.(c_names_d{i}) = '';
      end
    end
  end

  c_names_u = fieldnames(u);

  if(length(c_names_u) > length(c_names_d) )

    for i=1:length(c_names_u)
        found_flag = 0;
        for j=1:length(c_names_d)
        
            if( strcmp(c_names_u{i},c_names_d{j}) )
                found_flag = 1;
                break;
            end
        end
    
        if( ~found_flag )
            u = rmfield(u,c_names_u{i});
        end
    end
  end
  if( c_flag )
    c_names_c = fieldnames(c);
    if(length(c_names_c) > length(c_names_d) )

      for i=1:length(c_names_c)
        found_flag = 0;
        for j=1:length(c_names_d)

          if( strcmp(c_names_c{i},c_names_d{j}) )
            found_flag = 1;
            break;
          end
        end

        if( ~found_flag )
          c = rmfield(c,c_names_c{i});
        end
      end
    end
  end

  % Prüfe, ob Einheit eins string ist
  c_names_u = fieldnames(u);

  for i=1:length(c_names_u)

    if( ~ischar(u.(c_names_u{i})) )

      u.(c_names_u{i}) = '-';
    end
  end
  if( c_flag )
    % Prüfe, ob Kommentar eins string ist
    c_names_c = fieldnames(c);

    for i=1:length(c_names_c)

      if( ~ischar(c.(c_names_c{i})) )

        c.(c_names_c{i}) = '';
      end
    end
  end
end