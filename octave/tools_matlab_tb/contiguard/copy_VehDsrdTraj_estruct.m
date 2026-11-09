function e = copy_VehDsrdTraj_estruct(e,traj_name_in,traj_name_out,iPath)
%
% a = copy_VehDsrdTraj(e,traj_name_in,traj_name_out,iPath)
%
% e                            e-struct       Datenstruktur
% traj_name_in                 char         Input z.B. 'HAPSVehDsrdTraj'
% traj_name_out                char         Output z.B. 'VehDsrdTraj1'
% iPath                        int          welchem path in ArbiDev2Path
%                                           soll dieser Pfad zugeornet werden
%                           traj_name_in_pointFrnt_x
%                           traj_name_in_pointFrnt_y
%                           traj_name_in_pointRear_x
%                           traj_name_in_pointRear_y
%                              traj_name_in_curve_c0
%                              traj_name_in_curve_c1
%                              traj_name_in_curve_ds
%                           traj_name_in_speed_speed
%                       traj_name_in_speed_direction
%                         traj_name_in_changeCounter
%                            traj_name_in_currPosIdx
%                traj_name_in_lateralControlPriority
%                 traj_name_in_lateralControlQuality
%                             traj_name_in_timestamp
%                                 traj_name_in_valid
%                            traj_name_in_worldCoord
%                               traj_name_in_flagNew
%                               traj_name_in_app_name
%
%
% Ausgabe   a.name.time,a.name.vec,a.name.unit
%
% a.traj_name_out_pointFrnt_x
% a.traj_name_out_pointFrnt_y
% a.traj_name_out_pointFrnt_mBufferCnt
% a.traj_name_out_pointRear_x
% a.traj_name_out_pointRear_y
% a.traj_name_out_pointRear_mBufferCnt
% a.traj_name_out_curve_c0
% a.traj_name_out_curve_c1
% a.traj_name_out_curve_ds
% a.traj_name_out_curve_mBufferCnt
% a.traj_name_out_speed_speed
% a.traj_name_out_speed_direction
% a.traj_name_out_speed_mBufferCnt
% a.traj_name_out_changeCounter
% a.traj_name_out_currPosIdx
% a.traj_name_out_lateralControlPriority
% a.traj_name_out_lateralControlQuality
% a.traj_name_out_timestamp
% a.traj_name_out_valid
% a.traj_name_out_worldCoord
% a.traj_name_out_flagNew
% a.traj_name_out_iPath
% a.traj_name_out_app_name


  [e,cnew,~] = e_data_copy_signal(e,[traj_name_in,'*'],[traj_name_out,'*']);  
  
  ifound = cell_find_f(cnew,'pointFrnt_x','n');
  
  if( ~isempty(ifound) )
    old_flag = 1;
  else
    old_flag = 0;
  end
  
  if( old_flag )
    t3   = [traj_name_out,'_iPath'];
  else
    t3   = [traj_name_out,'_i_path'];
  end
  e = e_data_add_value(e,t3,'enum','',e.(cnew{1}).time,e.(cnew{1}).time*0.0+iPath,0);
  texist = cnew{1};
  
  if( old_flag )
    t2   = [traj_name_out,'_pointFrnt_mBufferCnt'];
    t3   = [traj_name_in,'_pointFrnt_x'];
  else
    t2   = [traj_name_out,'_point_mBufferCnt'];
    t3   = [traj_name_in,'_point_x'];
  end
  if( isfield(e,t3) )
    texist = t3;
    n = length(e.(t3).time);
    vec = zeros(n,1);
    for i=1:n
      vec(i) = length(e.(t3).vec{i});
    end

    e = e_data_add_value(e,t2,'enum','',e.(t3).time,vec,0);
    
    if( old_flag )    
      tin  = [traj_name_in,'_','pointFrnt_x'];
      tout = [traj_name_out,'_','pointFrnt_x'];
    else
      tin  = [traj_name_in,'_','point_x'];
      tout = [traj_name_out,'_','point_x'];
    end
    e.(tout)  = e.(tin);
    
    if( old_flag )    
      tin  = [traj_name_in,'_','pointFrnt_y'];
      tout = [traj_name_out,'_','pointFrnt_y'];
    else
      tin  = [traj_name_in,'_','point_y'];
      tout = [traj_name_out,'_','point_y'];
    end
    e.(tout)  = e.(tin);
   
  else
    % mBuffer
    e = e_data_add_value(e,t2,'enum','',e.(texist).time,e.(texist).time*0.0,0);

    % point
    vec = cell(1,length(e.(texist).time));
    if( old_flag )    
      tout = [traj_name_out,'_','pointFrnt_x'];
    else
      tout = [traj_name_out,'_','point_x'];
    end
    e = e_data_add_value(e,tout,'m','',e.(texist).time,vec,0);
    if( old_flag )    
      tout = [traj_name_out,'_','pointFrnt_y'];
    else
      tout = [traj_name_out,'_','point_y'];
    end
    e = e_data_add_value(e,tout,'m','',e.(texist).time,vec,0);
  end
  
  if( old_flag )
    t2   = [traj_name_out,'_pointRear_mBufferCnt'];
    t3   = [traj_name_in,'_pointRear_x'];
  else
    t2   = [traj_name_out,'_p_rear_mBufferCnt'];
    t3   = [traj_name_in,'_p_rear_x'];
  end
  if( isfield(e,t3) )
    
    n = length(e.(t3).time);
    vec = zeros(n,1);
    for i=1:n
      vec(i) = length(e.(t3).vec{i});
    end

    e = e_data_add_value(e,t2,'enum','',e.(t3).time,vec,0);
    if( old_flag )
      tin  = [traj_name_in,'_','pointRear_x'];
      tout = [traj_name_out,'_','pointRear_x'];
    else
      tin  = [traj_name_in,'_','p_rear_x'];
      tout = [traj_name_out,'_','p_rear_x'];
    end

    e.(tout)  = e.(tin);
    
    if( old_flag )
      tin  = [traj_name_in,'_','pointRear_y'];
      tout = [traj_name_out,'_','pointRear_y'];
    else
      tin  = [traj_name_in,'_','p_rear_y'];
      tout = [traj_name_out,'_','p_rear_y'];
    end

    e.(tout)  = e.(tin);
    
  else
    % mBuffer
    e = e_data_add_value(e,t2,'enum','',e.(texist).time,e.(texist).time*0.0,0);
    % point
    vec = cell(1,length(e.(texist).time));
    if( old_flag )
      tout = [traj_name_out,'_','pointRear_x'];
    else
      tout = [traj_name_out,'_','p_rear_x'];
    end
    e = e_data_add_value(e,tout,'m','',e.(texist).time,vec,0);
    if( old_flag )
      tout = [traj_name_out,'_','pointRear_y'];
    else
      tout = [traj_name_out,'_','p_rear_y'];
    end
    e = e_data_add_value(e,tout,'m','',e.(texist).time,vec,0);
  end

  t2   = [traj_name_out,'_curve_mBufferCnt'];
  t3   = [traj_name_in,'_curve_c0'];
  if( isfield(e,t3) )
    
    n = length(e.(t3).time);
    vec = zeros(n,1);
    for i=1:n
      vec(i) = length(e.(t3).vec{i});
    end

    e = e_data_add_value(e,t2,'enum','',e.(t3).time,vec,0);
    
    tin  = [traj_name_in,'_','curve_c0'];
    tout = [traj_name_out,'_','curve_c0'];

    e.(tout)  = e.(tin);
    
    tin  = [traj_name_in,'_','curve_c1'];
    tout = [traj_name_out,'_','curve_c1'];

    e.(tout)  = e.(tin);
    
    tin  = [traj_name_in,'_','curve_ds'];
    tout = [traj_name_out,'_','curve_ds'];

    e.(tout)  = e.(tin);
  else
    % mBugffer
    e = e_data_add_value(e,t2,'enum','',e.(texist).time,e.(texist).time*0.0,0);
    % c0,c1,ds
    vec = cell(1,length(e.(texist).time));
    tin  = [traj_name_in,'_','curve_c0'];
    tout = [traj_name_out,'_','curve_c0'];
    e = e_data_add_value(e,tout,'1/m','',e.(texist).time,vec,0);
    tin  = [traj_name_in,'_','curve_c1'];
    tout = [traj_name_out,'_','curve_c1'];
    e = e_data_add_value(e,tout,'1/m/m','',e.(texist).time,vec,0);
    tin  = [traj_name_in,'_','curve_ds'];
    tout = [traj_name_out,'_','curve_ds'];
    e = e_data_add_value(e,tout,'m','',e.(texist).time,vec,0);
  end
  
  if( old_flag )
    t2   = [traj_name_out,'_speed_mBufferCnt'];
    t3   = [traj_name_in,'_speed_speed'];
  else
    t2   = [traj_name_out,'_speed_mBufferCnt'];
    t3   = [traj_name_in,'_speed_v'];
  end
  if( isfield(e,t3) )
    
    n = length(e.(t3).time);
    vec = zeros(n,1);
    for i=1:n
      vec(i) = length(e.(t3).vec{i});
    end

    e = e_data_add_value(e,t2,'enum','',e.(t3).time,vec,0);
    
    if( old_flag )
      tin  = [traj_name_in,'_','speed_speed'];
      tout = [traj_name_out,'_','speed_speed'];
    else
      tin  = [traj_name_in,'_','speed_v'];
      tout = [traj_name_out,'_','speed_v'];
    end
    e.(tout)  = e.(tin);
    
    if( old_flag )
      tin  = [traj_name_in,'_','speed_direction'];
      tout = [traj_name_out,'_','speed_direction'];
    else
      tin  = [traj_name_in,'_','speed_dir'];
      tout = [traj_name_out,'_','speed_dir'];
    end
    e.(tout)  = e.(tin);
  else
    e = e_data_add_value(e,t2,'enum','',e.(texist).time,e.(texist).time*0.0,0);
    vec = cell(1,length(e.(texist).time));
    if( old_flag )
      tout = [traj_name_out,'_','speed_speed'];
    else
      tout = [traj_name_out,'_','speed_v'];
    end
    e = e_data_add_value(e,tout,'km/h','',e.(texist).time,vec,0);
    if( old_flag )
      tout = [traj_name_out,'_','speed_direction'];
    else
      tout = [traj_name_out,'_','speed_dir'];
    end
    e = e_data_add_value(e,tout,'enum','',e.(texist).time,vec,0);
  end
  
  if( old_flag )
    cliste = {'timestamp' ...
             ,'flagNew' ...
             ,'worldCoord' ...
             ,'valid' ...
             ,'lateralControlPriority' ...
             ,'lateralControlQuality' ...
             ,'changeCounter' ...
             ,'currPosIdx' ...
             };
  else
    cliste = {'timestamp' ...
             ,'flag_new' ...
             ,'world_coord' ...
             ,'valid' ...
             ,'lateral_control_priority' ...
             ,'lateral_control_quality' ...
             ,'change_counter' ...
             ,'curr_pos_idx' ...
             };
  end
  c_names = fieldnames(e);
  for i=1:length(cliste)
    
    tin  = [traj_name_in,'_',cliste{i}];
    tout = [traj_name_out,'_',cliste{i}];

    if( isempty(cell_find_f(c_names,tin,'n') ) )
      
      % fill with timestamp and set zero
      tin  = [traj_name_in,'_',cliste{1}];
      if( ~isempty(cell_find_f(c_names,tin,'n') ) )
        e.(tout)      = e.(tin);
        e.(tout).vec  = e.(tout).vec * 0.0; 
        e.(tout).unit = '-'; 
      else
        error('%s: keine Trajektorie %s gefunden',tin,traj_name_in);
      end
    else
      e.(tout)  = e.(tin);
    end
  end
  
  tout = [traj_name_out,'_app_name'];
  
  e.(tout).time = e.(cnew{1}).time;
  e.(tout).vec  = {};
  ii = str_find_f(traj_name_in,'VehDsrdTraj');
  if( ii > 0 )
    traj_name = traj_name_in(1:max(1,ii-1));
  else
    traj_name = traj_name_in;
  end

  for i=1:length(e.(tout).time)
    e.(tout).vec  = cell_add(e.(tout).vec ,traj_name);
  end
  e.(tout).lin  = 0;
  e.(tout).unit = '';
  
