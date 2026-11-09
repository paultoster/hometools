function [seg,nseg,q]    = make_plot_traj_seg_calc(q)
%
% setzt die Segmente q.p.s für jeden Wechsel mit change counter
% seg(iseg).dir          = -1/1   for/back
% seg(iseg).tStart                [s]  start time 
% seg(iseg).iStart                     index in measurement
% seg(iseg).ccStart                    cur_pos_idx start
% seg(iseg).tEnd                [s]  end time 
% seg(iseg).iEnd                     index in measurement
% seg(iseg).ccEnd                    cur_pos_idx end
% seg(iseg).ntraj              
% seg(iseg).traj(i).name   
% seg(iseg).traj(i).dirvec 
% seg(iseg).traj(i).svec      Bezogen sego als basis Bezugsgröße egoPose der benutzen Achse 
% seg(iseg).traj(i).FA.useFA   
% seg(iseg).traj(i).FA.xvec   
% seg(iseg).traj(i).FA.yvec   
% seg(iseg).traj(i).FA.svec   
% seg(iseg).traj(i).FA.dsvec   
% seg(iseg).traj(i).FA.yawtangensvec
% seg(iseg).traj(i).FA.sdistvec
% seg(iseg).traj(i).FA.nvec   
% seg(iseg).traj(i).FA.legText
% seg(iseg).traj(i).FA.offsetX
% seg(iseg).traj(i).FA.offsetY
% seg(iseg).traj(i).FA.lineWidth
% seg(iseg).traj(i).FA.lineStyle
% seg(iseg).traj(i).FA.marker   
% seg(iseg).traj(i).FA.marker_size
% seg(iseg).traj(i).FA.marker_size_di
% seg(iseg).traj(i).FA.unit          
% seg(iseg).traj(i).RA....
%
% seg(iseg).negoPos                      seg(iseg).negoRA
% seg(iseg).egoPos(i).FA.time               seg(iseg).egoRA(i).time
% seg(iseg).egoPos(i).FA.xvec
% seg(iseg).egoPos(i).FA.yvec
% seg(iseg).egoPos(i).FA.svec
% seg(iseg).egoPos(i).FA.dsvec   
% seg(iseg).egoPos(i).FA.yawtangensvec   
% seg(iseg).egoPos(i).FA.dirvec 
% seg(iseg).egoPos(i).FA.sdistvec
% seg(iseg).egoPos(i).FA.nvec   
% seg(iseg).egoPos(i).FA.legText
% seg(iseg).egoPos(i).FA.offsetX
% seg(iseg).egoPos(i).FA.offsetY
% seg(iseg).egoPos(i).FA.lineWidth
% seg(iseg).egoPos(i).FA.lineStyle
% seg(iseg).egoPos(i).FA.marker   
% seg(iseg).egoPos(i).FA.marker_size
% seg(iseg).egoPos(i).FA.marker_size_di
% seg(iseg).egoPos(i).FA.unit          
% seg(iseg).egoPos(i).RA....

% way point wir aufgenommen, wenn dieser innerhalb sdist von trj oder ego
% liegt

% seg(iseg).waypoint(i).type
% seg(iseg).waypoint(i).xPos
% seg(iseg).waypoint(i).yPos
% seg(iseg).waypoint(i).sdist

