function e = cg_read_ecal_channel_TrainParkLearnResponsePb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end  
  
  sigliste     = {{'state'             , 1,'enum'    ,'int',0,''} ...
                 ,{'start_pos_state'   , 1,'enum'    ,'int',0,''} ...
                 ,{'TPLMode'           , 1,'enum'    ,'int',0,''} ...                 
                 ,{'end_pos_state'     , 1,'enum'    ,'int',0,''} ...
                 ,{'triggerstate'     , 1,'enum'    ,'int',0,''} ...                 
                 ,{'start_position.x'  , 1,'m'    ,'double',1,''} ...
                 ,{'start_position.y'  , 1,'m'    ,'double',1,''} ...
                 ,{'end_position.x'    , 1,'m'    ,'double',1,''} ...
                 ,{'end_position.y'    , 1,'m'    ,'double',1,''} ...
                 ,{'start_pos_yaw'     , 1,'rad'  ,'double',1,''} ...
                 ,{'end_pos_yaw'       , 1,'rad'  ,'double',1,''} ...
                 };
 
                
%             header: [1x1 struct]
%       process_time_ms: 17
%          loop_time_ms: 75
%       flag_course_new: 1
%           xcourse_vec: [14x1 double]
%           ycourse_vec: [14x1 double]
%           scourse_vec: [14x1 double]
%         yawcourse_vec: [14x1 double]
%         xcourse_l_vec: [14x1 double]
%         ycourse_l_vec: [14x1 double]
%         xcourse_r_vec: [14x1 double]
%       xlanemark_l_vec: [17x1 double]
%       ylanemark_l_vec: [17x1 double]
%       xlanemark_r_vec: [17x1 double]
%       ylanemark_r_vec: [17x1 double]
%     id_lanemark_l_vec: [17x1 double]
%     id_lanemark_r_vec: [17x1 double]
%         flag_path_new: 0
%             xpath_vec: [13x1 double]
%             ypath_vec: [13x1 double]
%           yawpath_vec: [13x1 double]
%           xspline_vec: [15x1 double]
%           yspline_vec: [15x1 double]

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

  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);  

%   cnames = cell_collect_all_struct_names(d.data);
%   
%   for i=1:length(cnames)
%     if( i == 14 )
%       abc = 0;
%     end
%     for j=1:length(sigliste)
%       
%       dstructnames = str_split(sigliste{j}{1},'.');
%       dname        = cell_concatenate_str_cells(dstructnames,'_');
%       dindex = sigliste{j}{2};
%       dunit  = sigliste{j}{3};
%       dtype  = sigliste{j}{4};
%       dlin   = sigliste{j}{5};
%       dcom   = sigliste{j}{6};
%       
%       if( strcmpi(cnames{i},dstructnames{1}) )
% %         if( strcmpi('lateral_control_priority',dstructnames{1}))
% %           a = 0;
% %         end
%         n = length(dstructnames);
%         if( n == 1 )
%           vec = zeros(ndata,1);
%           if( strcmpi(dtype,'double') )
%             for jj=1:ndata
%               vec(jj) = double(d.data{jj}.(cnames{i})(dindex));
%             end
%           else
%             for jj=1:ndata
%               vec(jj) = round(double(d.data{jj}.(cnames{i})(dindex)));
%             end
%           end
%           [tin,vin] = elim_nicht_monoton(time,vec);
%         elseif( n == 2)
%           vin = {};
%           tin = time(1:ndata);
%           for jj=1:ndata
%             if(  isfield(d.data{jj},cnames{i}) ...
%               && isfield(d.data{jj}.(cnames{i}){1},dstructnames{2}) )
%               mdata = length(d.data{jj}.(cnames{i}));
%               vec = zeros(mdata,1);
%               for k=1:mdata
%                 vec(k) = d.data{jj}.(cnames{i}){k}.(dstructnames{2});
%               end
%               
%               if( strcmpi(dtype,'double') )
%                 vin = cell_add(vin,double(vec));
%               else
%                 vin = cell_add(vin,round(double(vec)));                
%               end
%             else
%               vin = cell_add(vin,[]);
%             end
%             
%           end
%           index_liste = index_nicht_monoton(tin);
%           if( ~isempty(index_liste) )
%             tin  = vec_delete(tin,index_liste);
%             vin  = cell_delete(vin,index_liste);
%           end
%         else
%           error('%s_err: Channel %s konnte nicht eingelesen werden',mfilename,channel_name)
%         end
%         e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,vin,dlin);
%       end       
%     end
%   end

  end
