function q = make_plot_traj_seg_param(q)
%
% q.fig_num
% q.dina4
% q.numOfTraj
% q.pauseTime
% q.oneFigure
% q.plot_vel_over_s
% q.plotNMax
% q.axisEqual
% q.limOverAll
% q.useFA
% q.Axle
% q.AxleOA  oposite axle
% q.ntraj
% q.traj(i).name
% q.traj(i).time
% q.traj(i).dir_liste      .
% q.traj(i).dirvec            (anstatt dir_liste, vector anstatt cell array)
% q.traj(i).vvec_liste      .
% q.traj(i).FA.xvec_liste     .RA.
% q.traj(i).FA.yvec_liste     .RA.
% q.traj(i).FA.legText        ...
% q.traj(i).FA.legText        ...
% q.traj(i).FA.x0                     genereller Offset, der abgezogen wird
% q.traj(i).FA.y0                     genereller Offset 
% q.traj(i).FA.offsetX                offset plot-Verschiebung
% q.traj(i).FA.offsetY
% q.traj(i).FA.lineWidth
% q.traj(i).FA.lineStyle
% q.traj(i).FA.marker
% q.traj(i).FA.marker_size
% q.traj(i).FA.marker_size_di
% .
% .
% .
%
% q.negoPos                  
% q.egoPos(i).time           
% q.egoPos(i).FA.xvec           q.egoPos(i).RA.xvec
% q.egoPos(i).FA.yvec           q.egoPos(i).RA.yvec
% q.egoPos(i).FA.svec           q.egoPos(i).RA.svec
% q.egoPos(i).FA.dsvec          q.egoPos(i).RA.dsvec
% q.egoPos(i).FA.yawtangensvec  q.egoPos(i).RA.yawtangensvec
% q.egoPos(i).FA.name           .
% q.egoPos(i).FA.legText        .
% q.egoPos(i).FA.offsetX        .
% q.egoPos(i).FA.offsetY        
% q.egoPos(i).FA.lineWidth       
% q.egoPos(i).FA.lineStyle       
% q.egoPos(i).FA.marker       
% q.egoPos(i).FA.marker_size       
% q.egoPos(i).FA.marker_size_di  
% q.egoPos(i).yawvec
% q.egoPos(i).vvec

%  q.sdist.name
%  q.sdist.time
%  q.sdist.xvec
%  q.sdist.yvec

% q.waypoint(i).type
% q.waypoint(i).xPos
% q.waypoint(i).yPos
% q.waypoint(i).marker
% q.waypoint(i).legText

