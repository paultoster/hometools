function eout = cg_read_tacc_channel_DsrdTraj(e,channel_name,use_old_names)

  eout = [];

  if( use_old_names )
    e = e_data_rename_signal(e,[channel_name,'_min_lateral_width'],[channel_name,'_minLateralWidth']);
    e = e_data_rename_signal(e,[channel_name,'_change_counter'],[channel_name,'_changeCounter']);
    e = e_data_rename_signal(e,[channel_name,'_curr_pos_idx'],[channel_name,'_currPosIdx']);
    e = e_data_rename_signal(e,[channel_name,'_lateral_control_quality'],[channel_name,'_lateralControlQuality']);
    e = e_data_rename_signal(e,[channel_name,'_lateral_control_priority'],[channel_name,'_lateralControlPriority']);
    e = e_data_rename_signal(e,[channel_name,'_world_coord'],[channel_name,'_worldCoord']);
    e = e_data_rename_signal(e,[channel_name,'_point_*'],[channel_name,'_pointFrnt_*']);
    e = e_data_rename_signal(e,[channel_name,'_p_rear_*'],[channel_name,'_pointRear_*']);   
  end
  
  c_names = fieldnames(e);
  n       = length(c_names);
  
  % leading_time_name
  if( isfield(e,[channel_name,'_timestamp']) )
    leading_time_name = [channel_name,'_timestamp'];
  elseif( isfield(e,[channel_name,'_header_timestamp']) )
    ifound = str_find_f(channel_name,'Pb','vs');
    if( ifound > 1 )
      leading_time_name = [channel_name(1:ifound-1),'_timestamp'];
    else
      leading_time_name = [channel_name,'_timestamp'];
    end
  else
    error('leading_time_name: %s must exist');
  end
  % Channels zerlegen

  
  % 1. Suche x-Vektor
  if( use_old_names )
    sname = '_pointFrnt_';
  else
    sname = '_point_';
  end
  s = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,sname,'mBuffer_'] ...
                           ,'x' ...
                           ,[channel_name,sname,'mBufferCnt']);  
                          
  eout = DsrdTraj_set_channel_struct(eout,s ...
                               ,[channel_name,sname,'x'] ...
                               ,'m' ...
                               ,'',leading_time_name);
    
  % 2. Suche y-Vektor
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,sname,'mBuffer_'] ...
                           ,'y' ...
                           ,[channel_name,sname,'mBufferCnt']);  
                          
  eout = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,sname,'y'] ...
                                  ,'m' ...
                                  ,'',leading_time_name);
  % 3. Suche x-Vektor Rueck
  if( use_old_names )
    sname = '_pointRear_';
  else
    sname = '_p_rear_';
  end
  s = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,sname,'mBuffer_'] ...
                           ,'x' ...
                           ,[channel_name,sname,'mBufferCnt']);  
                          
  eout = DsrdTraj_set_channel_struct(eout,s ...
                               ,[channel_name,sname,'x'] ...
                               ,'m' ...
                               ,'',leading_time_name);
  % 4. Suche y-Vektor
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,sname,'mBuffer_'] ...
                           ,'y' ...
                           ,[channel_name,sname,'mBufferCnt']);  
                          
  eout = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,sname,'y'] ...
                                  ,'m' ...
                                  ,'',leading_time_name);
  % 5. Suche c0-Vektor
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,'_curve_mBuffer_'] ...
                           ,'c0' ...
                           ,[channel_name,'_curve_mBufferCnt']);  
                          
  eout = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,'_curve_c0'] ...
                                  ,'1/m' ...
                                  ,'',leading_time_name);
                  
  % 6. Suche c1-Vektor
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,'_curve_mBuffer_'] ...
                           ,'c1' ...
                           ,[channel_name,'_curve_mBufferCnt']);  
                          
  [eout] = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,'_curve_c1'] ...
                                  ,'1/m/m' ...
                                  ,'',leading_time_name);
  % 7. Suche ds-Vektor
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,'_curve_mBuffer_'] ...
                           ,'ds' ...
                           ,[channel_name,'_curve_mBufferCnt']);  
                          
  [eout] = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,'_curve_ds'] ...
                                  ,'m' ...
                                  ,'',leading_time_name);
  % 8. Suche speed-Vektor
  if( use_old_names )
    sname = '_speed_speed';
  else
    sname = '_speed_v';
  end
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,'_speed_mBuffer_'] ...
                           ,'v' ...
                           ,[channel_name,'_speed_mBufferCnt']);  
                          
  [eout] = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,sname] ...
                                  ,'m/s' ...
                                  ,'',leading_time_name);
  % 8. Suche direction-Vektor
  if( use_old_names )
    sname = '_speed_direction';
  else
    sname = '_speed_dir';
  end
  [s] = DsrdTraj_get_channel_vec(e, c_names, n ...
                           ,[channel_name,'_speed_mBuffer_'] ...
                           ,'dir' ...
                           ,[channel_name,'_speed_mBufferCnt']);  
                          
  [eout] = DsrdTraj_set_channel_struct(eout,s ...
                                  ,[channel_name,sname] ...
                                  ,'enum' ...
                                  ,'',leading_time_name);
      
  
    for i=1:n
    
    switch(c_names{i})
