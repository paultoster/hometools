function e = cg_read_ecal_channel_TrafficLightListPb(d,channel_name)

  name_channel = str_cut_f(channel_name,'Pb');
%   ii = str_find_f(channel_name,'Pb');
%   if( (ii > 0) && (length(channel_name) == ii+1) )
%     name_channel = channel_name(1:max(1,ii-1));
%   else
%     name_channel = channel_name;
%   end
 
  sigliste     = {{'data.object_id'                        , 1,'enum'   ,'int'     ,0,''} ...
                 ,{'data.object_valid'                     , 1,'enum'   ,'int'     ,0,''} ...
                 ,{'data.object_type'                      , 1,'enum'   ,'int'     ,0,''} ...
                 ,{'data.position_img_u0'                  , 1,'enum'   ,'int'     ,1,''} ...
                 ,{'data.position_img_v0'                  , 1,'enum'   ,'int'     ,1,''} ...
                 ,{'data.position_img_u1'                  , 1,'enum'   ,'int'     ,1,''} ...
                 ,{'data.position_img_v1'                  , 1,'enum'   ,'int'     ,1,''} ...
                 ,{'data.position_is_in_background'        , 1,'enum'   ,'int'     ,0,''} ...
                 ,{'data.position_car_coordinate_system_x' , 1,'m'   ,'double'     ,1,''} ...
                 ,{'data.position_car_coordinate_system_y' , 1,'m'   ,'double'     ,1,''} ...
                 ,{'data.position_car_coordinate_system_z' , 1,'m'   ,'double'     ,1,''} ...
                 ,{'data.light_state'                      , 1,'enum'   ,'int'     ,0,'0:RED,1:RED_AND_YELLOW,2:GREEN,3:YELLOW,4:NONE'} ...
                 ,{'data.arrow_type'                       , 1,'enum'   ,'int'     ,0,'0:LEFT,1:HALF_LEFT,2:STRAIGHT_AND_LEFT,3:STRAIGHT,4:STRAIGHT_AND_RIGHT,5:HALF_RIGHT,6:RIGHT,7:NO_ARROW,8:PED'} ...
                 ,{'data.track_lifetime'                   , 1,'enum'   ,'int'     ,1,''} ...
                 ,{'data.track_confidence'                 , 1,'-'      ,'double'  ,1,''} ...
                 ,{'data.top_bottom'                       , 1,'-'      ,'int'     ,0,'0:BOTTOM,1:TOP'} ...
                 };                 


  e    = struct([]);
  
%   for i=1:length(d.data)
%     if( isfield(d.data{i},'data') )
%       if( length(d.data{i}.data) > 1 )
%         if( d.data{i}.data{2}.light_state > 0 )
%           a = 0;
%         end
%       end
%     end
%   end
      
  
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
   
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

%   for i=1:length(sigliste)
%     ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
%     e  = merge_struct_f(e,ee);
%   end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);
  
end