% plot parameter
%==========================================================================

  set_plot_standards
  % 
  
  q.nplo          = 0;


  q = struct_set_val(q,'dina4'            ,2    ,1);   % 1 Plottet Dina 4 hochkant
                                                       % 2 Plottet Dina 4 quer
                                                       %         ansonsten Matlabeinstellung 
  
  q = struct_set_val(q,'fig_num'             ,get_max_figure_num,1);   % number of trajectory in one plot
  q = struct_set_val(q,'numOfTraj'           ,2     ,1);   % number of trajectory in one plot
  q = struct_set_val(q,'pauseTime'           ,0.5   ,1);   % pause time during animation 
  q = struct_set_val(q,'oneFigure'           ,0     ,1);   % plot continously in one plot (or each time step in new plot)  
  q = struct_set_val(q,'build_s_from_traj1'  ,0     ,1);   % build distance from each segment with trajectory seperatly , nozt with input
  q = struct_set_val(q,'plot_vel_over_s'     ,0     ,1);   % plot continously in one plot (or each time step in new plot)
  q = struct_set_val(q,'plot_acc_over_s'     ,0     ,1);   % plot continously in one plot (or each time step in new plot)
  q = struct_set_val(q,'plot_dir_over_s'     ,0     ,1);   % plot continously in one plot (or each time step in new plot)
  q = struct_set_val(q,'plot_kappa_over_s'   ,0     ,1);   % plot continously in one plot (or each time step in new plot)
  q = struct_set_val(q,'plotNMax'            ,30    ,1);   % nmax-figure or nmax-trajectries 
  q = struct_set_val(q,'markerEgoPosStart'   ,'none',1);  % marker on start of egoPos
  q = struct_set_val(q,'markerEgoTime'       ,'none',1);      % marker on time of egoPos
  q = struct_set_val(q,'markerEgoDeltaTime'  ,0.5   ,1);      % marker on time of egoPos  
  q = struct_set_val(q,'axisEqual'           ,0     ,1);   % plot axis equal 
  q = struct_set_val(q,'limOverAll'          ,0     ,1);  % plot über den gesamten Raum
  q = struct_set_val(q,'useAxle'             ,q.const.FA,1);  % plot über den gesamten Raum

  if( q.useAxle == q.const.FA )
    q.Axle   = 'FA';
    q.AxleOA = 'RA';
  elseif( q.useAxle == q.const.RA )
    q.Axle   = 'RA';
    q.AxleOA = 'FA';
  elseif( q.useAxle == q.const.COG )
    q.Axle   = 'COG';
    q.AxleOA = 'COG';
  end
  
  %========================================================================
  % Trajektorie
  %========================================================================
  if( ~isfield(q,'traj') )
    q.traj = struct([]);
  end
  q.ntraj = length(q.traj);
  
  for i=1:q.ntraj
    q = set_param_check_traj(q,i);
  end
  
  if( (q.useAxle == q.const.FA) && isempty(q.traj(1).FA) )
    error('%s_err: q.useAxle = q.const.FA, but isempty(q.traj.FA)',mfilename);
  end
  if( (q.useAxle == q.const.RA) && isempty(q.traj(1).RA) )
    error('%s_err: q.useAxle = q.const.RA, but isempty(q.traj.RA)',mfilename);
  end
  if( (q.useAxle == q.const.COG) && isempty(q.traj(1).COG) )
    error('%s_err: q.useAxle = q.const.COG, but isempty(q.traj.COG)',mfilename);
  end
  
  
  %========================================================================
  % EgoPose
  %========================================================================
  q.negoPos = length(q.egoPos);

  for i=1:q.negoPos
    q = set_param_check_egoPos(q,i);
  end
  % erste Pose muss an Achse vorhanden sein
  if( q.useAxle == q.const.FA )
    if( isempty(q.egoPos(1).FA) )
      error('%s: length(q.egoPos(1).FA) ==  0 ; (q.useAxle == q.const.FA))',mfilename );
    end
  elseif( q.useAxle == q.const.RA )
    if( isempty(q.egoPos(1).RA) )
      error('%s: length(q.egoPos(1).RA) ==  0 ; (q.useAxle == q.const.RA))',mfilename );
    end
  else  % if( q.useAxle == q.const.COG )
    if( isempty(q.egoPos(1).COG) )
      error('%s: length(q.egoPos(1).COG) ==  0 ; (q.useAxle == q.const.COG))',mfilename );
    end
  end
  
  %========================================================================
  % sDist
  %========================================================================
  q = set_param_check_sDist(q);
  
  
  %========================================================================
  % waypoint
  %========================================================================
  q = set_param_check_waypoint(q);
  
  %========================================================================
  % recording
  %========================================================================
  q = set_param_check_recording(q);
  
end
    
function   q = set_param_check_traj(q,i)
  
  % Name
  if( ~check_val_in_struct(q.traj(i),'name'                  ,'char',1,0) )
    q.traj(i)  = struct_set_val(q.traj(i),'name',sprintf('%s%i','traj',i),1);  
  end
  % Vektoren
  check_val_in_struct(q.traj(i),'time'                       ,'num',1,1);
  check_val_in_struct(q.traj(i),'dir'                        ,'num',1,1);

  if( ~check_val_in_struct(q.traj(i),'vvec_liste'            ,'cell',1,0) )
    q.traj(i).vvec_liste = {};
  end
  
  if( ~check_val_in_struct(q.traj(i),'avec_liste'            ,'cell',1,0) )
    q.traj(i).avec_liste = {};
  end
  

  q = set_param_check_traj_Axle(q,'FA',i);
  q = set_param_check_traj_Axle(q,'RA',i);
  q = set_param_check_traj_Axle(q,'COG',i);
            

end
function  q = set_param_check_traj_Axle(q,Axle,i)
    
  if( ~isfield(q.traj(i),Axle) )
    q.traj(i).(Axle) = struct([]);
    return
  end
  if(  ~check_val_in_struct(q.traj(i).(Axle),'xvec_liste' ,'cell',1,0) ...
    || ~check_val_in_struct(q.traj(i).(Axle),'yvec_liste' ,'cell',1,0) )
    q.traj(i).(Axle) = struct([]);
    return
  end
  
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'legText'       ,sprintf('%s%s%i',q.traj(i).name,Axle,i)    ,1);
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'offsetX'       ,0.0                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'offsetY'       ,0.0                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'lineWidth'     ,1.0                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'lineStyle'     ,'-'                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'marker'        ,'+'                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'marker_size'   ,6                         ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'marker_size_di',0                         ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'x0'            ,0.0                       ,1);   
  q.traj(i).(Axle) = struct_set_val(q.traj(i).(Axle),'y0'            ,0.0                       ,1);   
 