% q.recording.FA.useFA   
% q.recording.FA.xvec   
% q.recording.FA.yvec   
% q.recording.FA.svec   
% q.recording.FA.dsvec   
% q.recording.FA.yawtangensvec
% q.recording.FA.sdistvec
% q.recording.FA.nvec   
% q.recording.FA.legText
% q.recording.FA.offsetX
% q.recording.FA.offsetY
% q.recording.FA.lineWidth
% q.recording.FA.lineStyle
% q.recording.FA.marker   
% q.recording.FA.marker_size
% q.recording.FA.marker_size_di
% q.recording.FA.unit          
% q.recording.RA....


  [seg,nseg,q]    = plot_trajectory_calc_segments_with_traj(q);
  [seg,nseg,q]    = plot_trajectory_calc_segments_ego(seg,nseg,q);
  [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param(seg,nseg,q);
  [seg,nseg,q]    = plot_trajectory_calc_segments_set_waypoints(seg,nseg,q);
  [seg,nseg,q]    = plot_trajectory_calc_segments_minus_x0y0(seg,nseg,q);
  [seg,nseg,q]    = plot_trajectory_calc_minmax(seg,nseg,q);
  [q]             = plot_trajectory_calc_recording(q);
  
  %[e,q]    = plot_trajectory_calc_set_tstart_tend(e,q);

end

%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_segments_with_traj
%==========================================================================
%==========================================================================
%==========================================================================
function [seg,nseg,q]    = plot_trajectory_calc_segments_with_traj(q)
%  

  %========================================================================
  % Segmente werden nach der ersten Trajektorie gebildet
  %========================================================================

  %========================================================================
  % erste Trajektorie
  % Mit erster Trajektorie wird die Segmenteinteilung gemacht
  %========================================================================
  seg   = [];
  nseg  = 0;
  
  % Index mit dem nächsten Wert suchen  
  istart  = suche_index(q.traj(1).time,q.tStart,'====','v',0.001);
  iend  = suche_index(q.traj(1).time,q.tEnd,'====','v',0.001);
  
  
  ivec        = plot_trajectory_calc_segments_with_traj_ivec(q,istart,iend,q.Axle);  
  [seg,nseg]  = plot_trajectory_calc_segments_with_traj_seg(q,ivec,q.Axle,q.AxleOA,iend);
  
  % einteileilung der segmente mit erster Trajektorie
%   seg = plot_trajectory_calc_segments_with_traj_first(q,seg,istart,iend,q.traj(1),Axle,AxleOA);
%   
%   ntraj = length(q.traj);
%   for itraj=2:ntraj
%     seg = plot_trajectory_calc_segments_with_traj_next(q,seg,itraj,q.traj(itraj),Axle,AxleOA);
%   end
%   
%   nseg = length(seg);
  
end

function ivec = plot_trajectory_calc_segments_with_traj_ivec(q,i0,i1,Axle)

  ivec = [];
  
  % First trajectory:
  %------------------
  istart = 0;
  for i=i0:i1
    
    if( ~isempty(q.traj(1).(Axle).xvec_liste{i}) && ~isempty(q.traj(1).(Axle).yvec_liste{i}) )
      istart = i;
      break;
    end
  end
  
  % Path with same ponts in one segment
  %
  if( istart )
    ivec = [ivec;istart];
    xvec = q.traj(1).(Axle).xvec_liste{istart};
    yvec = q.traj(1).(Axle).yvec_liste{istart};
    
    for i=istart+1:i1
      
      if( ~isempty(q.traj(1).(Axle).xvec_liste{i}) && ~isempty(q.traj(1).(Axle).yvec_liste{i}) )
        
        % change suchen
        if( vek_2d_compare_path(q.traj(1).(Axle).xvec_liste{i},q.traj(1).(Axle).yvec_liste{i} ...
                               ,xvec,yvec,'change') )
          ivec = [ivec;i];
          xvec = q.traj(1).(Axle).xvec_liste{i};
          yvec = q.traj(1).(Axle).yvec_liste{i};
        end
      end      
      
    end
    
  end
  
  % weitere Unterteilung mit Richtungswechsel
  
end

function [seg,nseg]  = plot_trajectory_calc_segments_with_traj_seg(q,ivec,Axle,AxleOA,iend)

  % 1. collect the first trajectory into the segments
  %==================================================
  nseg = length(ivec);
  seg  = struct([]);
  for iseg=1:nseg
    
    seg(iseg).ntraj        = length(q.traj);
    
    index = ivec(iseg);

    seg(iseg).tStart       = q.traj(1).time(index);
    seg(iseg).iStart       = index;
    
    if( iseg > 1 )
      seg(iseg-1).tEnd       = q.traj(1).time(index);
      seg(iseg-1).iEnd       = index;
    end
    
    seg(iseg).traj(1).useAxle  = q.useAxle;
    seg(iseg).traj(1).name     = q.traj(1).name;  

    % Axle
    seg = plot_trajectory_calc_set_segments_traj_Axle(seg,iseg,1,q.traj(1),Axle,index);
    % AxleOA
    if( ~strcmp(Axle,AxleOA) && check_val_in_struct(q.traj(1),AxleOA,'struct',1,0) )
      seg = plot_trajectory_calc_set_segments_traj_Axle(seg,iseg,1,q.traj(1),AxleOA,index);
    end
   end
  
  seg(nseg).tEnd       = q.traj(1).time(iend);
  seg(nseg).iEnd       = index;
       
  % 2. distribute all next trajectories into the segments
  %======================================================
  for iseg=1:nseg
    for itraj=2:seg(iseg).ntraj

      seg(iseg).traj(itraj).useAxle  = q.useAxle;
      seg(iseg).traj(itraj).name     = q.traj(itraj).name; 


      % Axle
      seg = plot_trajectory_calc_set_segments_traj_Axle_by_time(seg,iseg,itraj,q.traj(itraj),Axle ...
                                                               ,seg(iseg).tStart,seg(iseg).tEnd);
      % AxleOA
      if(~strcmp(Axle,AxleOA) &&  check_val_in_struct(q.traj(itraj),AxleOA,'struct',1,0) )
        seg = plot_trajectory_calc_set_segments_traj_Axle_by_time(seg,iseg,itraj,q.traj(itraj),AxleOA ...
                                                                 ,seg(iseg).tStart,seg(iseg).tEnd);
      end
    end
  end
end
  
function seg = plot_trajectory_calc_segments_with_traj_first(q,seg,i0,i1,traj,Axle,AxleOA)
  TYPE_NEW            = 1;
  TYPE_DIR_CHANGE     = 2;
  
  for i=i0:i1

    if( ~isempty(traj.(Axle).xvec_liste{i}) && ~isempty(traj.(Axle).xvec_liste{i}) )

      % erstes Segment
      %---------------
      if( isempty(seg) )

        nseg = 1;
        % direction is changing?
        if( isempty(traj.dir_liste) )  % no dir_liste
          if( isempty(traj.dirvec) )   % no dirvec
            dir_change    = 0;
            seg(nseg).dir = 0;         % unknown
          else
            dir_change    = 0;
            seg(nseg).dir = traj.dirvec(i);
          end         
          
        elseif( plot_trajectory_calc_dir_is_changing(traj.dir_liste{i},1) )

          if( traj.cur_pos_idx(i) < 0 )
            error('%s: dir is changing but not cur_pos_idx',mfilename)
          end

          dir_change = 1;
        else
          dir_change = 0;
          seg(nseg).dir   = traj.dir_liste{i}(1);
        end

        
        seg(nseg).tStart       = traj.time(i);
        seg(nseg).iStart       = i;
        seg(nseg).ntraj        = 1;

        seg(nseg).traj(1).useFA  = q.useFA;
        seg(nseg).traj(1).name   = traj.name;  
        if( isempty(traj.dir_liste) )
          seg(nseg).traj(1).dirvec = [];
        else
          seg(nseg).traj(1).dirvec = traj.dir_liste{i};
        end
        % Axle
        seg = plot_trajectory_calc_set_segments_traj_Axle(seg,nseg,1,traj,Axle,i);

        if( check_val_in_struct(traj,AxleOA,'struct',1,0) )
          seg = plot_trajectory_calc_set_segments_traj_Axle(seg,nseg,1,traj,AxleOA,i);
        else
          seg(nseg).traj(1).(AxleOA) = struct([]);
        end
      % nach nächstem segment suchen
      %-----------------------------
      else

        found_new_traj_type = 0;

        flag_change = plot_trajectory_calc_is_traj_different(seg(nseg).traj.(Axle).xvec ...
                                                            ,seg(nseg).traj.(Axle).yvec ...
                                                            ,traj.(Axle).xvec_liste{i} ...
                                                            ,traj.(Axle).yvec_liste{i});
        if( flag_change  )
          %  neue Trajektorie
          found_new_traj_type = TYPE_NEW; % neue Trajektorie

          % Ende festlegen der noch aktuellen traj festlegen
          seg(nseg).tEnd       = traj.time(i-1);
          seg(nseg).iEnd       = i-1;
          if( check_val_in_struct(traj,'cur_pos_idx','num',1,0) )
            seg(nseg).ccEnd      = traj.cur_pos_idx(i-1);
          else
            seg(nseg).ccEnd      =  -1;
          end
        % mit Richtungswechsel
        elseif( dir_change )


          if( traj.cur_pos_idx(i) > seg(nseg).traj.(Axle).nvec  )
            error('%s: current pos ist größer als Trajektorie',mfilename)
          end
          % wenn sich current pos ändert, dann neues Segment
          i0 = max(1,traj.cur_pos_idx(i));
          if( seg(nseg).dir ~= traj.dir_liste{i}(i0) )

            found_new_traj_type = TYPE_DIR_CHANGE; %Richtungswechsel 

            seg(nseg).tEnd       = traj.time(i-1);
            seg(nseg).iEnd       = i-1;
            
            if( check_val_in_struct(traj,'cur_pos_idx','num',1,0) )
              seg(nseg).ccEnd      = traj.cur_pos_idx(i-1);
            else
              seg(nseg).ccEnd      =  -1;
            end
            
            if( isempty(seg(nseg).traj(1).dirvec) && ~isempty(traj.dirvec) )
              seg(nseg).traj(1).dirvec = traj.dirvec(seg(nseg).iStart:seg(nseg).iEnd);
            end
          end
        end


        % neues Segment
        if( found_new_traj_type ~= 0 )

          nseg = nseg+1;

          if( isempty(traj.dir_liste) )  % no dir_liste
            if( isempty(traj.dirvec) )   % no dirvec
              seg(nseg).dir            = 0;
              seg(nseg).traj(1).dirvec = [];
            else
              seg(nseg).dir            = traj.dirvec(i);
              seg(nseg).traj(1).dirvec = [];
            end
          else
            seg(nseg).dir            = traj.dir_liste{i}(1);
            seg(nseg).traj(1).dirvec = traj.dir_liste{i};
          end

          seg(nseg).tStart       = traj.time(i);
          seg(nseg).iStart       = i;
          seg(nseg).ntraj          = 1;

          seg(nseg).traj(1).name   = traj.name;
          % Axle
          seg = plot_trajectory_calc_set_segments_traj_Axle(seg,nseg,1,traj,Axle,i);

          if( check_val_in_struct(traj,AxleOA,'struct',1,0) )
            seg = plot_trajectory_calc_set_segments_traj_Axle(seg,nseg,1,traj,AxleOA,i);
          else
            seg(nseg).traj(1).(AxleOA) = struct([]);
          end

          % Richtungswechsel prüfen
          if( found_new_traj_type == TYPE_DIR_CHANGE )
            flag = plot_trajectory_calc_dir_is_changing(traj.dir_liste{i},seg(nseg).ccStart);
            if( ~flag )
              dir_change = 0;
            end
          end
        end
      end
    end

    % Ende
    if( i == i1 )
      seg(nseg).tEnd       = traj.time(i);
      seg(nseg).iEnd       = i;
      if( check_val_in_struct(traj,'cur_pos_idx','num',1,0) )
        seg(nseg).ccEnd      = traj.cur_pos_idx(i);
      else
        seg(nseg).ccEnd      = -1;
      end
      if( isempty(seg(nseg).traj(1).dirvec) && ~isempty(traj.dirvec) )
        seg(nseg).traj(1).dirvec = traj.dirvec(seg(nseg).iStart:seg(nseg).iEnd);
      end
    end
  end %for
  
end   
function seg = plot_trajectory_calc_segments_with_traj_next(q,seg,itraj,traj,Axle,AxleOA)
%
% 
  nseg  = length(seg);
  for iseg = 1:nseg
    
    i0  = suche_index(traj.time,seg(iseg).tStart,'====','v',0.001);
    i1  = suche_index(traj.time,seg(iseg).tEnd,'====','v',0.001);
      
    seg(iseg).ntraj                               = seg(iseg).ntraj + 1;
    seg(iseg).traj(itraj).useFA                   = q.useFA;
    seg(iseg).traj(itraj).name                    = traj.name;
    if( check_val_in_struct(traj,'dir_liste','cell',1,0) )
      seg(iseg).traj(itraj).dirvec                  = traj.dir_liste{i0};
    elseif( check_val_in_struct(traj,'dirvec','num',1,0) )
      seg(iseg).traj(itraj).dirvec                  = traj.dirvec(i0:i1);
    else
      seg(iseg).traj(itraj).dirvec                  = [];
    end
    % Axle
    seg = plot_trajectory_calc_set_segments_traj_Axle(seg,iseg,itraj,traj,Axle,i0);
    if( check_val_in_struct(traj,AxleOA,'struct',1,0) )
      seg = plot_trajectory_calc_set_segments_traj_Axle(seg,iseg,itraj,traj,AxleOA,i0);
    else
      seg(iseg).traj(itraj).(AxleOA) = struct([]);
    end
      
    
  end
  
  
end
%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_segments_ego
%==========================================================================
%==========================================================================
%==========================================================================
function [seg,nseg,q]    = plot_trajectory_calc_segments_ego(seg,nseg,q)

  %========================================================================
  % ego Base vector
  %========================================================================
  for iseg=1:nseg
    
    for iego = 1:length(q.egoPos)

      % Index der ersten egoPose mit dem nächsten Wert suchen  
      i0  = suche_index(q.egoPos(iego).time,seg(iseg).tStart,'====','v',0.001);
      i1  = suche_index(q.egoPos(iego).time,seg(iseg).tEnd,'====','v',0.001);

      egoPos.useAxle = q.useAxle;
      egoPos.name    = q.egoPos(iego).name;
      egoPos.time    = q.egoPos(iego).time(i0:i1);
      egoPos.vvec    = q.egoPos(iego).vvec(i0:i1);
      egoPos.avec    = q.egoPos(iego).avec(i0:i1);
      egoPos.yawvec  = q.egoPos(iego).yawvec(i0:i1);
        
      egoPos = ...
        plot_trajectory_calc_segments_ego_copy(egoPos,q.egoPos(iego),q.Axle,i0,i1);
      if( check_val_in_struct(q.egoPos(iego),q.AxleOA,'struct',1,0) )
        egoPos = ...
          plot_trajectory_calc_segments_ego_copy(egoPos,q.egoPos(iego),q.AxleOA,i0,i1);
      end
      egoPosV(iego) = egoPos;
    end
    seg(iseg).egoPos  = egoPosV;
    seg(iseg).negoPos = length(egoPosV);
  end
end
function segEgoPos = plot_trajectory_calc_segments_ego_copy(segEgoPos,egoPos,Axle,i0,i1)

        segEgoPos.nvec                  = i1-i0+1;
        segEgoPos.(Axle).xvec           = egoPos.(Axle).xvec(i0:i1);
        segEgoPos.(Axle).yvec           = egoPos.(Axle).yvec(i0:i1);
        segEgoPos.(Axle).svec           = egoPos.(Axle).svec(i0:i1);
        segEgoPos.(Axle).dsvec          = egoPos.(Axle).dsvec(i0:i1);
        segEgoPos.(Axle).yawtangensvec  = egoPos.(Axle).yawtangensvec(i0:i1);
        segEgoPos.(Axle).legText        = egoPos.(Axle).legText;
        segEgoPos.(Axle).offsetX        = egoPos.(Axle).offsetX;
        segEgoPos.(Axle).offsetY        = egoPos.(Axle).offsetY;
        segEgoPos.(Axle).lineWidth      = egoPos.(Axle).lineWidth;
        segEgoPos.(Axle).lineStyle      = egoPos.(Axle).lineStyle;
        segEgoPos.(Axle).marker         = egoPos.(Axle).marker;
        segEgoPos.(Axle).marker_size    = egoPos.(Axle).marker_size;
        segEgoPos.(Axle).marker_size_di = egoPos.(Axle).marker_size_di;
end
%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_segments_natural_param
%==========================================================================
%==========================================================================
%==========================================================================
function [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param(seg,nseg,q)

  if( q.build_s_from_traj1 )
    [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param_straj1(seg,nseg,q);
  else
    [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param_sdist(seg,nseg,q); 
  end
end
function [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param_sdist(seg,nseg,q)
  % check if sdist is set
  if( ~isempty(q.sdist) )

    % bilde einen s-Vector aus xvec und yvec    
    [q.sdist.svec,q.sdist.xvec,q.sdist.yvec] ...
      = vek_2d_build_s(q.sdist.xvec,q.sdist.yvec,length(q.sdist.xvec),0.0,0.01);
    % sdist für jedes segment
    for iseg=1:nseg
      % traj
      caxle = {'FA','RA','COG'};
      for itraj = 1:seg(iseg).ntraj
        for iAxle = 1:3
          Axle = caxle{iAxle};
          if( isfield(seg(iseg).traj(itraj),Axle) )

            
            if( ~isempty(seg(iseg).traj(itraj).(Axle)) && isfield(seg(iseg).traj(itraj).(Axle),'xvec') && ~isempty(seg(iseg).traj(itraj).(Axle).xvec) )
              [~,~,~,dPathVec,indexVec] = ...
              vek_2d_intersection_vec(q.sdist.xvec ...
                                     ,q.sdist.yvec ...
                                     ,seg(iseg).traj(itraj).(Axle).xvec ...
                                     ,seg(iseg).traj(itraj).(Axle).yvec ...
                                     ,seg(iseg).traj(itraj).(Axle).yawtangens ...
                                     ,1,1);
              seg(iseg).traj(itraj).(Axle).sdistvec = seg(iseg).traj(itraj).(Axle).xvec * 0.;                                                             
              for k=1:seg(iseg).traj(itraj).(Axle).nvec
                index = indexVec(k);
                dPath = dPathVec(k);
                s0    = q.sdist.svec(index);
                ii    = min(length(q.sdist.svec),index+1);
                s1    = q.sdist.svec(ii);
                seg(iseg).traj(itraj).(Axle).sdistvec(k) = s0 + dPath * (s1-s0);
                if(seg(iseg).traj(itraj).(Axle).sdistvec(k)> 46.758816131660140)
                  a = 0;
                end
              end
            end
          end
        end
      end
      
      % VehPose
      caxle = {'FA','RA','COG'};
      for iego = 1:seg(iseg).negoPos
        for iAxle = 1:length(caxle)
          Axle = caxle{iAxle};
          if( isfield(seg(iseg).egoPos(iego),Axle) )
            
            if( ~isempty(seg(iseg).egoPos(iego).(Axle)) )
              [~,~,~,dPathVec,indexVec] = ...
              vek_2d_intersection_vec(q.sdist.xvec ...
                                     ,q.sdist.yvec ...
                                     ,seg(iseg).egoPos(iego).(Axle).xvec ...
                                     ,seg(iseg).egoPos(iego).(Axle).yvec ...
                                     ,seg(iseg).egoPos(iego).yawvec ...
                                     ,1,1);
              seg(iseg).egoPos(iego).(Axle).sdistvec = seg(iseg).egoPos(iego).(Axle).xvec;                                                             
              for k=1:length(seg(iseg).egoPos(iego).(Axle).xvec)
                index = indexVec(k);
                dPath = dPathVec(k);
                s0    = q.sdist.svec(index);
                ii    = min(length(q.sdist.svec),index+1);
                s1    = q.sdist.svec(ii);
                seg(iseg).egoPos(iego).(Axle).sdistvec(k) = s0 + dPath * (s1-s0);
              end
            end
          end
        end
      end
    end
  end
end
function [seg,nseg,q]    = plot_trajectory_calc_segments_natural_param_straj1(seg,nseg,q)
  % sdist für jedes segment
  for iseg=1:nseg
    
    
    % traj
    caxle = {'FA','RA'};
    for iAxle = 1:2
    
      Axle = caxle{iAxle};
      % bilde einen s-Vector aus xvec und yvec 
      sdist.xvec = seg(iseg).traj(1).(Axle).xvec;
      sdist.yvec = seg(iseg).traj(1).(Axle).yvec;
      [sdist.svec,~,~] = vek_2d_s_ds_alpha(sdist.xvec,sdist.yvec);

      for itraj = 1:seg(iseg).ntraj
        
        if( itraj == 1 )
          seg(iseg).traj(itraj).(Axle).sdistvec = sdist.svec;
        else
      
          if( ~isempty(seg(iseg).traj(itraj).(Axle)) )
            [~,~,~,dPathVec,indexVec] = ...
            vek_2d_intersection_vec(sdist.xvec ...
                                   ,sdist.yvec ...
                                   ,seg(iseg).traj(itraj).(Axle).xvec ...
                                   ,seg(iseg).traj(itraj).(Axle).yvec ...
                                   ,seg(iseg).traj(itraj).(Axle).yawtangens ...
                                   ,1,1);
            seg(iseg).traj(itraj).(Axle).sdistvec = seg(iseg).traj(itraj).(Axle).xvec * 0.;                                                             
            for k=1:seg(iseg).traj(itraj).(Axle).nvec
              index = indexVec(k);
              dPath = dPathVec(k);
              s0    = sdist.svec(index);
              ii    = min(length(sdist.svec),index+1);
              s1    = sdist.svec(ii);
              seg(iseg).traj(itraj).(Axle).sdistvec(k) = s0 + dPath * (s1-s0);
            end
          end
        end
      end
    

      % VehPose
      for iego = 1:seg(iseg).negoPos
        
        if( ~isempty(seg(iseg).egoPos(iego).(Axle)) )
          [~,~,~,dPathVec,indexVec] = ...
          vek_2d_intersection_vec(sdist.xvec ...
                                 ,sdist.yvec ...
                                 ,seg(iseg).egoPos(iego).(Axle).xvec ...
                                 ,seg(iseg).egoPos(iego).(Axle).yvec ...
                                 ,seg(iseg).egoPos(iego).yawvec ...
                                 ,1,1);
          seg(iseg).egoPos(iego).(Axle).sdistvec = seg(iseg).egoPos(iego).(Axle).xvec;                                                             
          for k=1:length(seg(iseg).egoPos(iego).(Axle).xvec)
            index = indexVec(k);
            dPath = dPathVec(k);
            s0    = sdist.svec(index);
            ii    = min(length(sdist.svec),index+1);
            s1    = sdist.svec(ii);
            seg(iseg).egoPos(iego).(Axle).sdistvec(k) = s0 + dPath * (s1-s0);
          end
        end
      end
      
    end
  end
end
%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_segments_set_waypoints
%==========================================================================
%==========================================================================
%==========================================================================
function [seg,nseg,q]    = plot_trajectory_calc_segments_set_waypoints(seg,nseg,q)

  for iseg=1:nseg
    seg(iseg).waypoint = [];
    seg(iseg).nwaypoint = 0;
  end
  if( ~isempty(q.waypoint) && ~isempty(q.sdist) )
    for i=1:length(q.waypoint.xPos)
        [~,~,dPath,~,index] = ...
        vek_2d_intersection(q.sdist.xvec ...
                            ,q.sdist.yvec ...
                            ,q.waypoint.xPos(i) ...
                            ,q.waypoint.yPos(i) ...
                            ,0 ...
                            ,1 ...
                            ,1);
        s0    = q.sdist.svec(index);
        ii    = min(length(q.sdist.svec),index+1);
        s1    = q.sdist.svec(ii);
        q.waypoint.sdist(i) = s0 + dPath * (s1-s0);
        
        
        for iseg=1:nseg
          
          % prüft, ob Punkt indem Bereich ist
          % if( plot_trajectory_calc_segments_set_waypoints_fimd_in_seg(seg(iseg),q.waypoint(i).sdist) )
            seg(iseg).nwaypoint = seg(iseg).nwaypoint + 1;
            waypoint.sdist = q.waypoint.sdist(i);
            waypoint.xPos = q.waypoint.xPos(i);
            waypoint.yPos = q.waypoint.yPos(i);
            waypoint.marker = q.waypoint.marker(i);
            waypoint.legText = ['wp',num2str(i)];
            if(seg(iseg).nwaypoint==1)
              seg(iseg) = setfield(seg(iseg),{seg(iseg).nwaypoint},'waypoint',waypoint);
            else
              seg(iseg).waypoint(seg(iseg).nwaypoint) = waypoint;
            end
          % end
        end
    end
  end
end
% function okay = plot_trajectory_calc_segments_set_waypoints_fimd_in_seg(seg,sdist)
% 
%   okay = 0;
%   caxle = {'FA','RA'};
%   % traj
%   for itraj = 1:seg.ntraj
%     for iAxle = 1:2
%       Axle = caxle{iAxle};
%       if(  (sdist >= seg.traj(itraj).(Axle).sdistvec(1)) ...
%         && (sdist <= seg.traj(itraj).(Axle).sdistvec(end)) ...
%         )
%         okay = 1;
%         break;
%       end
%     end
%   end
%   % egoPos
%   if( ~okay )
%     for iego = 1:seg.negoPos
%       for iAxle = 1:2
%         Axle = caxle{iAxle};
%         if(  (sdist >= seg.egoPos(iego).(Axle).sdistvec(1)) ...
%           && (sdist <= seg.egoPos(iego).(Axle).sdistvec(end)) ...
%           )
%           okay = 1;
%           break;
%         end
%       end
%     end
%   end
% 
% end
function [seg,nseg,q]   = plot_trajectory_calc_segments_minus_x0y0(seg,nseg,q)

   for i=1:2
    if( i == 1 )
      Axle  = 'FA';
    else
      Axle  = 'RA';
    end
    for iseg = 1:nseg
      seg = build_minus_x0y0(seg,iseg,Axle,q);
    end
   end
    
  % waypoint
  
  % seg(iseg).waypoint(i).type
  % seg(iseg).waypoint(i).xPos
  % seg(iseg).waypoint(i).yPos
  % seg(iseg).waypoint(i).sdist
  for iseg = 1:nseg
    for iwaypoint = 1:seg(iseg).nwaypoint
      if( check_val_in_struct(seg(iseg).waypoint(iwaypoint),'xPos','num',1,0) )
        seg(iseg).waypoint(iwaypoint).xPos = seg(iseg).waypoint(iwaypoint).xPos ...
          - q.waypoint.x0; 
        seg(iseg).waypoint(iwaypoint).yPos = seg(iseg).waypoint(iwaypoint).yPos ...
          - q.waypoint.y0;
      end
    end
  end
    
      

    
end
function seg = build_minus_x0y0(seg,iseg,Axle,q)

  for jtraj= 1:seg(iseg).ntraj
    if( check_val_in_struct(seg(iseg).traj(jtraj),Axle,'struct',1,0) )
      
      seg(iseg).traj(jtraj).(Axle).xvec = seg(iseg).traj(jtraj).(Axle).xvec ...
        - q.traj(jtraj).(Axle).x0;
      seg(iseg).traj(jtraj).(Axle).yvec = seg(iseg).traj(jtraj).(Axle).yvec ...
        - q.traj(jtraj).(Axle).y0;
    end
  end
  for jego= 1:seg(iseg).negoPos
    if( check_val_in_struct(seg(iseg).egoPos(jego),Axle,'struct',1,0) )
      seg(iseg).egoPos(jego).(Axle).xvec = seg(iseg).egoPos(jego).(Axle).xvec ...
        - q.egoPos(jego).FA.x0;
      seg(iseg).egoPos(jego).(Axle).yvec = seg(iseg).egoPos(jego).(Axle).yvec ...
        - q.egoPos(jego).FA.y0;
    end
  end

end
%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_recording
%==========================================================================
%==========================================================================
%==========================================================================
function [q]    = plot_trajectory_calc_recording(q)

  %========================================================================
  % ego Base vector
  %========================================================================
  if( isfield(q,'recording') )
    if( isfield(q.recording,'FA') )
      q.recording.FA.xvec = q.recording.FA.xvec - q.recording.FA.x0;
      q.recording.FA.yvec = q.recording.FA.yvec - q.recording.FA.y0;
    end
    if( isfield(q.recording,'RA') )
      q.recording.RA.xvec = q.recording.RA.xvec - q.recording.RA.x0;
      q.recording.RA.yvec = q.recording.RA.yvec - q.recording.RA.y0;
    end
  end
end
%==========================================================================
%==========================================================================
%==========================================================================
% plot_trajectory_calc_minmax
%==========================================================================
%==========================================================================
%==========================================================================
function [seg,nseg,q]    = plot_trajectory_calc_minmax(seg,nseg,q)

  outvec = [1 ,5 ,10 , 20,  50,100]';
  invec  = [10,30,100,200,1000,10000];
  % min/max over all
  if( q.limOverAll )
    
    xmin = 1/eps;
    xmax = -1/eps;
    ymin = xmin;
    ymax = xmax;
    smin = xmin;
    smax = xmax;
    sdistmin = xmin;
    sdistmax = xmax;
    
    for i=1:2
      if( i == 1 )
        Axle  = 'FA';
      else
        Axle  = 'RA';
      end
      for iseg = 1:nseg
        [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
          build_min_max_traj(seg(iseg),Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax);
      end
    end
    for i=1:2
      if( i == 1 )
        Axle  = 'FA';
      else
        Axle  = 'RA';
      end
      for iseg = 1:nseg
        [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
          build_min_max_ego(seg(iseg),Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax);
      end
    end

    if( isfield(q,'recording') )
      for i=1:2
        if( i == 1 )
          Axle  = 'FA';
        else
          Axle  = 'RA';
        end
        if( check_val_in_struct(q.recording,Axle,'struct',1,0) )
          xmin = min(min(q.recording.(Axle).xvec),xmin);
          xmax = max(max(q.recording.(Axle).xvec),xmax);
          ymin = min(min(q.recording.(Axle).yvec),ymin);
          ymax = max(max(q.recording.(Axle).yvec),ymax);
          % smin = min(min(q.recording.(Axle).svec),smin);
          % smax = max(max(q.recording.(Axle).svec),smax);
        end
      end
    end
    
    x0 = interp1_const_extrap_timeout(invec,outvec,xmin);
    x1 = interp1_const_extrap_timeout(invec,outvec,xmax);
    y0 = interp1_const_extrap_timeout(invec,outvec,ymin);
    y1 = interp1_const_extrap_timeout(invec,outvec,ymax);
    s0 = interp1_const_extrap_timeout(invec,outvec,smin);
    s1 = interp1_const_extrap_timeout(invec,outvec,smax);
    sdist0 = interp1_const_extrap_timeout(invec,outvec,sdistmin);
    sdist1 = interp1_const_extrap_timeout(invec,outvec,sdistmax);
    for iseg = 1:nseg
      seg(iseg).plot_xmin     = x0;
      seg(iseg).plot_xmax     = x1;
      seg(iseg).plot_ymin     = y0;
      seg(iseg).plot_ymax     = y1;
      seg(iseg).plot_smin     = s0;
      seg(iseg).plot_smax     = s1;
      seg(iseg).plot_sdistmin = sdist0;
      seg(iseg).plot_sdistmax = sdist1;
    end
    
  else
    
    for iseg = 1:nseg
      xmin = 1/eps;
      xmax = -1/eps;
      ymin = xmin;
      ymax = xmax;
      smin = xmin;
      smax = xmax;
      sdistmin = xmin;
      sdistmax = xmax;
      for i=1:2
        if( i == 1 )
          Axle  = 'FA';
        else
          Axle  = 'RA';
        end
        [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
          build_min_max_traj(seg(iseg),Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax);
      end
      for i=1:2
        if( i == 1 )
          Axle  = 'FA';
        else
          Axle  = 'RA';
        end
        [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
          build_min_max_ego(seg(iseg),Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax);
      end
      if( isfield(q,'recording') )
        for i=1:2
          if( i == 1 )
            Axle  = 'FA';
          else
            Axle  = 'RA';
          end
          if( check_val_in_struct(q.recording,Axle,'struct',1,0) )
            xmin = min(min(q.recording.(Axle).xvec),xmin);
            xmax = max(max(q.recording.(Axle).xvec),xmax);
            ymin = min(min(q.recording.(Axle).yvec),ymin);
            ymax = max(max(q.recording.(Axle).yvec),ymax);
            % smin = min(min(q.recording.(Axle).svec),smin);
            % smax = max(max(q.recording.(Axle).svec),smax);
          end
        end
      end
    
      x0 = interp1_const_extrap_timeout(invec,outvec,xmin);
      x1 = interp1_const_extrap_timeout(invec,outvec,xmax);
      y0 = interp1_const_extrap_timeout(invec,outvec,ymin);
      y1 = interp1_const_extrap_timeout(invec,outvec,ymax);
      s0 = interp1_const_extrap_timeout(invec,outvec,smin);
      s1 = interp1_const_extrap_timeout(invec,outvec,smax);
      sdist0 = interp1_const_extrap_timeout(invec,outvec,sdistmin);
      sdist1 = interp1_const_extrap_timeout(invec,outvec,sdistmax);

      seg(iseg).plot_xmin     = x0;
      seg(iseg).plot_xmax     = x1;
      seg(iseg).plot_ymin     = y0;
      seg(iseg).plot_ymax     = y1;
      seg(iseg).plot_smin     = s0;
      seg(iseg).plot_smax     = s1;
      seg(iseg).plot_sdistmin = sdist0;
      seg(iseg).plot_sdistmax = sdist1;
    end
    
  end
end
function [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
           build_min_max_traj(seg,Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax)
         
  for jtraj= 1:seg.ntraj
    if( check_val_in_struct(seg.traj(jtraj),Axle,'struct',1,0) )
      xmin = min(min(seg.traj(jtraj).(Axle).xvec),xmin);
      xmax = max(max(seg.traj(jtraj).(Axle).xvec),xmax);
      ymin = min(min(seg.traj(jtraj).(Axle).yvec),ymin);
      ymax = max(max(seg.traj(jtraj).(Axle).yvec),ymax);
      smin = min(min(seg.traj(jtraj).(Axle).svec),smin);
      smax = max(max(seg.traj(jtraj).(Axle).svec),smax);
      sdistmin = min(min(seg.traj(jtraj).(Axle).sdistvec),sdistmin);
      sdistmax = max(max(seg.traj(jtraj).(Axle).sdistvec),sdistmax);
    end
  end
end
function         [xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax] = ...
          build_min_max_ego(seg,Axle,xmin,xmax,ymin,ymax,smin,smax,sdistmin,sdistmax)
  for jego= 1:seg.negoPos
    if( check_val_in_struct(seg.egoPos(jego),Axle,'struct',1,0) )
      xmin = min(min(seg.egoPos(jego).(Axle).xvec),xmin);
      xmax = max(max(seg.egoPos(jego).(Axle).xvec),xmax);
      ymin = min(min(seg.egoPos(jego).(Axle).yvec),ymin);
      ymax = max(max(seg.egoPos(jego).(Axle).yvec),ymax);
      smin = min(min(seg.egoPos(jego).(Axle).svec),smin);
      smax = max(max(seg.egoPos(jego).(Axle).svec),smax);
    end
  end
end        %     if( status == STATUS_START )
%         
%       if( ~isempty(e.(q.p.(first_traj_name).nameX).vec{i}) && ~isempty(e.(q.p.(first_traj_name).nameY).vec{i}) )
%         status = STATUS_RUN;
%         q.nseg                = 1;
%                 
%         q.seg(q.nseg).tStart       = e.(q.p.(first_traj_name).nameX).time(i);
%         q.seg(q.nseg).iStart       = i;
%         q.seg(q.nseg).CC           = e.(q.p.(first_traj_name).nameCC).vec(i);
%   
%         q.seg(q.nseg).traj(iPlotTraj).xVec = e.(q.p.(first_traj_name).nameX).vec{i};
%         q.seg(q.nseg).traj(iPlotTraj).yVec = e.(q.p.(first_traj_name).nameY).vec{i};
%         q.seg(q.nseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.(first_traj_name),q.seg(q.nseg),iPlotTraj);
%         
%         q.seg(q.nseg).time_text_h  = [];   % Text-ID plot
%       end
%         
%       
%       
%     elseif( status == STATUS_RUN )
%       
%       if(  (q.seg(q.nseg).CC ~= e.(q.p.(first_traj_name).nameCC).vec(i)) ...
%         && ~vec_compare(q.seg(q.nseg).traj(iPlotTraj).xVec,e.(q.p.(first_traj_name).nameX).vec{i}) ...
%         && ~isempty(e.(q.p.(first_traj_name).nameX).vec{i}) ...
%         && ~isempty(e.(q.p.(first_traj_name).nameY).vec{i}) ...
%         )
%         q.seg(q.nseg).tEnd = e.(q.p.(first_traj_name).nameX).time(i);
%         dtmean             = dtmean + (q.seg(q.nseg).tEnd-q.seg(q.nseg).tStart);
%         q.seg(q.nseg).iEnd = i;
%         q.nseg               = q.nseg + 1;
%                 
%         q.seg(q.nseg).tStart = e.(q.p.(first_traj_name).nameX).time(i);
%         q.seg(q.nseg).iStart = i;
%         q.seg(q.nseg).CC     = e.(q.p.(first_traj_name).nameCC).vec(i);
% 
%         q.seg(q.nseg).traj(iPlotTraj).xVec = e.(q.p.(first_traj_name).nameX).vec{i};
%         q.seg(q.nseg).traj(iPlotTraj).yVec = e.(q.p.(first_traj_name).nameY).vec{i};
%         q.seg(q.nseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.(first_traj_name),q.seg(q.nseg),iPlotTraj);
%           
%       end
%       q.seg(q.nseg).time_text_h  = [];   % Text-ID plot
%       
%     end
%   end
%   
%   if( status == STATUS_START )
%     error('error no tracectory found in time tStart - tEnd')
%   else
%     q.seg(q.nseg).tEnd = q.p.tEnd;
%   end
%   %========================================================================
%   % Vehicle Pose
%   %========================================================================
%   
%   for iseg = 1:q.nseg
%     
%     if( q.p.vehPose.flagPlot )
%       i0  = suche_index(e.(q.p.vehPose.nameX).time,q.seg(iseg).tStart,'====','v',0.001);
%       i1  = suche_index(e.(q.p.vehPose.nameX).time,q.seg(iseg).tEnd,'====','v',0.001);
%       
%       q.seg(iseg).vehPose.xVec = e.(q.p.vehPose.nameX).vec(i0:i1);
%       q.seg(iseg).vehPose.yVec = e.(q.p.vehPose.nameY).vec(i0:i1);
%       q.seg(iseg)              = plot_trajectory_calc_set_segments_pose_options(q.p.vehPose,q.seg(iseg),'vehPose');
%     end
%     q.seg(iseg).vehPose.flagPlot  = q.p.vehPose.flagPlot;
%     
%     if( q.p.vehPoseRA.flagPlot )
%       i0  = suche_index(e.(q.p.vehPoseRA.nameX).time,q.seg(iseg).tStart,'====','v',0.001);
%       i1  = suche_index(e.(q.p.vehPoseRA.nameX).time,q.seg(iseg).tEnd,'====','v',0.001);
%       
%       q.seg(iseg).vehPoseRA.xVec = e.(q.p.vehPoseRA.nameX).vec(i0:i1);
%       q.seg(iseg).vehPoseRA.yVec = e.(q.p.vehPoseRA.nameY).vec(i0:i1);
%       q.seg(iseg)                = plot_trajectory_calc_set_segments_pose_options(q.p.vehPoseRA,q.seg(iseg),'vehPoseRA');
%     end
%     q.seg(iseg).vehPoseRA.flagPlot  = q.p.vehPoseRA.flagPlot;
%     
%     q.seg(iseg).vehPoseS.flag = 0;
%     if( q.p.vehPoseS.flag && q.p.vehPose.flagPlot )
%       q.seg(iseg).vehPoseS.flag = 1;
%       i0  = suche_index(e.(q.p.vehPose.nameX).time,q.seg(iseg).tStart,'====','v',0.001);
%       i1  = suche_index(e.(q.p.vehPose.nameX).time,q.seg(iseg).tEnd,'====','v',0.001);
%         
%       [q.seg(iseg).vehPoseS.sVec,~,~] = vek_2d_s_ds_alpha(e.(q.p.vehPose.nameX).vec(i0:i1) ...
%                                                     ,e.(q.p.vehPose.nameY).vec(i0:i1) ...
%                                                     ,e.(q.p.vehPoseS.name).vec(i0));
%     end
%     if( q.seg(iseg).vehPoseS.flag && q.p.vehPoseXS.flagPlot )
%       q.seg(iseg).vehPoseXS.flagPlot = 1;
%       q.seg(iseg).vehPoseXS.xVec = q.seg(iseg).vehPoseS.sVec;
%       q.seg(iseg).vehPoseXS.yVec = e.(q.p.vehPoseXS.nameY).vec(i0:i1);
%       q.seg(iseg) = plot_trajectory_calc_set_segments_pose_options(q.p.vehPoseXS,q.seg(iseg),'vehPoseXS');
%     else
%       q.seg(iseg).vehPoseXS.flagPlot = 0;
%     end
%     if( q.seg(iseg).vehPoseS.flag && q.p.vehPoseYS.flagPlot )
%       q.seg(iseg).vehPoseYS.flagPlot = 1;
%       q.seg(iseg).vehPoseYS.xVec = q.seg(iseg).vehPoseS.sVec;
%       q.seg(iseg).vehPoseYS.yVec = e.(q.p.vehPoseYS.nameY).vec(i0:i1);
%       q.seg(iseg) = plot_trajectory_calc_set_segments_pose_options(q.p.vehPoseYS,q.seg(iseg),'vehPoseYS');
%     else
%       q.seg(iseg).vehPoseYS.flagPlot = 0;
%     end
%   end
% 
%   %========================================================================
%   % zweite Trajektorie
%   %========================================================================
%   % Aus Messung Input in Simulation finden
%   if( strcmpi(first_traj_name,'traj_minp') ) % Wenn erste die Messung ist, dann Zeitpunkt in Simulation
%     if( q.p.traj_sinp.flagPlot )
%       sim_traj_name = 'traj_sinp';
%     elseif( q.p.traj_sraw.flagPlot )
%       sim_traj_name = 'traj_sraw';
%     elseif( q.p.traj_straj.flagPlot )
%       sim_traj_name = 'traj_straj';
%     else
%       sim_traj_name = '';
%     end
%     
%     if( ~isempty(sim_traj_name) )
%     
%       for iseg = 1:q.nseg
%       
%         i0 = suche_index(e.(q.p.(sim_traj_name).nameCC).time,q.seg(iseg).tStart,'====','v',0.001);
%         if( i0 > 1 ), i0 = i0-1;end
%         n = length(e.(q.p.(sim_traj_name).nameCC).vec);
% 
%         % Change Counter suchen
%         icc = mod(q.seg(iseg).CC,256); 
%         flag = 1;
%         for i=i0:min(n,i0+10)
%           if( icc == e.(q.p.(sim_traj_name).nameCC).vec(i) )
%             flag = 0;
%             q.seg(iseg).iStart = i;
%             break;
%           end
%         end
%         if( flag )
%           error('Change Counter in Simulation nicht gefunden')
%         end
%       end
%     end
%   end
%   if( q.p.traj_sinp_ra.flagPlot )
%     iPlotTraj =iPlotTraj + 1;
%     for iseg = 1:q.nseg
%       q.seg(iseg).traj(iPlotTraj).xVec = e.(q.p.traj_sinp_ra.nameX).vec{q.seg(iseg).iStart};
%       q.seg(iseg).traj(iPlotTraj).yVec = e.(q.p.traj_sinp_ra.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.traj_sinp_ra ...
%                                                                                         ,q.seg(iseg) ...
%                                                                                         ,iPlotTraj);
%     end
%   end
%   if( q.p.traj_sraw.flagPlot )
%     iPlotTraj =iPlotTraj + 1;
%     for iseg = 1:q.nseg
%       q.seg(iseg).traj(iPlotTraj).xVec = e.(q.p.traj_sraw.nameX).vec{q.seg(iseg).iStart};
%       q.seg(iseg).traj(iPlotTraj).yVec = e.(q.p.traj_sraw.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.traj_sraw ...
%                                                                                         ,q.seg(iseg) ...
%                                                                                         ,iPlotTraj);
%     end
%   end
%   if( q.p.traj_straj.flagPlot )
%     iPlotTraj =iPlotTraj + 1;
%     for iseg = 1:q.nseg
%       q.seg(iseg).traj(iPlotTraj).xVec = e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart};
%       q.seg(iseg).traj(iPlotTraj).yVec = e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.traj_straj ...
%                                                                                         ,q.seg(iseg) ...
%                                                                                         ,iPlotTraj);
%     end      
%   end
%   
%   iPlotSTraj   = 0;
%   % alpha über s
%   if( q.p.traj_straja.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % Alpha über S
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_straja.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_straja ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'alpha');
%     end
%   else
%     q.p.traj_straja.flagPlot = 0;
%   end
%   % Kappa über S
%   if( q.p.traj_strajk.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajk.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajk ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'kappa');
%     end
%   else
%     q.p.traj_strajk.flagPlot = 0;
%   end
%   % x über S
%   if( q.p.traj_strajx.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajx.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajx ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'x');
%     end
%   else
%     q.p.traj_strajx.flagPlot = 0;
%   end
%   % y über S
%   if( q.p.traj_strajy.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajy.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajy ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'y');
%     end
%   else
%     q.p.traj_strajy.flagPlot = 0;
%   end
%   
%   % dx über S
%   if( q.p.traj_strajdx.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajdx.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajdx ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'dx');
%     end
%   else
%     q.p.traj_strajdx.flagPlot = 0;
%   end
%   % dy über S
%   if( q.p.traj_strajdy.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajdy.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajdy ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'dy');
%     end
%   else
%     q.p.traj_strajdy.flagPlot = 0;
%   end
%   
%   % d2x über S
%   if( q.p.traj_strajdx.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajd2x.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajd2x ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'d2x');
%     end
%   else
%     q.p.traj_strajd2x.flagPlot = 0;
%   end
%   % d2y über S
%   if( q.p.traj_strajd2y.flagPlot && q.p.vehPoseS.flag && q.p.traj_straj.flagPlot) % 
%     iPlotSTraj =iPlotSTraj + 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       [svec,~,~] = vek_2d_s_ds_alpha(e.(q.p.traj_straj.nameX).vec{q.seg(iseg).iStart} ...
%                                     ,e.(q.p.traj_straj.nameY).vec{q.seg(iseg).iStart} ...
%                                     ,s0);
%       q.seg(iseg).straj(iPlotSTraj).x0   = s0;
%       q.seg(iseg).straj(iPlotSTraj).xVec = svec;
%       q.seg(iseg).straj(iPlotSTraj).yVec = e.(q.p.traj_strajd2y.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg) = plot_trajectory_calc_set_segments_traj_options_straj(q.p.traj_strajd2y ...
%                                                                    ,q.seg(iseg) ...
%                                                                    ,iPlotSTraj ...
%                                                                    ,'d2y');
%     end
%   else
%     q.p.traj_strajd2y.flagPlot = 0;
%   end
%   % Anzahl S-Plots
%   q.numberSPlot = iPlotSTraj;
% 
%   if( q.p.traj_minp_ra.flagPlot )
%     iPlotTraj =iPlotTraj + 1;
%     for iseg = 1:q.nseg
%       q.seg(iseg).traj(iPlotTraj).xVec = e.(q.p.traj_minp_ra.nameX).vec{q.seg(iseg).iStart};
%       q.seg(iseg).traj(iPlotTraj).yVec = e.(q.p.traj_minp_ra.nameY).vec{q.seg(iseg).iStart};     
%       q.seg(iseg)                      = plot_trajectory_calc_set_segments_traj_options(q.p.traj_minp_ra ...
%                                                                                         ,q.seg(iseg) ...
%                                                                                         ,iPlotTraj);
%     end
%   end
%   
%   if( q.p.traj_speed.flagPlot )
%     q.numberSVPlot = 1;
%     for iseg = 1:q.nseg
%       a     = suche_index(e.(q.p.vehPoseS.name).time,q.seg(iseg).tStart,'===','v',0.001);
%       i0    = floor(a);
%       dPath = a-i0;
%       s0    = e.(q.p.vehPoseS.name).vec(i0)+(e.(q.p.vehPoseS.name).vec(i0+1)-e.(q.p.vehPoseS.name).vec(i0))*dPath;
% 
%       q.seg(iseg).svtraj(1).x0   = s0;
%       q.seg(iseg).svtraj(1).xVec = e.(q.p.traj_speed.nameS).vec{q.seg(iseg).iStart};
%       q.seg(iseg).svtraj(1).yVec = e.(q.p.traj_speed.nameSpeed).vec{q.seg(iseg).iStart};    
%       q.seg(iseg)                  = plot_trajectory_calc_set_segments_trajspeed_options(q.p.traj_speed ...
%                                                                                         ,q.seg(iseg));
% %       catch
% %         a = 0;
% %       end
%     end
%   end
%   %========================================================================
%   % Actual Intersection
%   %========================================================================
%   
%   for iseg = 1:q.nseg
%     if( q.p.actInter.flagPlot ) 
%       i0  = suche_index(e.(q.p.actInter.nameX).time,q.seg(iseg).tStart,'====','v',0.001);
%       i1  = suche_index(e.(q.p.actInter.nameX).time,q.seg(iseg).tEnd,'====','v',0.001);
%       
%       q.seg(iseg).actInter.xVec = e.(q.p.actInter.nameX).vec(i0:i1);
%       q.seg(iseg).actInter.yVec = e.(q.p.actInter.nameY).vec(i0:i1);
%       q.seg(iseg)               = plot_trajectory_calc_set_segments_pose_options(q.p.actInter,q.seg(iseg),'actInter');
%     end
%     q.seg(iseg).actInter.flagPlot = q.p.actInter.flagPlot;
%     
%   end
%   
%       end
%==========================================================================================================
%==========================================================================================================
%==========================================================================================================
%==========================================================================================================
%==========================================================================================================      
function seg = plot_trajectory_calc_set_segments_traj_Axle(seg,iseg,itraj,traj,Axle,i)

  if( (i <= length(traj.(Axle).xvec_liste)) && (i <= length(traj.(Axle).yvec_liste)) )
    seg(iseg).traj(itraj).(Axle).xvec   = traj.(Axle).xvec_liste{i};
    seg(iseg).traj(itraj).(Axle).yvec   = traj.(Axle).yvec_liste{i};
    seg(iseg).traj(itraj).(Axle).nvec   = length(seg(iseg).traj(itraj).(Axle).xvec); 
    [seg(iseg).traj(itraj).(Axle).svec ...
    ,seg(iseg).traj(itraj).(Axle).dsvec ...
    ,seg(iseg).traj(itraj).(Axle).yawtangens] = ...
         vek_2d_s_ds_alpha(seg(iseg).traj(itraj).(Axle).xvec ...
                          ,seg(iseg).traj(itraj).(Axle).yvec ...
                          );
  else
    seg(iseg).traj(itraj).xvec = [];
    seg(iseg).traj(itraj).yvec = [];
    seg(iseg).traj(itraj).svec = [];
    seg(iseg).traj(itraj).dsvec = [];
    seg(iseg).traj(itraj).yawtangens = [];
    seg(iseg).traj(itraj).(Axle).nvec = 0;
  end
  
  if( (i <= length(traj.vvec_liste))  )
    seg(iseg).traj(itraj).vvec          = traj.vvec_liste{i};
  else
    seg(iseg).traj(itraj).vvec = [];
  end
  if( (i <= length(traj.avec_liste))  )
    seg(iseg).traj(itraj).avec          = traj.avec_liste{i};
  else
    seg(iseg).traj(itraj).avec = [];
  end
  
  seg(iseg).traj(itraj).(Axle).legText        = traj.(Axle).legText;
  seg(iseg).traj(itraj).(Axle).offsetX        = traj.(Axle).offsetX;
  seg(iseg).traj(itraj).(Axle).offsetY        = traj.(Axle).offsetY;
  seg(iseg).traj(itraj).(Axle).lineWidth      = traj.(Axle).lineWidth;
  seg(iseg).traj(itraj).(Axle).lineStyle      = traj.(Axle).lineStyle;
  seg(iseg).traj(itraj).(Axle).marker         = traj.(Axle).marker;
  seg(iseg).traj(itraj).(Axle).marker_size    = traj.(Axle).marker_size;
  seg(iseg).traj(itraj).(Axle).marker_size_di = traj.(Axle).marker_size_di;
  
  if(  check_val_in_struct(traj.(Axle),'unit','char',1,0) )
    seg(iseg).traj(itraj).(Axle).unit           = traj.(Axle).unit;
  else
    seg(iseg).traj(itraj).(Axle).unit           = 'm';
  end
end
function seg = plot_trajectory_calc_set_segments_traj_Axle_by_time(seg,iseg,itraj,traj,Axle,tstart,tend)

  
  i = plot_trajectory_calc_set_segments_traj_Axle_by_time_time(traj.time,tstart,tend);


  if( i && (i <= length(traj.vvec_liste)) && (i <= length(traj.avec_liste)) && (i <= length(traj.(Axle).xvec_liste)) && (i <= length(traj.(Axle).yvec_liste)) )
    seg(iseg).traj(itraj).vvec          = traj.vvec_liste{i};
    seg(iseg).traj(itraj).avec          = traj.avec_liste{i};
    seg(iseg).traj(itraj).(Axle).xvec   = traj.(Axle).xvec_liste{i};
    seg(iseg).traj(itraj).(Axle).yvec   = traj.(Axle).yvec_liste{i};
    seg(iseg).traj(itraj).(Axle).nvec   = length(seg(iseg).traj(itraj).(Axle).xvec); 
    [seg(iseg).traj(itraj).(Axle).svec ...
    ,seg(iseg).traj(itraj).(Axle).dsvec ...
    ,seg(iseg).traj(itraj).(Axle).yawtangens] = ...
         vek_2d_s_ds_alpha(seg(iseg).traj(itraj).(Axle).xvec ...
                          ,seg(iseg).traj(itraj).(Axle).yvec ...
                          );
  else
    seg(iseg).traj(itraj).vvec = [];
    seg(iseg).traj(itraj).avec = [];
    seg(iseg).traj(itraj).xvec = [];
    seg(iseg).traj(itraj).yvec = [];
    seg(iseg).traj(itraj).svec = [];
    seg(iseg).traj(itraj).dsvec = [];
    seg(iseg).traj(itraj).yawtangens = [];
    seg(iseg).traj(itraj).(Axle).nvec = 0;
  end
  
  seg(iseg).traj(itraj).(Axle).legText        = traj.(Axle).legText;
  seg(iseg).traj(itraj).(Axle).offsetX        = traj.(Axle).offsetX;
  seg(iseg).traj(itraj).(Axle).offsetY        = traj.(Axle).offsetY;
  seg(iseg).traj(itraj).(Axle).lineWidth      = traj.(Axle).lineWidth;
  seg(iseg).traj(itraj).(Axle).lineStyle      = traj.(Axle).lineStyle;
  seg(iseg).traj(itraj).(Axle).marker         = traj.(Axle).marker;
  seg(iseg).traj(itraj).(Axle).marker_size    = traj.(Axle).marker_size;
  seg(iseg).traj(itraj).(Axle).marker_size_di = traj.(Axle).marker_size_di;
  
  if(  check_val_in_struct(traj.(Axle),'unit','char',1,0) )
    seg(iseg).traj(itraj).(Axle).unit           = traj.(Axle).unit;
  else
    seg(iseg).traj(itraj).(Axle).unit           = 'm';
  end
end
function index = plot_trajectory_calc_set_segments_traj_Axle_by_time_time(timevec,tstart,tend)
  index = 0;
  i0 = suche_index(timevec,tstart,'>=');
  if( i0 )
    
    i1 = suche_index(timevec,tend,'<','r');
    if( i0 <= i1 )
      index = i0;
    elseif( i1 )
      index = i1;
    end
  end
end
function flag = plot_trajectory_calc_is_traj_different(xvec0,yvec0,xvec1,yvec1,toleranz) 

  if( ~exist('toleranz','var') )
    toleranz = eps;
  end
  flag = 0;
  n    = length(xvec0);
  if( (n ~= length(xvec1))  || (length(yvec0) ~= length(yvec1)) )
    flag = 1;
  else
    for i=1:n
      if( sqrt((xvec0(i)-xvec1(i))^2 + (yvec0(i)-yvec1(i))^2 ) > toleranz )
        flag = 1;
        break;
      end
    end
  end
  
end
      
function flag = plot_trajectory_calc_dir_is_changing(dirvec,iStart)
  flag = 0;
  for i=iStart:length(dirvec)-1
    if( dirvec(i) ~= dirvec(i+1) )
      flag = 1;
      break;
    end
  end
end
      
      
      
      
      
      
      
      
      
      
      
      
      
function q    = plot_trajectory_calc_input(q)

    
    
  q.p.traj_minp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp.flagPlot,q.p.traj_sinp.flagPlot,q.p.traj_minp.nameX);
  q.p.traj_minp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp.flagPlot,q.p.traj_sinp.flagPlot,q.p.traj_minp.nameY);
  q.p.traj_minp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp.flagPlot,q.p.traj_sinp.flagPlot,q.p.traj_minp.nameCC);
  q.p.traj_minp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp.flagPlot,q.p.traj_sinp.flagPlot,q.p.traj_minp.nameValid);

  if( ~isfield(q.p.traj_minp,'legText') ),q.p.traj_minp.legText = 'traj1';end
  
  % input trajectory from simulation
  q.p.traj_sinp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sinp.flagPlot,q.p.traj_minp.flagPlot,q.p.traj_sinp.nameX);
  q.p.traj_sinp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sinp.flagPlot,q.p.traj_minp.flagPlot,q.p.traj_sinp.nameY);
  q.p.traj_sinp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sinp.flagPlot,q.p.traj_minp.flagPlot,q.p.traj_sinp.nameCC);
  q.p.traj_sinp.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sinp.flagPlot,q.p.traj_minp.flagPlot,q.p.traj_sinp.nameValid);
  
  % raw trajectory from simulation
  q.p.traj_sraw.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sraw.flagPlot,1,q.p.traj_sraw.nameX);
  q.p.traj_sraw.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sraw.flagPlot,1,q.p.traj_sraw.nameY);
  q.p.traj_sraw.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_sraw.flagPlot,1,q.p.traj_sraw.nameCC);
  if( ~isfield(q.p.traj_sraw,'legText') ),q.p.traj_sraw.legText = 'traj3';end
  
  % calculated trajectory from simulation
  q.p.traj_straj.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_straj.flagPlot,1,q.p.traj_straj.nameX);
  q.p.traj_straj.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_straj.flagPlot,1,q.p.traj_straj.nameY);
  q.p.traj_straj.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_straj.flagPlot,1,q.p.traj_straj.nameCC);
  
  % Der x-Vecotor wird später gebildet
  q.p.traj_straja.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_straja.flagPlot,1,q.p.traj_straja.nameY);
  q.p.traj_strajk.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajk.flagPlot,1,q.p.traj_strajk.nameY);
  q.p.traj_strajx.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajx.flagPlot,1,q.p.traj_strajx.nameY);
  q.p.traj_strajy.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajy.flagPlot,1,q.p.traj_strajy.nameY);
  q.p.traj_strajdx.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajdx.flagPlot,1,q.p.traj_strajdx.nameY);
  q.p.traj_strajdy.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajdy.flagPlot,1,q.p.traj_strajdy.nameY);
  q.p.traj_strajd2x.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajd2x.flagPlot,1,q.p.traj_strajd2x.nameY);
  q.p.traj_strajd2y.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_strajd2y.flagPlot,1,q.p.traj_strajd2y.nameY);


  % calculated trajectory RA
  q.p.traj_minp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp_ra.flagPlot,1,q.p.traj_minp_ra.nameX);
  q.p.traj_minp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp_ra.flagPlot,1,q.p.traj_minp_ra.nameY);
  q.p.traj_minp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_minp_ra.flagPlot,1,q.p.traj_minp_ra.nameCC);
                         
  % input trajectory from simulation
  q.p.traj_sinp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                              e,q.p.traj_sinp_ra.flagPlot,q.p.traj_minp_ra.flagPlot,q.p.traj_sinp_ra.nameX);
  q.p.traj_sinp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                              e,q.p.traj_sinp_ra.flagPlot,q.p.traj_minp_ra.flagPlot,q.p.traj_sinp_ra.nameY);
  q.p.traj_sinp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                              e,q.p.traj_sinp_ra.flagPlot,q.p.traj_minp_ra.flagPlot,q.p.traj_sinp_ra.nameCC);
  q.p.traj_sinp_ra.flagPlot = plot_trajectory_calc_traj_check( ...
                              e,q.p.traj_sinp_ra.flagPlot,q.p.traj_minp_ra.flagPlot,q.p.traj_sinp_ra.nameValid);
                            
  % calculated trajectory Speed
  q.p.traj_speed.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_speed.flagPlot,1,q.p.traj_speed.nameSpeed);
  q.p.traj_speed.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_speed.flagPlot,1,q.p.traj_speed.nameDir);
  q.p.traj_speed.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_speed.flagPlot,1,q.p.traj_speed.nameX);
  q.p.traj_speed.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.traj_speed.flagPlot,1,q.p.traj_speed.nameY);
                         
  if( q.p.traj_speed.flagPlot )
    e = plot_trajectory_calc_traj_get_s(e,q.p.traj_speed.nameX,q.p.traj_speed.nameY,q.p.traj_speed.nameS);
  end
                         
  % Vehicle Pose from Simulation
  q.p.vehPose.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPose.flagPlot,1,q.p.vehPose.nameX);
  q.p.vehPose.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPose.flagPlot,1,q.p.vehPose.nameY);
  if( ~isfield(q.p.vehPose,'legText') ),q.p.vehPose.legText = 'vehPose';end
  
  % Vehicle Pose RA from Simulation
  q.p.vehPoseRA.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPoseRA.flagPlot,1,q.p.vehPoseRA.nameX);
  q.p.vehPoseRA.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPoseRA.flagPlot,1,q.p.vehPoseRA.nameY);
  if( ~isfield(q.p.vehPoseRA,'legText') ),q.p.vehPoseRA.legText = 'vehPoseRA';end
  
  % Vehicle Pose S
  q.p.vehPoseS.flag      = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPoseS.flag,1,q.p.vehPoseS.name);
                         
  % Vehicle Pose XY from Simulation
  q.p.vehPoseXS.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPoseXS.flagPlot,1,q.p.vehPoseXS.nameY);
  if( ~isfield(q.p.vehPoseXS,'legText') ),q.p.vehPoseXS.legText = 'vehPoseXS';end
      
  q.p.vehPoseYS.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.vehPoseYS.flagPlot,1,q.p.vehPoseYS.nameY);
  if( ~isfield(q.p.vehPoseYS,'legText') ),q.p.vehPoseYS.legText = 'vehPoseYS';end

  % Intersection from Simulation
  q.p.actInter.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.actInter.flagPlot,1,q.p.actInter.nameX);
  q.p.actInter.flagPlot = plot_trajectory_calc_traj_check( ...
                           e,q.p.actInter.flagPlot,1,q.p.actInter.nameY);
  if( ~isfield(q.p.actInter,'legText') ),q.p.actInter.legText = 'vehPose';end
  
  
  
