function [e] = e_data_add_known_name_signals(e)


  [c_siglist_in,c_siglist_out] = d_data_change_signal_name_list;

  c_enames = fieldnames(e);
  n_enames = length(c_enames);
  
  for i=1:n_enames
    name_in = c_enames{i};
    
    % Suche signal in input-liste
    [found,unit_in,name_new] = e_data_add_known_name_signals_search_in(name_in,c_siglist_in);
    if( found )
      % Suche, ob eine Einheit vorhanden, wenn ja nehme diese, ansonsten
      % aus der Liste
      if( isfield(e,name_in) && isfield(e.(name_in),'unit') && ~isempty(e.(name_in).('unit')) )
        unit_in = e.(name_in).('unit');
      else
        e.(name_in).('unit') = unit_in;
      end
      [found,unit_new,comment_new] = e_data_add_known_name_signals_search_out(name_new,c_siglist_out);
      % Wenn der neue ANme nicht gefunden wird
      if( ~found )
        error('%s_error: Für das Input-Signal <%s> wird (in c_siglist_in) der neue Signalname <%s> gefunden, aber nicht in c_siglist_out aufgeführt (sihe d_data_change_signal_name_list.m)',mfilename,name_in,name_new);
        
      end
      
      [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_new);
      
      if( ~isempty(errtext) )
        fprintf(errtext)
        error('Für das Input-Signal: <%s> und Output-Signal <%s> wird keine Einheitsumrechnung gefunden !!!',name_in,name_new);
      end
      e.(name_new).time = e.(name_in).time;
      e.(name_new).vec  = e.(name_in).vec * fac + offset;
      e.(name_new).unit = unit_new;
      if( isfield(e.(name_in),'comment') && ~isempty(e.(name_in).comment) )
        e.(name_new).comment = [comment_new,'/',e.(name_in).comment];
      else
        e.(name_new).comment = comment_new;
      end
    end
  end
end
function [found,unit_in,name_new] = e_data_add_known_name_signals_search_in(name_in,c_siglist_in)

  found    = 0;
  unit_in  = '';
  name_new = '';
  n = length(c_siglist_in);
  for i=1:n
    if( strcmp(c_siglist_in{i}{1},name_in) )
      found = 1;
      unit_in  = c_siglist_in{i}{2};
      name_new = c_siglist_in{i}{3};
      return
    end
  end
end
function [found,unit_new,comment_new] = e_data_add_known_name_signals_search_out(name_new,c_siglist_out)

  found       = 0;
  unit_new    = '';
  comment_new = '';
  n = length(c_siglist_out);
  for i=1:n
    if( strcmp(c_siglist_out{i}{1},name_new) )
      found       = 1;
      unit_new    = c_siglist_out{i}{2};
      comment_new = c_siglist_out{i}{3};
      return
    end
  end
end
