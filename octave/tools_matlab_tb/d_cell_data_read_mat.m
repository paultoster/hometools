function [okay,d,u,h,n] = d_cell_data_read_mat(filename)
%
% [okay,c_d,c_u,c_h,n] = read_mat_d_data(filename)
%
% Liest Matlab-Daten in d-Struktur ein
%
% filename           Matlabfilename
%
% okay               = 1 okay
% c_d{i}             i-te Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%                    d.time = [0;0.01;0.02; ... ]
%                    d.F    = [1;1.05;1.10; ... ]
%                    ...
% c_u{i}             i-te Unitstruktur mit Unitnamen
%                    u.time = 's'
%                    u.F    = 'N'
%                    ...
% c_h{i}             i-te Header-Cellarray mit Kommentaren
% n                  Anzahl der Datenstrukturen
%
 d = {};
 u = {};
 h = {};
 n = 0;
 okay = 1;
 found_flag = 0; 
 if( ~exist(filename,'file') )
   warning('Datei <%s> konnte nicht gefunden werden',filename);
   okay = 0;
   return
 end
  % Daten einlesen in Struktur
  s_read    = load(filename);
  
    % Prüfen, ob marc-Format:
  if( data_is_marc_aft_format_f(s_read) )

      [okay_d,s_d] = data_get_fields_marc_f(s_read);                      
      if( okay_d )
          found_flag = 1;
          for id = 1:length(s_d)
              n    = n + 1;
              d{n} = s_d(id).d;
              u{n} = s_d(id).u;
              h{n} = s_d(id).h;
          end
          clear s_d
      end

  % Prüfen, ob Daten duh-Format:
  elseif( data_is_duh_format_f(s_read) )

      [okay_d,dd,uu,c_comment] = data_get_fields_duh_f(s_read);                      
      if( okay_d )
          found_flag = 1;
          n          = n + 1;
          d{n}       = dd;
          u{n}       = uu;
          h{n}       = c_comment;
      end
  elseif( data_is_canalyser_format_f(s_read) ) % Canalyser

      [okay_d,dd,uu,c_comment] = data_get_fields_canalyser_f(s_read);                      

      if( okay_d )
          found_flag = 1;
          n    = n + 1;
          d{n}       = dd;
          u{n}       = uu;
          h{n} = c_comment;
      end


  elseif( data_is_canape_format_f(s_read) )

      [okay_d,dd,uu,c_comment] = data_get_fields_canalyser_f(s_read);                      

      if( okay_d )
          found_flag = 1;
          n    = n + 1;
          d{n}       = dd;
          u{n}       = uu;
          h{n}       = c_comment;
      end

  else %andere Format
      
    % Struktur auswerten
    c_fieldnames = fieldnames(s_read);

    % Alle Strukturanteile auswerten
    for j=1:length(c_fieldnames)

          % Übergabe iter Strukturanteil
          child = getfield(s_read,char(c_fieldnames(j)));
          okay_d = data_is_dspa_format_f(child);
          if( okay_d )
            % Daten transformieren in duh-Struktur
            [okay_d,dd,uu,c_comment] = data_transform_dspa_to_duh_f(child);                      

            if( okay_d )
                found_flag = 1;
                n          = n + 1;
                d{n}       = dd;
                u{n}       = uu;
                h{n}       = c_comment;
            end
          else
            okay_d = data_is_duh_format_f(child);
            if( okay_d )

                      [okay_d,dd,uu,c_comment] = data_get_fields_duh_f(child);                      
                      if( okay_d )
                          found_flag = 1;
                          n          = n + 1;
                          d{n}       = dd;
                          u{n}       = uu;
                          h{n}       = c_comment;
                      end
                  else
                      okay_d = data_is_struct_vector_format_f(child);
                      if( okay_d )
                          [okay_d,dd,uu,hh] = data_get_fields_struct_vector_f(child);                      
                          if( okay_d )
                              found_flag = 1;
                              n          = n + 1;
                              d{n}       = dd;
                              u{n}       = uu;
                              h{n}       = hh;
                          end
                      end                    
            end
          end
      end

      if( ~found_flag ) % Prüfen ob Vektoren eingelesen wurden

          okay_d = data_is_struct_vector_format_f(s_read);
          if( okay_d )
              [okay_d,dd,uu,hh] = data_get_fields_struct_vector_f(s_read);                      
              if( okay_d )
                  found_flag = 1;
                  n          = n + 1;
                  d{n}       = dd;
                  u{n}       = uu;
                  h{n}       = hh;
              end
          end
      end
  end

  if( ~found_flag )
      okay = 0;
  end

end