%   % Prüfen ob etwas vorhanden
%   indexdelete = [];
%   n = length(traj.time);
%   if( n ~= length(traj.(Axle).xvec_liste) )
%     error('%s: length(traj(%i).time) !=  length(traj(%i).%s.xvec_liste)',mfilename,i,i,Axle )
%   end
%   if( n ~= length(traj.(Axle).yvec_liste) )
%     error('%s: length(traj(%i).time) !=  length(traj(%i).%s,yvec_liste)',mfilename,i,i,Axle )
%   end
%   flag = 1;
%   for j=1:length(traj.(Axle).xvec_liste)
%     if( ~isempty(traj.(Axle).xvec_liste{j}) )
%       flag = 0;
%       break;
%     end
%   end
%   if( flag )
%     if( i == 1 ) % in der ersten Trajektorie muss vorhanden sein
%       error( '%s: traj.%s.xvec_liste is empty',mfilename,Axle)
%     else
%       s = vec_find_values('type','equal','vec',indexdelete,'val',i,'tol',eps,'nlimmin',1);
%       if( isempty(s) )
%         indexdelete = [indexdelete;i];
%       end
%     end
%   end
%   for j=1:length(traj.(Axle).yvec_liste)
%     if( ~isempty(traj.(Axle).yvec_liste{j}) )
%       flag = 0;
%       break;
%     end
%   end
%   if( flag )
%     if( i == 1 ) % in der ersten Trajektorie muss vorhanden sein
%       error( '%s: traj(%i).yvec_liste is empty',mfilename,i)
%     else
%       s = vec_find_values('type','equal','vec',indexdelete,'val',i,'tol',eps,'nlimmin',1);
%       if( isempty(s) )
%         indexdelete = [indexdelete;i];
%       end
%     end
%   end
%   if( ~isempty(indexdelete) )
%     
%     for i=1:length(indexdelete)
%       traj(indexdelete(i)) = [];
%     end
%   end

end

function q = set_param_check_egoPos(q,i)
  
  % Name
  if( ~check_val_in_struct(q.egoPos(i),'name'                  ,'char',1,0) )
    q.egoPos(i)  = struct_set_val(q.egoPos(i),'name',sprintf('%s%i','egoPos',i),1);  
  end
  check_val_in_struct(q.egoPos(i),'time'               ,'num',1,1);
  
  q.egoPos(i).nvec = length(q.egoPos(i).time);
  
  q = set_param_check_egoPos_Axle(q,'FA',i);
  q = set_param_check_egoPos_Axle(q,'RA',i);
  q = set_param_check_egoPos_Axle(q,'COG',i);
  
  if(  ~check_val_in_struct(q.egoPos(i),'vvec' ,'num',1,0) )
    q.egoPos(i).vvec = [];
  else
    n = length(q.egoPos(i).time);
    if( n ~= length(q.egoPos(i).vvec) )
      error('%s: length(q.egoPos(%i).time) !=  length(egoPos(%i).vvec)',mfilename,i,i )
    end
  end
  
  if(  ~check_val_in_struct(q.egoPos(i),'avec' ,'num',1,0) )
    q.egoPos(i).avec = [];
  else
    n = length(q.egoPos(i).time);
    if( n ~= length(q.egoPos(i).avec) )
      error('%s: length(q.egoPos(%i).time) !=  length(egoPos(%i).avec)',mfilename,i,i )
    end
  end
end
  
function  q = set_param_check_egoPos_Axle(q,Axle,i)
    
  if( ~isfield(q.egoPos(i),Axle) )
    q.egoPos(i).(Axle) = struct([]);
    return
  end
  if(  ~check_val_in_struct(q.egoPos(i).(Axle),'xvec' ,'num',1,0) ...
    || ~check_val_in_struct(q.egoPos(i).(Axle),'yvec' ,'num',1,0) )
    q.egoPos(i).(Axle) = struct([]);
    return
  end
  
  % Prüfen ob etwas vorhanden
  n = length(q.egoPos(i).time);
  if( n ~= length(q.egoPos(i).(Axle).xvec) )
    error('%s: length(q.egoPos(%i).time) !=  length(egoPos(%i).(%s).xvec)',mfilename,i,i,Axle )
  end
  if( n ~= length(q.egoPos(i).(Axle).yvec) )
    error('%s: length(q.egoPos(%i).time) !=  length(egoPos(%i).(%s).yvec)',mfilename,i,i,Axle )
  end
  
  
  
  % Weg s bilden
  [q.egoPos(i).(Axle).svec,q.egoPos(i).(Axle).dsvec,q.egoPos(i).(Axle).yawtangensvec] = ...
    vek_2d_s_ds_alpha(q.egoPos(i).(Axle).xvec,q.egoPos(i).(Axle).yvec);

  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'legText'       ,sprintf('%s%s%i',q.egoPos(i).name,Axle,i)    ,1);
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'offsetX'       ,0.0                       ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'offsetY'       ,0.0                       ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'lineWidth'     ,1.0                       ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'lineStyle'     ,'-'                       ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'marker'        ,'+'                       ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'marker_size'   ,6                         ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'marker_size_di',0                         ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'x0'            ,0.0                        ,1);   
  q.egoPos(i).(Axle) = struct_set_val(q.egoPos(i).(Axle),'y0'            ,0.0                       ,1);   