%   % mBufferCnt
%   t1   = [traj_name_out,'_pointFrnt','_x'];
%   t2   = [traj_name_out,'_pointFrnt','_mBufferCnt'];
%   
%   a.(t2).time    = a.(t1).time;
%   a.(t2).vec     = a.(t1).time*0.0;
%   a.(t2).unit    = 'enum';
%   a.(t2).lin     = 0;
%   a.(t2).comment = '';
%   for i= 1: length(a.(t2).time)
%     a.(t2).vec(i) = length(a.(t1).vec{i});
%   end
%     
%   t1   = [traj_name_out,'_pointRear','_x'];
%   t2   = [traj_name_out,'_pointRear','_mBufferCnt'];
%   
%   a.(t2).time    = a.(t1).time;
%   a.(t2).vec     = a.(t1).time*0.0;
%   a.(t2).unit    = 'enum';
%   a.(t2).lin     = 0;
%   a.(t2).comment = '';
%   for i= 1: length(a.(t2).time)
%     a.(t2).vec(i) = length(a.(t1).vec{i});
%   end
%     
%   t1   = [traj_name_out,'_curve','_c0'];
%   t2   = [traj_name_out,'_curve','_mBufferCnt'];
%   
%   a.(t2).time    = a.(t1).time;
%   a.(t2).vec     = a.(t1).time*0.0;
%   a.(t2).unit    = 'enum';
%   a.(t2).lin     = 0;
%   a.(t2).comment = '';
%   for i= 1: length(a.(t2).time)
%     a.(t2).vec(i) = length(a.(t1).vec{i});
%   end
%     
%   t1   = [traj_name_out,'_speed','_speed'];
%   t2   = [traj_name_out,'_speed','_mBufferCnt'];
%   
%   a.(t2).time    = a.(t1).time;
%   a.(t2).vec     = a.(t1).time*0.0;
%   a.(t2).unit    = 'enum';
%   a.(t2).lin     = 0;
%   a.(t2).comment = '';
%   for i= 1: length(a.(t2).time)
%     a.(t2).vec(i) = length(a.(t1).vec{i});
%   end
%   
%   
%   t3   = [traj_name_out,'_iPath'];
%   a.(t3).time    = a.(t1).time;
%   a.(t3).vec     = a.(t1).time*0.0+iPath;
%   a.(t3).unit    = 'enum';
%   a.(t3).lin     = 0;
%   a.(t3).comment = '';
    
