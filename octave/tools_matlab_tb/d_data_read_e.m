function [d,u,c] = d_data_read_e(e,delta_t,zero_time,tstart,tend,timeout)
%
% [d,u,c] = d_data_read_e(e[,delta_t,zero_time,tstart,tend,timeout])
%
% E-struktur in d-Struktur überführen
%
%    e.('signame').time    zeitvektor
%    e.('signame').vec     Wertevektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%    e.('signame').lin     1  linear interpolieren
%                          0  konstant interpolieren
%    e.('signame').leading_time_name    Damit wird alle mit diesem Namen
%                                       versehenen Vektoren mit dieser Zeitbasis aus e gleich in d-STruktur
%                                       gewandelt
%    oder Parameter:
%    e.('signame').param   Wert oder Vektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%
%    delta_t     Zeitschritt, damit wird d.time gebildet
%    zero_time   soll die Zeit auf null gestellt werden
%    tstart      Wenn begrenzt werden soll, tstart > 0  < tend  (default -1.)
%    tend        Wenn begrenzt werden soll, tend > 0  > tstart  (default -1.)
%    timeout     Wenn keine Daten innerhalb timeout kommen, dann wird null
%                gesetzt (default -1. abgeschaltet)
%
% Ausgabe:
%    d.('signame')    Wertevektor (erster ist immer time)
%    u.('signame')    Einheit
%    c.('signame')    Kommentar
%

  % delta_t          time step to build d.time
  if( ~exist('delta_t','var') )
    delta_t = 0.01;
  end
  % zero_time        0/1 zero time in vector d.time 
  if( ~exist('zero_time','var') )
    zero_time = 1;
  end
  % tstart           start time, if to cut measurement q.tstart < 0 has no influence
  %                    (default -1.)
  if( ~exist('tstart','var') )
    tstart = -1;
  end
  % q.tend             end time, if to cut measurement q.tend < 0 has no influence
  %                    (default -1.)
  if( ~exist('tend','var') )
    tend = -1;
  end
  
  if( ~exist('timeout','var') )
    timeout = -1;
  end
  
  d = [];
  u = [];
  c = [];
  
  if( struct_isempty(e) )
    warning('Warn:emty','%s_warn: e-struktur is empty',mfilename);
    return
  else
    [okay,e] = e_data_check(e);
  end
  % Namen der e-Struktur
  c_name = fieldnames(e);
  n      = length(c_name);
  

  % Anfangszeit t0
  % Endzeit t1
  t0 = 1e300;
  t1 = 0;
  for i=1:n
    try
      if( e_data_is_timevec(e,c_name{i}) )
        t0 = min(t0,e.(c_name{i}).time(1));
        t1 = max(t1,max(e.(c_name{i}).time));
      end
    catch
      error('output e.%s.time ist nicht korrupt',c_name{i})
    end
  end
  
  if( (tstart >= 0.0) && (tstart > t0) ), t0 = tstart;end
  if( (tend >= 0.0) && (tend < t1) ), t1 = tend;end
  
  % Zeitvektor
  d.time = transpose(t0:delta_t:t1);
  %nt     = length(d.time);
  u.time = 's';
  c.time = 'Zeitvektor';
  d.time = double(d.time);
  
  
  % Bilde Liste mit leading_time_name
  liste_ltn = {};
  liste_ltn_index = [];
  liste_ltn_cindex = {};
  for i=1:n
    name = c_name{i};
    if( e_data_is_timevec(e,name) )
      if( isfield(e.(name),'leading_time_name') && ~isempty(e.(name).('leading_time_name')) )
        liste_ltn_index = [liste_ltn_index;i]; %#ok<*AGROW>
        ifound = cell_find_f(liste_ltn,e.(name).('leading_time_name'),'f');

        if( isempty(ifound) )
          liste_ltn = cell_add(liste_ltn,e.(name).('leading_time_name'));
          liste_ltn_cindex{length(liste_ltn_cindex)+1} = i;
        else
          liste_ltn_cindex{ifound(1)} = [liste_ltn_cindex{ifound(1)};i];        
        end
      end
    end
  end

  for i=1:n