end

function q = set_param_check_sDist(q)

  if( ~isfield(q,'sdist') )
    q.sdist = [];
    return
  end
  if(  ~check_val_in_struct(q.sdist,'name' ,'char',1,0) ...
    && ~check_val_in_struct(q.sdist,'xvec' ,'num',1,0) )
    q.sdist = [];
    return;
  end
  check_val_in_struct(q.sdist,'name' ,'char',1,1);
  check_val_in_struct(q.sdist,'time' ,'num',1,1); 
  check_val_in_struct(q.sdist,'xvec' ,'num',1,1); 
  check_val_in_struct(q.sdist,'yvec' ,'num',1,1); 

  sdist = struct_set_val(q.sdist,'x0',0.0,1);
  q.sdist = setfield(q.sdist,{1},'x0',sdist.x0);   
  sdist = struct_set_val(q.sdist,'y0',0.0,1);
  q.sdist = setfield(q.sdist,{1},'y0',sdist.y0);   

end

function q = set_param_check_waypoint(q)

  set_plot_standards
  if(  ~check_val_in_struct(q,'waypoint' ,'struct',1,0) )
    q.waypoint = [];
    return;
  end    
  if(  ~check_val_in_struct(q.waypoint,'type' ,'num',1,0) ...
    && ~check_val_in_struct(q.waypoint,'xPos' ,'num',1,0) )
    q.waypoint = [];
    return;
  end
  check_val_in_struct(q.waypoint,'type' ,'num',1,1);
  check_val_in_struct(q.waypoint,'xPos' ,'num',1,1); 
  check_val_in_struct(q.waypoint,'yPos' ,'num',1,1); 
  for i=1:length(q.waypoint)
    waypoint = struct_set_val(q.waypoint(i),'marker',PlotStandards.Marker{i},1);
    q.waypoint = setfield(q.waypoint,{i},'marker',waypoint.marker);
    tt = sprintf('waypoint%i(type:%i)',i,q.waypoint(i).type);
    waypoint = struct_set_val(q.waypoint(i),'legText',tt,1);
    q.waypoint = setfield(q.waypoint,{i},'legText',waypoint.legText);   
    
    waypoint = struct_set_val(q.waypoint(i),'x0',0.0,1);
    q.waypoint = setfield(q.waypoint,{i},'x0',waypoint.x0);   
    waypoint = struct_set_val(q.waypoint(i),'y0',0.0,1);
    q.waypoint = setfield(q.waypoint,{i},'y0',waypoint.y0);   
 end

end

function q = set_param_check_recording(q)
  set_plot_standards
  if(  ~check_val_in_struct(q,'recording' ,'struct',1,0) )
    q.recording = [];
    return;
  end   
  
  if(  ~check_val_in_struct(q.recording,'FA' ,'struct',1,0) )
    q.recording.FA = [];    
  else 
    q = set_param_check_recording_Axle(q,'FA');
  end
  if(  ~check_val_in_struct(q.recording,'RA' ,'struct',1,0) )
    q.recording.RA = [];    
  else 
    q = set_param_check_recording_Axle(q,'RA');
  end
  
end
function  q = set_param_check_recording_Axle(q,Axle)
    
  if(  ~check_val_in_struct(q.recording.(Axle),'xvec' ,'num',1,0) ...
    || ~check_val_in_struct(q.recording.(Axle),'yvec' ,'num',1,0) )
    q.recording.(Axle).(Axle) = struct([]);
    return
  end
  
  % Prüfen ob etwas vorhanden
  n = length(q.recording.(Axle).xvec);
  if( n ~= length(q.recording.(Axle).yvec) )
    error('%s: length(q.recording.%s.xvec) !=  length(q.recording.%s.yvec)',mfilename,Axle )
  end
  
  
  
  % Weg s bilden
  [q.recording.(Axle).svec,q.recording.(Axle).dsvec,q.recording.(Axle).yawtangensvec] = ...
    vek_2d_s_ds_alpha(q.recording.(Axle).xvec,q.recording.(Axle).yvec);

  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'legText'       ,sprintf('%s%s',q.recording.name,Axle)    ,1);
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'offsetX'       ,0.0                       ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'offsetY'       ,0.0                       ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'lineWidth'     ,1.0                       ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'lineStyle'     ,'-'                       ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'marker'        ,'o'                       ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'marker_size'   ,6                         ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'x0'            ,0.0                        ,1);   
  q.recording.(Axle) = struct_set_val(q.recording.(Axle),'y0'            ,0.0                       ,1);   
end
