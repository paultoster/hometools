function [d,u,c] = d_data_merge_e(d,u,c,e)
%
% [d,u,c] = d_data_merge_e(d,u,c,e)
%
% E-struktur in bestehende d-Struktur mergen
%
%    e.('signame').time    zeitvektor
%    e.('signame').vec     Wertevektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%    e.('signame').lin     1 linear interpolieren
%                          0 konstant interpolieren
%
%
% Ausgabe: Mit d.time wird das Signal erzeugt:
%
%    d.('signame')    Wertevektor (erster ist immer time)
%    u.('signame')    Einheit
%    c.('signame')    Kommentar
%
    
  if( isempty(e) )
    warning('%s_warn: e-struktur is empty',mfilename);
    return
  end
  % Namen der e-Struktur
  c_name = fieldnames(e);
  n      = length(c_name);
  
  for i=1:n
    name = c_name{i};
    if( ~isfield(e.(name),'time') || isempty(e.(name).time) )
      warning('e.(''%s'')-STruktur hat keinen Vektor time',name);
      e.(name).time = 0.0;
      e.(name).vec = 0.0;
    end
    if( ~isfield(e.(name),'vec') || isempty(e.(name).vec) )
      warning('e.(''%s'')-STruktur hat keinen Vektor vec',name);
      e.(name).vec = e.(name).time * 0.0;
    end
    if( ~isfield(e.(name),'lin') || isempty(e.(name).lin) )
      e.(name).lin = 0;
    end
    if( ~is_monoton_steigend(e.(name).time) )
      if( isnumeric(e.(name).vec) )
        
        gg.time = e.(name).time;
        gg.vec  = e.(name).vec;
        gg = d_data_elim_not_aequidist_in_struct(gg,'time',0.5);
        % gg = d_data_sort_vector_in_struct(gg,'time',1);
        % gg = d_data_elim_min_delta_vector_in_struct(gg,'time');
        e.(name).time = gg.time;
        e.(name).vec  = gg.vec;
        if( ~is_monoton_steigend(e.(name).time) )
          figure
          plot(e.(name).time)
          title(['time(',name,')'])
          figure
          plot(diff(e.(name).time))
          title(['diff(time(',name,'))'])
          error('Zeitvektor von Signal <%s> is nicht monoton steigend',name);
        end
      else
        error('Zeitvektor von Signal <%s> is nicht monoton steigend',name);
      end
    end
    
    fflag = 1;
    if( iscell(e.(name).vec)  && isnumeric(e.(name).vec{1}) )
      
      d.(name) = d_data_merge_e_cell_array(e.(name).time,e.(name).vec,d.time);
      
    elseif( isnumeric(e.(name).vec) )
   
      if( e.(name).lin )
        try
          d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,1,0,-1.0);
          % d.(name) = interp1_linear_extrap_const(e.(name).time,double(e.(name).vec),d.time);
        catch exception
          warning('lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
          fflag = 0;
        end
      else
       try
        d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,0,0,-1.0);
        % d.(name) = interp1_const(e.(name).time,e.(name).vec,d.time);
        catch exception
          warning('lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
          fflag = 0;
        end
      end
    end 
    if( fflag )
      nd = length(d.(name));

      % Einheit
      u.(name)  = e.(name).unit;
      % Comment
      if( isfield(e.(name),'comment') )
        c.(name) = e.(name).comment;
      else
        c.(name) = '';
      end
    end
  end
end
function scell1 = d_data_merge_e_cell_array(time0,scell0,time1)

  n1 = length(time1);
  if( n1 <= 1 )
    scell1 = {};
    return;
  else
    scell1 = cell(n1,1);
  end
  i0 = 1;
  n0 = length(time0);
  if( n0 <= 1 )
    return;
  end    
  fflag = 1;
  for i1=1:n1-1
    
    while( fflag == 1 )
      if( time1(i1) < time0(i0) )
        if( i0 == 1 )
          fflag = 2;
        else
          i0 = i0 - 1;
        end
      elseif( (i0<n0-1) )
        if( (time1(i1) >= time0(i0)) && (time1(i1) < time0(i0+1)) )
          fflag = 0;
        else
          i0 = i0 + 1;
        end
      else
          if( time1(i1) >= time0(n0) )
            i0 = n0;
            fflag = 3;
          else
            i0 = n0 -1;
            fflag = 0;
          end
      end
    end
    
    if( fflag == 0 )
      scell1{i1} = scell0{i0};
    else
      scell1{i1} = [];
    end
    fflag = 1;
  end  
end

