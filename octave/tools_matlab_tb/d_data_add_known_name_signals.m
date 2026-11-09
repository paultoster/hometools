function [d,u,c] = d_data_add_known_name_signals(d,u,c)

  if( ~exist('c','var') )
    c = [];
  end

  [c_siglist_in,c_siglist_out] = d_data_change_signal_name_list;

  c_dnames = fieldnames(d);
  n_dnames = length(c_dnames);
  
  for i=1:n_dnames
    name_in = c_dnames{i};
    if( strcmp(name_in,'AVL_QUAN_EES_WHL_FLH') )
      a = 1;
    end
    % Suche signal in input-liste
    [found,unit_in,name_new] = d_data_add_known_name_signals_search_in(name_in,c_siglist_in);
    if( found )
      % Suche, ob eine Einheit vorhanden, wenn ja nehme diese, ansonsten
      % aus der Liste
      if( isfield(u,name_in) && ~isempty(u.(name_in)) )
        unit_in = u.(name_in);
      else
        u.(name_in) = unit_in;
      end
      [found,unit_new,comment_new] = d_data_add_known_name_signals_search_out(name_new,c_siglist_out);
      % Wenn der neue ANme nicht gefunden wird
      if( ~found )
        error('%s_error: Für das Input-Signal <%s> wird (in c_siglist_in) der neue Signalname <%s> gefunden, aber nicht in c_siglist_out aufgeführt (sihe d_data_change_signal_name_list.m)',mfilename,name_in,name_new);
        
      end
      
      [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_new);
      
      if( ~isempty(errtext) )
        fprintf(errtext)
        error('Für das Input-Signal: <%s> und Output-Signal <%s> wird keine Einheitsumrechnung gefunden !!!',name_in,name_new);
      end
      d.(name_new) = d.(name_in) * fac + offset;
      u.(name_new) = unit_new;
      if( isfield(c,name_in) )
        c.(name_new) = [comment_new,'/',c.(name_in)];
      else
        c.(name_new) = comment_new;
      end
    end
  end
end
function [found,unit_in,name_new] = d_data_add_known_name_signals_search_in(name_in,c_siglist_in)

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
function [found,unit_new,comment_new] = d_data_add_known_name_signals_search_out(name_new,c_siglist_out)

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
