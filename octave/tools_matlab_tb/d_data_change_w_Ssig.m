function [d,u,c] = d_data_change_w_Ssig(Ssig,type,d,u,c)
%
% [d,u,c] = d_data_change_w_Ssig(Ssig,type,d,u,c)
%
% Sig Liste mit Signalen
%   Ssig(i).name_in      = 'signal name';
%   Ssig(i).unit_in      = 'dbc unit';              (default '')
%   Ssig(i).lin_in       = 0/1;                     (default 0)
%   Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%   Ssig(i).name_out     = 'output signal name';    (default name_in)
%   Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%   Ssig(i).comment      = 'description';           (default '')
%
%             name_in      is name from dbc, could also be used with two and mor names
%                          in cell array {'nameold','namenew'}, if their was an change
%                          in dbc, use for old measurements
%             unit_in      will used if no unit is in dbc for that input signal
%             lin_in       =0/1 linearise if to interpolate to a commen time base
%             name_sign_in if in dbc-File is a particular signal for sign (how VW
%                          uses) exist
%             name_out     output name in Matlab
%             unit_out     output unit
%             comment      description
%
%   type      'change' or 'add' or 'addfront'  auswechseln oder anhängen
%
% d                  Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%                    d.time = [0;0.01;0.02; ... ]
%                    d.F    = [1;1.05;1.10; ... ]
%                    ...
% u                  Unitstruktur mit Unitnamen
%                    u.time = 's'
%                    u.F    = 'N'
%                    ...
% c                  c-Struktur mit Kommentaren
%                    c.time = 'Zeit'
%                    c.F    = 'Kraft'

  if( ~exist('c','var') )
    c = [];
    cflag = 0;
  else
    cflag = 1;
  end
  
  if( strcmp('addfront',type) )  % change
    change_flag = 0;
    add_front   = 1;
  elseif( strcmp('add',type) )  % change
    change_flag = 0;
    add_front   = 0;
  else
    change_flag = 0;
    add_front   = 0;
  end

  c_dnames = fieldnames(d);
  n_dnames = length(c_dnames);
  
  nsig = length(Ssig);
  
  if( add_front )
    dd.(c_dnames{1}) = d.(c_dnames{1});
    if( isfield(u,c_dnames{1}) )
      uu.(c_dnames{1}) = u.(c_dnames{1});
    end
    if( cflag )
      if( isfield(c,c_dnames{1}) )
        cc.(c_dnames{1}) = c.(c_dnames{1});
      else
        cc.(c_dnames{1}) = '';
      end
    end
  end
  
  for isig = 1:nsig;
    
    if( isempty(Ssig(isig).name_in) )
      error('%s_error: Ssig(%i).name_in ist leer',mfilename,isig);
    end
    
    if( struct_find_f(d,Ssig(isig).name_in) ) 

      if( isempty(Ssig(isig).name_out) )
        error('%s_error: Ssig(%i).name_out ist leer (name_in:%s)',mfilename,isig,Ssig(isig).name_in);
      end
      
      % Suche, ob eine Einheit vorhanden, wenn ja nehme diese, ansonsten
      % aus der Liste
      if( isfield(u,Ssig(isig).name_in) && ~isempty(u.(Ssig(isig).name_in)) )
        unit_in = u.(Ssig(isig).name_in);
      else
        if( isempty(Ssig(isig).unit_in) )
          warning('%s_warning: Ssig(%i).unit_in ist leer wird ''-'' verwendet (name_in:%s)',mfilename,isig,Ssig(isig).name_in);
        end
        unit_in = Ssig(isig).unit_in;
        if( ~change_flag )
          u.(Ssig(isig).name_in) = Ssig(isig).unit_in;
        end
      end
     
      if( isempty(Ssig(isig).unit_out) )
        Ssig(isig).unit_out = unit_in;
      end
      [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,Ssig(isig).unit_out);
      
      if( ~isempty(errtext) )
        fprintf(errtext)
        error('%s_error: Für das Input-Signal: <%s> und Output-Signal <%s> wird keine Einheitsumrechnung gefunden !!!',mfilename,Ssig(isig).name_in,Ssig(isig).name_out);
      end
      if( add_front )
        dd.(Ssig(isig).name_out) = d.(Ssig(isig).name_in) * fac + offset;
        uu.(Ssig(isig).name_out) = Ssig(isig).unit_out;
      else
        d.(Ssig(isig).name_out) = d.(Ssig(isig).name_in) * fac + offset;
        u.(Ssig(isig).name_out) = Ssig(isig).unit_out;
      end
      if( cflag )
        if( add_front )
          if( isfield(c,Ssig(isig).name_in) )
            cc.(Ssig(isig).name_out) = [Ssig(isig).comment,'/',c.(Ssig(isig).name_in)];
          else
            cc.(Ssig(isig).name_out) = c.(Ssig(isig).name_in);
          end
        else
          if( isfield(c,Ssig(isig).name_in) )
            c.(Ssig(isig).name_out) = [Ssig(isig).comment,'/',c.(Ssig(isig).name_in)];
          else
            c.(Ssig(isig).name_out) = c.(Ssig(isig).name_in);
          end
        end
      end
      if( change_flag )
        d = rmfield(d,Ssig(isig).name_in);
        if( isfield(u,Ssig(isig).name_in) )
          u = rmfield(u,Ssig(isig).name_in);
        end
        if( cflag && isfield(c,Ssig(isig).name_in) )
          c = rmfield(c,Ssig(isig).name_in);
        end
      end
    end
  end
  
  if( add_front )
    for i=2:n_dnames
      dd.(c_dnames{i}) = d.(c_dnames{i});
      if( isfield(u,c_dnames{i}) )
        uu.(c_dnames{i}) = u.(c_dnames{i});
      end
      if( cflag )
        if( isfield(c,c_dnames{i}) )
          cc.(c_dnames{i}) = c.(c_dnames{i});
        else
          cc.(c_dnames{i}) = '';
        end
      end
    end
    
    d = dd;
    u = uu;
    if( cflag )
      c = cc;
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
