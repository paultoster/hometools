function e = cg_read_ecal_channel_ParkTrackPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  sigliste     = {{'data.id'             , 1,'enum'    ,'int',0,''} ...
                 ,{'valid'               , 1,'enum'    ,'int',0,''} ...
                 ,{'scenario_manager'    , 1,'enum'    ,'int',0,''} ...
                 ,{'planning_id'         , 1,'enum'    ,'int',0,''} ...
                 ,{'change_counter'      , 1,'enum'    ,'int',0,''} ...
                 ,{'point_front.x'       , 1,'m'       ,'double',1,''} ...
                 ,{'point_front.y'       , 1,'m'       ,'double',1,''} ...
                 ,{'point_rear.x'        , 1,'m'       ,'double',1,''} ...
                 ,{'point_rear.y'        , 1,'m'       ,'double',1,''} ...
                 ,{'point_max_speed.v'   , 1,'m/s'     ,'double',1,''} ...
                 ,{'point_max_speed.dir' , 1,'enum'    ,'int',1,''} ...
                 };
                 
%                  header: [1x1 struct]
%                     x_m: 9.138123145081461e+02
%                     y_m: -5.508884514697104e+02
%                  x_ra_m: 9.116008999764259e+02
%                  y_ra_m: -5.493185502725337e+02
%                 x_cog_m: 9.128240274829083e+02
%                 y_cog_m: -5.501868584568128e+02
%                 yaw_rad: -0.617344822108180
%           slip_angle_ra: 7.923510775588877e-04
%                 sigma_x: 0
%                 sigma_y: 0
%     sigma_slip_angle_ra: 1
%         sigma_yaw_angle: 0
%               track_rad: 0
%           motion_status: 1

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
  

 % e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);  
  
  
  cnames = cell_collect_all_struct_names(d.data);
  
  for i=1:length(cnames)
    if( i == 14 )
      abc = 0;
    end
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
              vec(jj) = double(d.data{jj}.(cnames{i})(dindex));
            end
          else
            for jj=1:ndata
              vec(jj) = round(double(d.data{jj}.(cnames{i})(dindex)));
            end
          end
          [tin,vin] = elim_nicht_monoton(time,vec);
        elseif( n == 2)
          vin = {};
          tin = time(1:ndata);
          for jj=1:ndata
            if(  isfield(d.data{jj},cnames{i}) ...
              && isfield(d.data{jj}.(cnames{i}){1},dstructnames{2}) )
              mdata = length(d.data{jj}.(cnames{i}));
              vec = zeros(mdata,1);
              for k=1:mdata
                vec(k) = d.data{jj}.(cnames{i}){k}.(dstructnames{2});
              end
              
              if( strcmpi(dtype,'double') )
                vin = cell_add(vin,double(vec));
              else
                vin = cell_add(vin,round(double(vec)));                
              end
            else
              vin = cell_add(vin,[]);
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