end
% function [a,ua] = build_VehDsrdTraj_mess(d,u,a,ua,tin,data,tout)
% 
%   n = length(d.time);
%   
%   name_flagNew =[traj_name,'_flagNew'];
%   name_new_flagNew =[new_name,'_flagNew'];
%   a.(name_new_flagNew)  = d.time*0.0;
%   ua.(name_new_flagNew) = 'enum';
% 
%   name_Valid =[traj_name,'_valid'];
%   name_new_Valid =[new_name,'_valid'];
%   a.(name_new_Valid)  = d.time*0.0;
%   ua.(name_new_Valid) = 'enum';
% 
%   name_new_iPath =[new_name,'_iPath'];
%   a.(name_new_iPath)  = d.time*0.0+iPath;
%   ua.(name_new_iPath) = 'enum';
% 
%   name_worldCoord          = [traj_name,'_worldCoord'];
%   name_new_worldCoord      = [new_name,'_worldCoord'];
%   a.(name_new_worldCoord)  = d.time*0.0+iPath;
%   ua.(name_new_worldCoord) = 'enum';
% 
%   name_lateralControlPriority          = [traj_name,'_lateralControlPriority'];
%   name_new_lateralControlPriority      = [new_name,'_lateralControlPriority'];
%   a.(name_new_lateralControlPriority)  = d.time*0.0+iPath;
%   ua.(name_new_lateralControlPriority) = 'enum';
% 
%   name_lateralControlQuality          = [traj_name,'_lateralControlQuality'];
%   name_new_lateralControlQuality      = [new_name,'_lateralControlQuality'];
%   a.(name_new_lateralControlQuality)  = d.time*0.0+iPath;
%   ua.(name_new_lateralControlQuality) = 'enum';
%   
%   name_changeCounter          = [traj_name,'_changeCounter'];
%   name_new_changeCounter      = [new_name,'_changeCounter'];
%   a.(name_new_changeCounter)  = d.time*0.0+iPath;
%   ua.(name_new_changeCounter) = 'enum';
%   
%   name_currPosIdx          = [traj_name,'_currPosIdx'];
%   name_new_currPosIdx      = [new_name,'_currPosIdx'];
%   a.(name_new_currPosIdx)  = d.time*0.0+iPath;
%   ua.(name_new_currPosIdx) = 'enum';
%   
%   name_new_fa_mBufferCnt = [new_name,'_pointFrnt_mBufferCnt'];
%   a.(name_new_fa_mBufferCnt) = d.time*0.0;
%   ua.(name_new_fa_mBufferCnt) = 'enum';
% 
%   name_new_ra_mBufferCnt = [new_name,'_pointRear_mBufferCnt'];
%   a.(name_new_ra_mBufferCnt) = d.time*0.0;
%   ua.(name_new_ra_mBufferCnt) = 'enum';
% 
%   name_new_curve_mBufferCnt = [new_name,'_curve_mBufferCnt'];
%   a.(name_new_curve_mBufferCnt) = d.time*0.0;
%   ua.(name_new_curve_mBufferCnt) = 'enum';
% 
%   name_new_speed_mBufferCnt = [new_name,'_speed_mBufferCnt'];
%   a.(name_new_speed_mBufferCnt) = d.time*0.0;
%   ua.(name_new_speed_mBufferCnt) = 'enum';
% 
%   c_name_new_fa_x = cell(mBufferMax,1);
%   c_name_new_fa_y = cell(mBufferMax,1);
%   c_name_new_ra_x = cell(mBufferMax,1);
%   c_name_new_ra_y = cell(mBufferMax,1);
%   c_name_new_curve_c0 = cell(mBufferMax,1);
%   c_name_new_curve_c1 = cell(mBufferMax,1);
%   c_name_new_curve_ds = cell(mBufferMax,1);
%   c_name_new_speed_speed = cell(mBufferMax,1);
%   c_name_new_speed_direction = cell(mBufferMax,1);
% 
%   for i = 1:mBufferMax
%     c_name_new_fa_x{i} = [new_name,'_pointFrnt_mBuffer_',num2str(i-1),'_x'];
%     c_name_new_fa_y{i} = [new_name,'_pointFrnt_mBuffer_',num2str(i-1),'_y'];
%     a.(c_name_new_fa_x{i}) = d.time*0.0;
%     a.(c_name_new_fa_y{i}) = d.time*0.0;
%     ua.(c_name_new_fa_x{i}) = 'm';
%     ua.(c_name_new_fa_y{i}) = 'm';
%     
%     c_name_new_ra_x{i} = [new_name,'_pointRear_mBuffer_',num2str(i-1),'_x'];
%     c_name_new_ra_y{i} = [new_name,'_pointRear_mBuffer_',num2str(i-1),'_y'];
%     a.(c_name_new_ra_x{i}) = d.time*0.0;
%     a.(c_name_new_ra_y{i}) = d.time*0.0;
%     
%     c_name_new_curve_c0{i} = [new_name,'_curve_mBuffer_',num2str(i-1),'_c0'];
%     c_name_new_curve_c1{i} = [new_name,'_curve_mBuffer_',num2str(i-1),'_c1'];
%     c_name_new_curve_ds{i} = [new_name,'_curve_mBuffer_',num2str(i-1),'_ds'];
%     a.(c_name_new_curve_c0{i}) = d.time*0.0;
%     a.(c_name_new_curve_c1{i}) = d.time*0.0;
%     a.(c_name_new_curve_ds{i}) = d.time*0.0;
%     ua.(c_name_new_curve_c0{i}) = '1/m';
%     ua.(c_name_new_curve_c1{i}) = '1/m/m';
%     ua.(c_name_new_curve_ds{i}) = 'm';
%     
%     c_name_new_speed_speed{i} = [new_name,'_speed_mBuffer_',num2str(i-1),'_speed'];
%     c_name_new_speed_direction{i}   = [new_name,'_speed_mBuffer_',num2str(i-1),'_direction'];
%     a.(c_name_new_speed_speed{i}) = d.time*0.0;
%     a.(c_name_new_speed_direction{i})   = d.time*0.0;
%     ua.(c_name_new_speed_speed{i}) = 'm/s';
%     ua.(c_name_new_speed_direction{i})   = 'enum';
%   end
% 
%   name_fa_x    = [traj_name,'_pointFrnt_x'];
%   name_fa_y    = [traj_name,'_pointFrnt_y'];
%   name_ra_x    = [traj_name,'_pointRear_x'];
%   name_ra_y    = [traj_name,'_pointRear_y'];
%   name_curve_c0 = [traj_name,'_curve_c0'];
%   name_curve_c1 = [traj_name,'_curve_c1'];
%   name_curve_ds = [traj_name,'_curve_ds'];
%   name_speed_speed     = [traj_name,'_speed_speed'];
%   name_speed_direction = [traj_name,'_speed_direction'];
% 
% 
%   % pointFrnt
%   a.(name_new_flagNew) = d.(name_flagNew);
%   a.(name_new_Valid) = d.(name_Valid);
%   for i=1:n
%   
%     if( d.(name_flagNew)(i) )
%       if( ~isempty(d.(name_fa_x){i}) )      
% 
%         m = length(d.(name_fa_x){i});
%         a.(name_new_fa_mBufferCnt)(i) = m;
%         if( m > mBufferMax )
%           warning('%s: Der Vektor zu d.time(%i)=%f s ist länger als mBufferMax=%i',mfilename,i,d.time(i),mBufferMax);
%           m = mBufferMax;
%         end
% 
%         vekx = d.(name_fa_x){i};
%         veky = d.(name_fa_y){i};
%         for j=1:m
%           a.(c_name_new_fa_x{j})(i) = vekx(j);
%           a.(c_name_new_fa_y{j})(i) = veky(j);
%         end
%       end
%     
%       if( ~isempty(d.(name_ra_x){i}) )
% 
%         a.(name_new_flagNew)(i) = 1;
%         a.(name_new_Valid)(i)   = 1;
% 
%         m = length(d.(name_ra_x){i});
%         a.(name_new_ra_mBufferCnt)(i) = m;
%         if( m > mBufferMax )
%           warning('%s: Der Vektor zu d.time(%i)=%f s (Rear) ist länger als mBufferMax=%i',mfilename,i,d.time(i),mBufferMax);
%           m = mBufferMax;
%         end
% 
%         vekx = d.(name_ra_x){i};
%         veky = d.(name_ra_y){i};
%         for j=1:m
%           a.(c_name_new_ra_x{j})(i) = vekx(j);
%           a.(c_name_new_ra_y{j})(i) = veky(j);
%         end
%       end
%     
%       if( ~isempty(d.(name_curve_c0){i}) )
% 
%         a.(name_new_flagNew)(i) = 1;
%         a.(name_new_Valid)(i)   = 1;
% 
%         m = length(d.(name_curve_c0){i});
%         a.(name_new_curve_mBufferCnt)(i) = m;
%         if( m > mBufferMax )
%           warning('%s: Der Vektor zu d.time(%i)=%f s (curve) ist länger als mBufferMax=%i',mfilename,i,d.time(i),mBufferMax);
%           m = mBufferMax;
%         end
% 
%         vek1 = d.(name_curve_c0){i};
%         vek2 = d.(name_curve_c1){i};
%         vek3 = d.(name_curve_ds){i};
%         for j=1:m
%           a.(c_name_new_curve_c0{j})(i) = vek1(j);
%           a.(c_name_new_curve_c1{j})(i) = vek2(j);
%           a.(c_name_new_curve_ds{j})(i) = vek3(j);
%         end
%       end
%     
%       if( ~isempty(d.(name_speed_speed){i}) )
% 
%         a.(name_new_flagNew)(i) = 1;
%         a.(name_new_Valid)(i)   = 1;
% 
%         m = length(d.(name_speed_speed){i});
%         a.(name_new_speed_mBufferCnt)(i) = m;
%         if( m > mBufferMax )
%           warning('%s: Der Vektor zu d.time(%i)=%f s (speed) ist länger als mBufferMax=%i',mfilename,i,d.time(i),mBufferMax);
%           m = mBufferMax;
%         end
% 
%         vekx = d.(name_speed_speed){i};
%         veky = d.(name_speed_direction){i};
%         for j=1:m
%           a.(c_name_new_speed_speed{j})(i) = vekx(j);
%           a.(c_name_new_speed_direction{j})(i)   = veky(j);
%         end
%       end
%       
%       i1 = i;
%       while(d.(name_flagNew)(i1) == 0 )
%         if( i1 <= 1 )
%           break;
%         end
%         i1 = i1-1;
%       end
%       i2 = i;
%       while(d.(name_flagNew)(i2) == 0 )
%         if( i2 >= n )
%           break;
%         end
%         i2 = i2+1;
%       end
%       
%       if( d.(name_flagNew)(i1) && d.(name_flagNew)(i2) )
%         di1 = i-i1;
%         di2 = i2-i;
%         if( di2 > di1 )
%           ii = i1;
%         else
%           ii = i2;
%         end
%       elseif( d.(name_flagNew)(i1) )
%         ii = i1;
%       elseif( d.(name_flagNew)(i2) )
%         ii = i2;
%       else
%         ii = -1;
%       end
%       if( ii > -1 )
%         a.(name_new_worldCoord)(i) = d.(name_worldCoord)(ii);
%         a.(name_new_lateralControlPriority)(i) = d.(name_lateralControlPriority)(ii);
%         a.(name_new_lateralControlQuality)(i) = d.(name_lateralControlQuality)(ii);
%         a.(name_new_changeCounter)(i) = d.(name_changeCounter)(ii);
%         a.(name_new_currPosIdx)(i) = d.(name_currPosIdx)(ii);
%       end
%     end
%   end
% end
% function   [a,ua] = build_VehDsrdTraj_copy(a,ua,d,name_old,name_new,unit_new)
% 
%   if( isfield(d,name_old) )
%     a.(name_new)  = d.(name_old);
%     ua.(name_new) = unit_new;
%   end
%   
% end