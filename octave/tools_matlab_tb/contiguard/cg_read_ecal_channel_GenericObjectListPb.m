function e = cg_read_ecal_channel_GenericObjectListPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end  
  
  sigliste     = {{'data.id'             , 1,'enum'    ,'int',0,''} ...
                 ,{'data.is_valid'       , 1,'enum'    ,'int',0,''} ...
                 ,{'data.reliability'    , 1,'enum'    ,'int',0,''} ...
                 ,{'data.x'              , 1,'m'       ,'double',1,''} ...
                 ,{'data.y'              , 1,'m'       ,'double',1,''} ...
                 ,{'data.vx_rel'         , 1,'m/s'     ,'double',1,''} ...
                 ,{'data.vy_rel'         , 1,'m/s'     ,'double',1,''} ...
                 };
 
                
% 
%   /// administration
%   optional  uint64      id                        =   1;                         ///  object id
%   optional  bool        is_valid                  =   2;                         ///  0: object invalid 1: object valid
%   optional  Reliabilities reliability             =   3;                         ///  0: undefined 1: very low  2: low 3: medium 4: high 5: very high
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  sint64      timestamp                 =   4;                         ///  timestamp [us]
% 
%   /// position (relative to midth of front axle of ego-car and the nearest point of the object)
%   optional  float       x                         =   5  [default = -666666.0];  ///  x position [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       y                         =   6  [default = -666666.0];  ///  y position [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_x                     =   7  [default = -666666.0];  ///  tolerance x position [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_y                     =   8  [default = -666666.0];  ///  tolerance y position [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  double      lat                       =   9  [default = -666666.0];  ///  default = EGeneral::INVALID_VALUE
%   optional  double      lon                       =  10  [default = -666666.0];  ///  default = EGeneral::INVALID_VALUE
% 
%   optional  sint64      meas_timestamp            =  11;                         ///  physical measurement timestamp [us]
% 
%   /// dynamic data
%   optional  float       vx_abs                    =  12  [default = -666666.0];  ///  absolute velocity x in static ego-car-system [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       vy_abs                    =  13  [default = -666666.0];  ///  absolute velocity y in static ego-car-system [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       vx_rel                    =  14  [default = -666666.0];  ///  absolute velocity x in moving ego-car-system [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       vy_rel                    =  15  [default = -666666.0];  ///  absolute velocity y in moving ego-car-system [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       ax_abs                    =  16  [default = -666666.0];  ///  absolute accelertion x [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       ay_abs                    =  17  [default = -666666.0];  ///  absolute accelertion y [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       ax_rel                    =  18  [default = -666666.0];  ///  accelertion x in ego-car-system  [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       ay_rel                    =  19  [default = -666666.0];  ///  accelertion y in ego-car-system  [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       steer_angle               =  20  [default = -666666.0];  ///  steer angle [rad]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       yaw_rate                  =  21  [default = -666666.0];  ///  yaw rate [rad/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       heading                   =  22  [default = -666666.0];  ///  [rad] moving direction of object if v_object > 0 (see vx/vy), pointing direction in standstill
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_vx_abs                =  23  [default = -666666.0];  ///  tolerance absolute velocity x [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_vy_abs                =  24  [default = -666666.0];  ///  tolerance absolute velocity y [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_vx_rel                =  25  [default = -666666.0];  ///  tolerance relative velocity x [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_vy_rel                =  26  [default = -666666.0];  ///  tolerance relative velocity y [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_ax_abs                =  27  [default = -666666.0];  ///  tolerance absolute accelertion x [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_ay_abs                =  28  [default = -666666.0];  ///  tolerance absolute accelertion y [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_ax_rel                =  29  [default = -666666.0];  ///  tolerance relative accelertion x [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_ay_rel                =  30  [default = -666666.0];  ///  tolerance relative accelertion y [m/s2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_steer_angle           =  31  [default = -666666.0];  ///  tolerance steer angle [rad]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_yaw_rate              =  32  [default = -666666.0];  ///  tolerance yaw rate [rad/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_heading               =  33  [default = -666666.0];  ///  tolerance heading [rad]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
% 
%   /// trajectory
%   optional  float       c0                        =  34  [default = -666666.0];  ///  curvature [1/m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       c1                        =  35  [default = -666666.0];  ///  change of curvature [1/m2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_c0                    =  36  [default = -666666.0];  ///  tolerance curvature [1/m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_c1                    =  37  [default = -666666.0];  ///  tolerance change of curvature [1/m2]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
% 
%   /// static data (geometric and mass)
%   optional  float       width                     =  38  [default = -666666.0];  ///  width of object   [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       height                    =  39  [default = -666666.0];  ///  height of object  [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       length                    =  40  [default = -666666.0];  ///  length of object  [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_width                 =  41  [default = -666666.0];  ///  tolerance width of object  [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_height                =  42  [default = -666666.0];  ///  tolerance height of object [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       err_length                =  43  [default = -666666.0];  ///  tolerance length of object [m]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  float       mass                      =  44  [default = -666666.0];  ///  mass of object [kg]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
% 
%   /// classification
%   optional  Dyns        dyn_category              =  45               ;          ///  see EO_DYN_XXX, 0: undefined 1: moving 2: not moving 3: stopped
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  float       max_observed_velocity     =  46  [default = -666666.0];  ///  max observed absolute velocity [m/s]
%                                                                                  ///  default = EGeneral::INVALID_VALUE
%   optional  Shapes      recognized_shape          =  47               ;          ///  see EO_SHAPE_XXX, 0: undefined 1: car 2: truck 3: motorbike 4: bike 5: pedestrian
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  Shapes      communicated_shape        =  48               ;          ///  see EO_SHAPE_XXX, 0: undefined 1: car 2: truck 3: motorbike 4: bike 5: pedestrian
%                                                                                  ///  default = NOT_AVAILABLE
% 
%   /// other attributes
%   optional  Indicators  indicator_state           =  49               ;          ///  see EO_INDICATOR_XXX, 0: undefined 1: off 2: right 3:left 4: both
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  Lights      light_state               =  50               ;          ///  0: undefined 1: off 2: low beam 3: high beam
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  WarnLights  warning_light_state       =  51               ;          ///  0: undefined 1: off 2: amber light 2: blue light
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  Situations  situation_info            =  52               ;          ///  see EO_SITUTAION_XXX: 0: undefined: 1: obj is in normal state, 2: obj has a breakdown
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  Dids        driver_induced_state      =  53               ;          ///  see: EO_DID_XXXX: 0: undefined 1: acceleration 2: deceleration
%                                                                                  ///  default = NOT_AVAILABLE
%   optional  uint64      c2x_object_id             =  54;                         ///  id of associated c2x object
%                                                                                  ///  default = NOT_AVAILABLE
% 
%   optional  float       age                        = 55;                          ///  [s] elapsed time since first detection of object
%   optional  Refs        reference_point_box_model  = 56;                          ///  point of the object box that corresponds to the xy-position (see EO_REF_XXX)
%                                                                                   ///  default = NOT_AVAILABLE
%   optional  Vulnerabilities vulnerability          = 57;                          ///  vulnerability of object (see EO_VULNERAB_XXX)
%                                                                                   ///  default = NOT_AVAILABLE
%   optional  bool        visually_validated         = 58;                          ///  0: object not confirmed visually 1: object confirmed visually
%
%   enum General
%   {
%     NOT_AVAILABLE            = 0;               // to be used for states,categories...
%     INVALID_VALUE            = -666666;         // to be used for floating values
%   }
% 
%   enum Shapes
%   {
%     SHAPE_UNDEFINED          = 0;//NOT_AVAILABLE;
%     SHAPE_CAR                = 1;
%     SHAPE_TRUCK              = 2;
%     SHAPE_MOTORBIKE          = 3;
%     SHAPE_BIKE               = 4;
%     SHAPE_PEDESTRIAN         = 5;
%     SHAPE_GUARDRAIL          = 6;
%   }
% 
%   enum Dyns
%   {
%     DYN_UNDEFINED            = 0;//NOT_AVAILABLE;
%     DYN_MOVING               = 3;
%     DYN_NOT_MOVING           = 2;
%     //DYN_STOPPED            = 2;
%     DYN_ONCOMING             = 1;
%   }
% 
%   enum Situations
%   {
%     SITUTAION_UNDEFINED      = 0;//NOT_AVAILABLE;
%     SITUATION_NORMAL         = 1;
%     SITUATION_BREAKDOWN      = 2;
%     SITUATION_EMERGENCY      = 3;
%   }
% 
%   enum Indicators
%   {
%     INDICATOR_UNDEFINED      = 0;//NOT_AVAILABLE;
%     INDICATOR_OFF            = 1;
%     INDICATOR_RIGHT          = 2;
%     INDICATOR_LEFT           = 3;
%     INDICATOR_BOTH           = 4;
%   }
% 
%   enum Dids
%   {
%     DID_UNDEFINED            = 0;//NOT_AVAILABLE;
%     DID_ACCELERATION         = 1;
%     DID_DECELERATION         = 2;
%   }
% 
%   enum Refs
%   {
%     REF_UNDEFINED            = 0;//NOT_AVAILABLE;
%     REF_FRONT_LEFT           = 1;
%     REF_FRONT_MIDDLE         = 2;
%     REF_FRONT_RIGHT          = 3;
%     REF_MIDDLE_LEFT          = 4;
%     REF_MIDDLE_MIDDLE        = 5;
%     REF_MIDDLE_RIGHT         = 6;
%     REF_REAR_LEFT            = 7;
%     REF_REAR_MIDDLE          = 8;
%     REF_REAR_RIGHT           = 9;
%   }
% 
%   enum Vulnerabilities
%   {
%     VULNERAB_NOT_DEF         = 0;//NOT_AVAILABLE;
%     VULNERAB_SMALL           = 1;
%     VULNERAB_MEDIUM          = 2;
%     VULNERAB_HEAVY           = 3;
%     VULNERAB_FATAL           = 4;
%   }
% 
%   enum Reliabilities
%   {
%     REL_UNDEFINED   = 0;
%     REL_VERY_LOW    = 1;
%     REL_LOW         = 2;
%     REL_MEDIUM      = 3;
%     REL_HIGH        = 4;
%     REL_VERY_HIGH   = 5;
%   }
% 
%   enum Lights
%   {
%     LGT_UNDEFINED   = 0;
%     LGT_OFF         = 1;
%     LGT_LOW_BEAM    = 2;
%     LGT_HIGH_BEAM   = 3;
%   }
% 
%   enum WarnLights
%   {
%     WLGT_UNDEFINED   = 0;
%     WLGT_OFF         = 1;
%     WLGT_AMBER_LIGHT = 2;
%     WLGT_BLUE_LIGHT  = 3;
%   }

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
