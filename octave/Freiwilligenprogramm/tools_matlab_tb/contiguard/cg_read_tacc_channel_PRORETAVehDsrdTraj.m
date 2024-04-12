function eout = cg_read_tacc_channel_PRORETAVehDsrdTraj(e)

  eout = [];
  
  c_names = fieldnames(e);
  n       = length(c_names);
  % Channels zerlegen

  % 1. Suche x-Vektor
  s = PRORETAVehDsrdTraj_get_channel_vec(e, c_names, n ...
                           ,'PRORETAVehDsrdTraj_pointFrnt_mBuffer_' ...
                           ,'x' ...
                           ,'PRORETAVehDsrdTraj_pointFrnt_mBufferCnt');  
                          
  eout = PRORETAVehDsrdTraj_set_channel_struct(eout,s ...
                               ,'PRORETAVehDsrdTraj_pointFrnt_x' ...
                               ,'m' ...
                               ,'');
  % 2. Suche y-Vektor
  [s] = PRORETAVehDsrdTraj_get_channel_vec(e, c_names, n ...
                           ,'PRORETAVehDsrdTraj_pointFrnt_mBuffer_' ...
                           ,'y' ...
                           ,'PRORETAVehDsrdTraj_pointFrnt_mBufferCnt');  
                          
  eout = PRORETAVehDsrdTraj_set_channel_struct(eout,s ...
                                  ,'PRORETAVehDsrdTraj_pointFrnt_y' ...
                                  ,'m' ...
                                  ,'');

  % 3. Suche c0-Vektor
  [s] = PRORETAVehDsrdTraj_get_channel_vec(e, c_names, n ...
                           ,'PRORETAVehDsrdTraj_curve_mBuffer_' ...
                           ,'c0' ...
                           ,'PRORETAVehDsrdTraj_curve_mBufferCnt');  
                          
  eout = PRORETAVehDsrdTraj_set_channel_struct(eout,s ...
                                  ,'PRORETAVehDsrdTraj_curve_c0' ...
                                  ,'1/m' ...
                                  ,'');
                  
  % 4. Suche c1-Vektor
  [s] = PRORETAVehDsrdTraj_get_channel_vec(e, c_names, n ...
                           ,'PRORETAVehDsrdTraj_curve_mBuffer_' ...
                           ,'c1' ...
                           ,'PRORETAVehDsrdTraj_curve_mBufferCnt');  
                          
  [eout] = PRORETAVehDsrdTraj_set_channel_struct(eout,s ...
                                  ,'PRORETAVehDsrdTraj_curve_c1' ...
                                  ,'1/m/m' ...
                                  ,'');
  % 4. Suche ds-Vektor
  [s] = PRORETAVehDsrdTraj_get_channel_vec(e, c_names, n ...
                           ,'PRORETAVehDsrdTraj_curve_mBuffer_' ...
                           ,'ds' ...
                           ,'PRORETAVehDsrdTraj_curve_mBufferCnt');  
                          
  [eout] = PRORETAVehDsrdTraj_set_channel_struct(eout,s ...
                                  ,'PRORETAVehDsrdTraj_curve_ds' ...
                                  ,'m' ...
                                  ,'');

end
function  s = PRORETAVehDsrdTraj_get_channel_vec(e,c_names,n,vecname_vor,vec_name,nvec_name)

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
      [c_n,ncount] = str_split(tt,'_');
      % Name suchen
      if( (ncount == 2) && strcmp(c_n{2},vec_name) )

        % aktuelle Indexwert
        i0 = str2num(c_n{1})+1; % Indexwert, wird ab null gezählt

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
function   [e1] = PRORETAVehDsrdTraj_set_channel_struct(e1,s,struct_name,struct_unit,struct_comment)

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
    end
  end    
end