end
function   flag_switch = plot_trajectory_calc_traj_check(e,flag_check,warn_flag,sig_name)
  flag_switch = flag_check;
  if( flag_check )
    if( ~isfield(e,sig_name) )
      tt = sprintf(' In Data no struct ''%s'' ',sig_name);
      if( warn_flag )
        warning(tt);
        flag_switch = 0;
      else
        error(tt);
      end
    end
  end
end

function [e,q]    = plot_trajectory_calc_set_tstart_tend(e,q)

  if( q.p.traj_minp.flagPlot )
    %========================================================================
    % build timevec from traj_minp
    %==============================
    [tfirst,~] = e_data_vecinvec_get_type_vec(e,q.p.traj_minp.nameX,'first');
     
    s = vec_find_values('type','last' ...
                       ,'vec',e.(q.p.traj_minp.nameValid).vec ...
                       ,'val',1,'tol',0.1);
    if( isempty(s) )
      [tlast,~]  = e_data_vecinvec_get_type_vec(e,q.p.traj_minp.nameX,'last');
    else
      tlast      = e.(q.p.traj_minp.nameValid).time(s.i0);
    end
  elseif( q.p.traj_sinp.flagPlot )
    %========================================================================
    % build timevec from traj_minp
    %==============================
    [tfirst,~] = e_data_vecinvec_get_type_vec(e,q.p.traj_sinp.nameX,'first');
    
    s = vec_find_values('type','last' ...
                       ,'vec',e.(q.p.traj_sinp.nameValid).vec ...
                       ,'val',1,'tol',0.1);
    if( isempty(s) )
      [tlast,~]  = e_data_vecinvec_get_type_vec(e,q.p.traj_sinp.nameX,'last');
    else
      tlast      = e.(q.p.traj_sinp.nameValid).time(s.i0);
    end
  end
  % set q.p.tStart, q.p.tEnd
  %=========================
  q = plot_trajectory_calc_set_tstart_tend_sort(q,tfirst,tlast);
    
  
  