%       case {[channel_name,'_pointFrnt_mBufferCnt'],[channel_name,'_pointRear_mBufferCnt'],[channel_name,'_curve_mBufferCnt'],[channel_name,'_speed_mBufferCnt']}
%        [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
%        eout.(c_names{i}).time = double(tin);
%        eout.(c_names{i}).vec  = double(vin);
%        eout.(c_names{i}).unit = 'enum';
%        eout.(c_names{i}).comment = '';
%        eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_timestamp']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'µs';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
       eout.(c_names{i}).leading_time_name     = leading_time_name;
      case {[channel_name,'_header_timestamp']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       nname                              = [channel_name,'_timestamp'];
       eout.(nname).time                  = double(tin);
       eout.(nname).vec                   = double(vin);
       eout.(nname).unit                  = 'µs';
       eout.(nname).comment               = '';
       eout.(nname).lin                   = 0;
       eout.(nname).leading_time_name     = leading_time_name;
      case {[channel_name,'_currPosIdx'],[channel_name,'_valid'],[channel_name,'_worldCoord'],[channel_name,'_lateralControlPriority'],[channel_name,'_lateralControlQuality'],[channel_name,'_changeCounter'],[channel_name,'_rampOutRequest']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
       eout.(c_names{i}).leading_time_name     = leading_time_name;
      case {[channel_name,'_curr_pos_idx'],[channel_name,'_world_coord'],[channel_name,'_lateral_control_priority'],[channel_name,'_lateral_control_quality'],[channel_name,'_change_counter'],[channel_name,'_ramp_out_request']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
       eout.(c_names{i}).leading_time_name     = leading_time_name;
      case {[channel_name,'_minLateralWidth'],[channel_name,'_minLateralWidthDist']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
       eout.(c_names{i}).leading_time_name     = leading_time_name;
      case {[channel_name,'_min_lateral_width'],[channel_name,'_min_lateral_width_dist']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
       eout.(c_names{i}).leading_time_name     = leading_time_name;
    end
    end
    if( use_old_names )
      if( ~isfield(eout,[channel_name,'_changeCounter']) && exist('tin','var') )
        name = [channel_name,'_changeCounter'];
        eout.(name).time = double(tin);
        eout.(name).vec  = double(tin)*0;
        eout.(name).unit = 'enum';
        eout.(name).comment = '';
        eout.(name).lin     = 0;
        eout.(c_names{i}).leading_time_name     = leading_time_name;
      end
    else
      if( ~isfield(eout,[channel_name,'_change_counter']) && exist('tin','var') )
        name = [channel_name,'_change_counter'];
        eout.(name).time = double(tin);
        eout.(name).vec  = double(tin)*0;
        eout.(name).unit = 'enum';
        eout.(name).comment = '';
        eout.(name).lin     = 0;
        eout.(c_names{i}).leading_time_name     = leading_time_name;
      end
    end 
  
      
end
function  s = DsrdTraj_get_channel_vec(e,c_names,n,vecname_vor,vec_name,nvec_name)

  s = [];
  % Vektorlänge suchen
  ifound = cell_find_f(c_names,nvec_name,'f');
  if( isempty(ifound) )
    warning('vektorlänge %s konnte nicht gefunden werden',nvec_name);
    return;
  end
  s.time = double(e.(nvec_name).time);
  s.n    = double(e.(nvec_name).vec);
  s.unit = '';

  % Leervektoren anlegen
  s.cvec = cell(length(s.time),1);
  for i = 1:length(s.time)
    nvec = s.n(i);
    vec  = zeros(nvec,1);
    s.cvec{i} = vec;
  end

  % Vektorteile in Channel suchen
  for i=1:n
    tt = c_names{i};
    % Vorbau suchen
    if( str_find_f(tt,vecname_vor,'vs') == 1 )
      tt = tt(length(vecname_vor)+1:length(tt));
%         [c_n,ncount] = str_split(tt,'_');
%       % Name suchen
%       if( (ncount == 2) && strcmp(c_n{2},vec_name) )
% 
%         % aktuelle Indexwert
%         i0 = str2num(c_n{1})+1; % Indexwert, wird ab null gezählt
      ifound = str_find_f(tt,vec_name,'vs');
      if( ifound > 0 )
        tnum = tt(1:ifound-1);
        tnum = str_cut_ae_f(tnum,'_');
        i0 = str2double(tnum)+1; 

        time = double(e.(c_names{i}).time);
        vec  = double(e.(c_names{i}).vec);
        unit = e.(c_names{i}).unit;

        % Diesen Vektor mit Zeit auf s verteilen
        for j=1:length(time)
           ind  = such_index(s.time,time(j));
           nind = s.n(ind);

           % aber nur wenn vorgegene Vektorlänge gegeben
           if( i0 <= nind )
             s.cvec{ind}(i0) = vec(j);
             s.unit          = unit;
           end
        end
      end
    end
  end
end
% function  s = DsrdTraj_get_channel_vec(e,c_names,n,vecname_vor,vec_name,nvec_name)
% 
%   s = [];
%   % Vektorlänge suchen
%   ifound = cell_find_f(c_names,nvec_name,'f');
%   if( isempty(ifound) )
%     warning('vektorlänge %s konnte nicht gefunden werden',nvec_name);
%     return;
%   end
%   s.time = double(e.(nvec_name).time);
%   s.n    = double(e.(nvec_name).vec);
%   s.unit = '';
% 
%   % Leervektoren anlegen
%   s.cvec = cell(length(s.time),1);
%   for i = 1:length(s.time)
%     nvec = s.n(i);
%     vec  = zeros(nvec,1);
%     s.cvec{i} = vec;
%   end
% 
%   % Vektorteile in Channel suchen
%   for i=1:n
%     tt = c_names{i};
%     % Vorbau suchen
%     if( str_find_f(tt,vecname_vor,'vs') == 1 )
%       tt = tt(length(vecname_vor)+1:length(tt));
%       [c_n,ncount] = str_split(tt,'_');
%       % Name suchen
%       if( (ncount == 2) && strcmp(c_n{2},vec_name) )
% 
%         % aktuelle Indexwert
%         i0 = str2num(c_n{1})+1; % Indexwert, wird ab null gezählt
% 
%         time = double(e.(c_names{i}).time);
%         vec  = double(e.(c_names{i}).vec);
%         unit = e.(c_names{i}).unit;
% 
%         % Diesen Vektor mit Zeit auf s verteilen
%         for j=1:length(time)
%            ind  = such_index(s.time,time(j));
%            nind = s.n(ind);
% 
%            % aber nur wenn vorgegene Vektorlänge gegeben
%            if( i0 <= nind )
%              s.cvec{ind}(i0) = vec(j);
%              s.unit          = unit;
%            end
%         end
%       end
%     end
%   end
% end
function   [e1] = DsrdTraj_set_channel_struct(e1,s,struct_name,struct_unit,struct_comment,leading_time_name)

  if( ~isempty(s) )
    n = length(s.time);
    if( n > 0 )

      e1.(struct_name).time = s.time;
      e1.(struct_name).vec = s.cvec;
      if( ~isempty(s.unit) )
        e1.(struct_name).unit = s.unit;
      else
        e1.(struct_name).unit = struct_unit;
      end
      e1.(struct_name).comment = struct_comment;
      e1.(struct_name).lin     = 0;
      
      if( exist('leading_time_name','var') )
        e1.(struct_name).leading_time_name = leading_time_name;
      end
    end
  end    
end
function  esim = DsrdTraj_get_sim_channels(e,c_names,n,vecname_vor,vec_name,unit,comment)

  esim = [];
  
  for i=1:n
    signame = c_names{i};
    i0 = str_find_f(signame,vecname_vor,'vs'); % Sucht den Vordernamen
    if( i0 > 0 )
      nsn     = length(signame);
      restname = signame(min(i0+length(vecname_vor),nsn):nsn); % Schneidet Vordernamen raus
      if( str_find_f(restname,vec_name,'vs') > 0 ) % Sucht den Namen
        esim.(signame).time = double(e.(signame).time);
        esim.(signame).vec  = double(e.(signame).vec);
        esim.(signame).unit = unit;
        esim.(signame).lin  = 0;
        esim.(signame).comment = comment;
      end
    end
  end
end
