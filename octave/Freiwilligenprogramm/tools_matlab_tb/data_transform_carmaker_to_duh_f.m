function  [okay,d,u,c_h] = data_transform_carmaker_to_duh_f(cm,sig_name_list)
%
% [okay,d,u,c_h] = data_transform_carmaker_to_duh_f(cm,sig_name_list)
%
% Transformiert carmaker-Datenformat in duh-Datenformat
% cm                 Carmaker ergebnisstruktur
% sig_name_list      Liste mit Sinalnamen, die verwendet werden soll
%                    leer Liste heißt alles transformieren (optional)

  if( ~exist('sig_name_list','var') )
    sig_name_list = {};
  end
  
  if( isempty(sig_name_list) )
    
    read_all_signames = 1;
  else
    
    read_all_signames = 0;
    sig_name_list{length(sig_name_list)+1} = 'time';
  end
  
  okay = 1;
  c_h = {};
  % Prüfen ob carmaker-Format stimmt                        

  % carmaker-Datensatz muß eine Struktur sein und muß Time
  % als Struktur besitzen, und data muß darin als double enthalten sein
  if( data_is_carmaker_format_f(cm) )

    c_names = fieldnames(cm);
    for i=1:length(c_names)

      if( strcmp(c_names{i},'Time') )
        % X-Komponente

        val      = cm.Time.data;
        var_name = 'time';
        unit     = cm.Time.unit;
      else
        val      = cm.(c_names{i}).data;
        var_name = c_names{i};
        unit     = cm.(c_names{i}).unit;
      end    

      % alles in Spaltenvektor
      [n,m] = size(val);
      if( m > n )
        val = val';
      end
      
      % Prüfen ob in Signalnamenliste oder alle Values (read_all_signames)
      %===================================================================
      if(  read_all_signames ...
        || ~isempty(cell_find_f(sig_name_list,var_name,'f')) ...
        )
        if( exist('d','var') )
            d = setfield(d,var_name,val);
        else
            d = struct(var_name,val);
        end
        if( exist('u','var') )
            u = setfield(u,var_name,unit);
        else
            u = struct(var_name,unit);
        end
      end
    end

    if( ~exist('d','var') )
        d   = struct([]);
    end
    if( ~exist('u','var') )
        u   = struct([]);
    end
    
    len = length(c_h);
    c_h{len+1} = [datestr(now),' read-carmaker-data'];
  else
    okay = 0;
    d   = struct([]);
    u   = struct([]);
  end
  
  d = struct_sortiere_nach_vorne(d,'time');
  u = struct_sortiere_nach_vorne(u,'time');
end