end
function q = plot_trajectory_calc_set_tstart_tend_sort(q,tfirst,tlast)
  
  if( q.p.tStart < tfirst )
    dt         = q.p.tEnd - q.p.tStart;
    if( (tfirst + dt) > q.p.tEnd )
      q.p.tEnd = tfirst + dt;
    end
    q.p.tStart = tfirst;
  end
  if( q.p.tEnd > tlast )
    dt     = q.p.tEnd - q.p.tStart;
    if( (tlast - dt) < q.p.tStart )
      q.p.tStart = tlast - dt;
    end
    q.p.tEnd   = tlast;
  end
end
function seg = plot_trajectory_calc_set_segments_traj_options_straj(traj_inp,seg,iPlotTraj,signame)

  seg.straj(iPlotTraj).legText        = traj_inp.legText;
  seg.straj(iPlotTraj).offsetX        = traj_inp.offsetX;
  seg.straj(iPlotTraj).offsetY        = traj_inp.offsetY;
  seg.straj(iPlotTraj).lineWidth      = traj_inp.lineWidth;
  seg.straj(iPlotTraj).lineStyle      = traj_inp.lineStyle;
  seg.straj(iPlotTraj).marker         = traj_inp.marker;
  seg.straj(iPlotTraj).marker_size    = traj_inp.marker_size;
  seg.straj(iPlotTraj).marker_size_di = traj_inp.marker_size_di;
  traj_inp = struct_set_val(traj_inp,'unit','m',1);
  seg.straj(iPlotTraj).unit           = traj_inp.unit;
  seg.straj(iPlotTraj).name           = signame;