%      if( strcmp(c_name{i},'VehiclePose_flagNew') )
%       a = 0;
%      end
    name = c_name{i};
    %======================================================================
    % Zeitvektor
    %======================================================================
    if( e_data_is_timevec(e,name) )
      % Wenn dieses Signal nicht in der Liste mit leading time names zu
      % finden sind
      if( isempty(find_val_in_vec(liste_ltn_index,i,0.5)) ) 
        
        if( isfield(e.(name),'timeout') && ~isempty(e.(name).('timeout')) )
          ttimeout = e.(name).('timeout');
        else
          ttimeout = timeout;
        end
        if( ~isfield(e.(name),'time') || isempty(e.(name).time) )
          warning('Warn:time','e.(''%s'')-STruktur hat keinen Vektor time',name);
          e.(name).time = 0.0;
          e.(name).vec = 0.0;
        end
        if( ~isfield(e.(name),'vec') || isempty(e.(name).vec) )
          warning('Warn:vec','e.(''%s'')-STruktur hat keinen Vektor vec',name);
          e.(name).vec = e.(name).time * 0.0;
        end
        if( ~isfield(e.(name),'lin') || isempty(e.(name).lin) )
          if( ~isfield(e.(name),'unit') || isempty(e.(name).unit) )
            e.(name).lin = 0;
          elseif( strcmpi(e.(name).unit,'enum') )
            e.(name).lin = 0;
          else
            e.(name).lin = 1;
          end
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

          d.(name) = d_data_read_e_cell_array(e.(name).time,e.(name).vec,d.time);

        elseif( isnumeric(e.(name).vec) )

          if( e.(name).lin )
            if( ttimeout > 0.0 ) % Beachtung von Timeout

              try
                d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,1,1,ttimeout);
                % d.(name) = interp1_linear_extrap_timeout(e.(name).time,double(e.(name).vec),d.time,ttimeout);
              catch exception
                warning('Warn:interpol','lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
                fflag = 0;
              end
            else
              try
                d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,1,0,-1.0);
                % d.(name) = interp1_linear_extrap_const(e.(name).time,double(e.(name).vec),d.time);
              catch exception
                warning('Warn:interpol','lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
                fflag = 0;
              end
            end
          else
            if( ttimeout > 0.0 ) % Beachtung von Timeout
              try
                d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,0,1,ttimeout);
                % d.(name) = interp1_const_extrap_timeout(e.(name).time,double(e.(name).vec),d.time,ttimeout);
              catch exception
                warning('Warn:interpol','lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
                fflag = 0;
              end
            else
             try
              d.(name) = mex_interpolation(double(e.(name).time),double(e.(name).vec),d.time,0,0,-1.0);
              % d.(name) = interp1_const(e.(name).time,e.(name).vec,d.time);
              catch exception
                warning('Warn:interpol','lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
                fflag = 0;
              end
            end
          end
        end 
        if( fflag )
          %nd = length(d.(name));
          try
          % Einheit
          u.(name)  = e.(name).unit;
          % Comment
          if( isfield(e.(name),'comment') )
            c.(name) = e.(name).comment;
          else
            c.(name) = '';
          end
          catch
            a = 0;
          end
        end
      end
    %======================================================================
    % Parameter
    %======================================================================
    elseif( e_data_is_param(e,name) )
      d.(name) = e.(name).param;
      u.(name) = e.(name).unit;
      c.(name) = e.(name).comment;
    end
  end
  
  % leading_name_liste
  
  for i=1:length(liste_ltn_cindex)
    
    
    leading_time_name = liste_ltn{i};
    
    time_vec = double(e.(leading_time_name).time);
    ie_vec = transpose(1:1:length(time_vec));
    if( isfield(e.(leading_time_name),'timeout') && ~isempty(e.(leading_time_name).('timeout')) )
      ttimeout = e.(leading_time_name).('timeout');
    else
      ttimeout = timeout;
    end
    fflag = 1;
    if( ttimeout > 0.0 ) % Beachtung von Timeout
%       if( strcmp(leading_time_name,'HAPSVehDsrdTraj_timestamp') )
%         a = 0;
%       end
      try
        index_vec = mex_interpolation(time_vec,ie_vec,d.time,0,1,ttimeout);
        % d.(name) = interp1_const_extrap_timeout(e.(name).time,double(e.(name).vec),d.time,ttimeout);
      catch exception
        warning('Warn:interpol','lineare Interpolation mit leading_time_name: <%s> gescheitert\n%s',leading_time_name,getReport(exception)); 
        fflag = 0;
      end
    else
     try
      index_vec = mex_interpolation(time_vec,ie_vec,d.time,0,0,-1.0);
      % d.(name) = interp1_const(e.(name).time,e.(name).vec,d.time);
      catch exception
        warning('Warn:interpol','lineare Interpolation mit leading_time_name: <%s> gescheitert\n%s',leading_time_name,getReport(exception)); 
        fflag = 0;
     end
    end
    if( fflag )
      
      index_vec = round(index_vec);
      
      index_start = 0;
      for k=1:length( index_vec )
        if( index_vec(k) > 0.5 )
          index_start = k;
          break;
        end
      end
      if( index_start )
      
        index_liste = liste_ltn_cindex{i};
        for j=1:length(index_liste)
          index = index_liste(j);
          name  = c_name{index};

          if(  str_find_f(name,'_flagNew','vs') ) % flagnew wenn null dann FalgNew auch null         
            d.(name) = min(index_vec,1.0);
          else % andere Signale

            if( iscell(e.(name).vec)  && isnumeric(e.(name).vec{1}) ) % cell array
              cellflag = 1;
            else
              cellflag = 0;
            end
            for k=1:length( index_vec )
              
              if( (k == 2386) )
                a =1;
              end
              if( k <= index_start )
                if( cellflag )
                  d.(name){k} = e.(name).vec{index_vec(index_start)};
                else
                  d.(name)(k) = e.(name).vec(index_vec(index_start));
                end
              elseif( index_vec(k) < 0.5 )
                if( cellflag )
                  d.(name){k} = d.(name){k-1};
                else
                  d.(name)(k) = d.(name)(k-1);
                end
              else
                if( cellflag )
                  d.(name){k} = e.(name).vec{index_vec(k)};
                else
                  try
                  d.(name)(k) = e.(name).vec(index_vec(k));
                  catch
                    a = 0;
                  end
                end
              end
            end
          end
        end
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
  
  if( zero_time )
    d.time = d.time - d.time(1);
  end
end
function scell1 = d_data_read_e_cell_array(time0,scell0,time1)

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

