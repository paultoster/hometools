function e = cg_read_ecal_channel_LaneMarkersPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  sigliste     = {{'lane_hrzt_crv_lt'         , 1,'1/m'     ,'double',1,'Curvature left lane marker'} ...
                 ,{'lane_hrzt_crv_rt'         , 1,'1/m'     ,'double',1,'Curvature right lane marker'} ...
                 ,{'lane_ltrl_dist_lt'        , 1,'m'       ,'double',1,'Offset of MFC left clothoid'} ...   
                 ,{'lane_ltrl_dist_rt'        , 1,'m'       ,'double',1,'Offset of MFC right clothoid'} ...   
                 ,{'lane_yaw_angl_lt'         , 1,'rad'     ,'double',1,'Angle offset of MFC left clothoid'} ...   
                 ,{'lane_yaw_angl_rt'         , 1,'rad'     ,'double',1,'Angle offset of MFC right clothoid'} ...   
                 ,{'lane_clothoid_para_lt'    , 1,' '       ,'double',1,'Clothoid parameter of MFC left clothoid'} ...   
                 ,{'lane_clothoid_para_rt'    , 1,' '       ,'double',1,'Clothoid parameter of MFC right clothoid'} ...
                 ,{'lane_mark_dtct_dist_lt'   , 1,'m'       ,'double',1,'Detected distance of MFC left clothoid'} ...
                 ,{'lane_mark_dtct_dist_rt'   , 1,'m'       ,'double',1,'Detected distance of MFC right clothoid'} ...
                 };
                 
                 
% header: [1x1 struct]
%          lane_data_qual_lt: 1
%          lane_data_qual_rt: 0.9000
%            lane_dscrb_side: 3
%          lane_ltrl_dist_lt: 1.7000
%          lane_ltrl_dist_rt: 1.9400
%                   lane_num: 1
%               num_of_lanes: 2
%           lane_hrzt_crv_lt: 5.0000e-06
%           lane_hrzt_crv_rt: 5.0000e-06
%          lane_mark_lt_stat: 4
%          lane_mark_rt_stat: 4
%          lane_mark_type_lt: 2
%          lane_mark_type_rt: 1
%      lane_clothoid_para_lt: -2.0000e-06
%      lane_clothoid_para_rt: -2.0000e-06
%           lane_yaw_angl_lt: 0.0014
%           lane_yaw_angl_rt: 0.0014
%        lane_event_pos_x_lt: 62
%        lane_event_pos_x_rt: 62
%         lane_event_qual_lt: 1.2600
%         lane_event_qual_rt: 1.2600
%           lane_mark_col_lt: 1
%           lane_mark_col_rt: 1
%             veh_pitch_angl: -0.0089
%     lane_mark_dtct_dist_lt: 45
%     lane_mark_dtct_dist_rt: 81
%         lane_mark_width_lt: 0.1500
%         lane_mark_width_rt: 0.3000
%         lane_mark_avail_lt: 1
%         lane_mark_avail_rt: 1

  e    = struct([]);
  
  
  
  ndata = length(d.data);
   
  timestamp = zeros(ndata,1);
  for j=1:ndata
    timestamp(j) = d.data{j}.header.timestamp;
  end
  if( isfield(d,'timestamps') )
    time = double(d.timestamps)*1.0e-6;
  else
    time = double(timestamp)*1.0e-6;
  end
  
  e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  
  cnames = fieldnames(d.data{1});
  
  for i=1:length(cnames)
    for j=1:length(sigliste)
      
      dstructnames = str_split(sigliste{j}{1},'.');
      dname        = cell_concatenate_str_cells(dstructnames,'_');
      dindex = sigliste{j}{2};
      dunit  = sigliste{j}{3};
      dtype  = sigliste{j}{4};
      dlin   = sigliste{j}{5};
      dcom   = sigliste{j}{6};
      
      if( strcmpi(cnames{i},dstructnames{1}) )
%         if( strcmpi('lateral_control_priority',dstructnames{1}))
%           a = 0;
%         end
        n = length(dstructnames);
        if( n == 1 )
          vec = zeros(ndata,1);
          if( strcmpi(dtype,'double') )
            for jj=1:ndata
                if isfield(d.data{jj},cnames{i})
                    vec(jj) = double(d.data{jj}.(cnames{i})(dindex));
                else
                    vec(jj) = NaN;
                end
            end
          else
            for jj=1:ndata
              vec(jj) = round(double(d.data{jj}.(cnames{i})(dindex)));
            end
          end
          [tin,vin] = elim_nicht_monoton(time,vec);
        elseif( n == 2)
          vin = {};
          tin = [];
          for jj=1:ndata
            if( isfield(d.data{jj}.(cnames{i}){1},dstructnames{2}) )
              mdata = length(d.data{jj}.(cnames{i}));
              vec = zeros(mdata,1);
              for k=1:mdata
                vec(k) = d.data{jj}.(cnames{i}){k}.(dstructnames{2});
              end
              tin = [tin;time(jj)];
              if( strcmpi(dtype,'double') )
                vin = cell_add(vin,double(vec));
              else
                vin = cell_add(vin,round(double(vec)));
              end
            end
          end
          index_liste = index_nicht_monoton(tin);
          if( ~isempty(index_liste) )
            tin  = vec_delete(tin,index_liste);
            vin  = cell_delete(vin,index_liste);
          end
        else
          error('%s_err: Channel %s konnte nicht eingelesen werden',mfilename,channel_name)
        end
        e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,vin,dlin);
      end       
    end
  end

  end