end

function seg = plot_trajectory_calc_set_segments_pose_options(pose,seg,sname)

  
  seg.(sname).legText        = pose.legText;
  seg.(sname).offsetX        = pose.offsetX;
  seg.(sname).offsetY        = pose.offsetY;
  seg.(sname).lineWidth      = pose.lineWidth;
  seg.(sname).lineStyle      = pose.lineStyle;
  seg.(sname).ccolor         = pose.ccolor;
  seg.(sname).marker         = pose.marker;
  seg.(sname).marker_size    = pose.marker_size;
  seg.(sname).marker_size_di = pose.marker_size_di;
end
function seg = plot_trajectory_calc_set_segments_trajspeed_options(traj_inp,seg)

  seg.trajSpeed.legText        = traj_inp.legText;
  seg.trajSpeed.offsetX        = traj_inp.offsetX;
  seg.trajSpeed.offsetY        = traj_inp.offsetY;
  seg.trajSpeed.lineWidth      = traj_inp.lineWidth;
  seg.trajSpeed.lineStyle      = traj_inp.lineStyle;
  seg.trajSpeed.marker         = traj_inp.marker;
  seg.trajSpeed.marker_size    = traj_inp.marker_size;
  seg.trajSpeed.marker_size_di = traj_inp.marker_size_di;
end
function e = plot_trajectory_calc_traj_get_s(e,nameX,nameY,nameS)

 n = length(e.(nameX).vec);
 sveccell = cell(n,1);
 for i = 1:n
   xvec = e.(nameX).vec{i};
   yvec = e.(nameY).vec{i};
   if( isempty(xvec) || isempty(yvec) )
     sveccell{i} = [];
   else
     sveccell{i}  = vek_2d_build_s(xvec,yvec,length(xvec),0.0,-1.);
   end
 end
 e     = e_data_add_value(e,nameS,e.(nameX).unit,'Wegstrecke',e.(nameX).time,sveccell,1);
end

