function e = cg_read_ecal_channel_TrainParkPathPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end  
  
  sigliste     = {{'waypoint.xPos'          , 1,'m'     ,'double',1,'Pathwaypoint on path/Trajectory x-Posistion FA'} ...
                 ,{'waypoint.yPos'          , 1,'m'     ,'double',1,'Pathwaypoint on path/Trajectory y-Posistion FA'} ...
                 ,{'waypoint.waypoint_type' , 1,'enum'  ,'int',0,'Pathwaypoint type, 0:TP_WAYPOINT_UNDEF, 1:TP_WAYPOINT_BARRIER 2:TP_WAYPOINT_STOP_SIGN, 3:TP_WAYPOINT_END_OF_PATH'} ...
                 ,{'waypoint.id'            , 1,'enum'  ,'int',0,''} ...
                 ,{'flagValid'              , 1,'enum'  ,'int',0,''} ...
                 ,{'flagNew'                , 1,'enum'  ,'int',0,''} ...
                 ,{'flagClosedPath'         , 1,'enum'  ,'int',0,''} ...
                 ,{'iActSec'                , 1,'enum'  ,'int',0,''} ...
                 ,{'iAct'                   , 1,'enum'  ,'int',0,''} ...
                 ,{'dPath'                  , 1,'-'     ,'double',0,''} ...
                 ,{'section.dir'            , 1,'enum'  ,'int',0,''} ...
                 ,{'section.xFAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.yFAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.sFAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.xRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.yRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.sRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.yawtanRAVec'    , 1,'m'     ,'double',0,''} ...
                 ,{'section.yawVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.velVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.timeVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.kappaRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.dxdsRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.dydsRAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.d2xds2RAVec'         , 1,'m'     ,'double',0,''} ...
                 ,{'section.d2yds2RAVec'         , 1,'m'     ,'double',0,''} ...
                 };
                 

         
               
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
%     if( i == 1 )
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
%           s.vin = vin;
%         elseif( n == 2)
%           s.vin = {};
%           tin = time(1:ndata);
%           % Länge von Unterstruktur
%           m2data = 0;
%           for jj=1:ndata
%             if(  isfield(d.data{jj},cnames{i}) ...
%               && isfield(d.data{jj}.(cnames{i}){1},dstructnames{2}) )
%               m2data = max(m2data,length(d.data{jj}.(cnames{i}){1}.(dstructnames{2})));
%             end
%           end
%           for jj=1:ndata
%             if(  isfield(d.data{jj},cnames{i}) ...
%               && isfield(d.data{jj}.(cnames{i}){1},dstructnames{2}) )
%               mdata = length(d.data{jj}.(cnames{i}));
%               if( m2data == 0 )
%                 s.vin = cell_add(s.vin,[]);
%               elseif( m2data == 1 )                
%                 vec = zeros(mdata,1);
%                 for k=1:mdata
%                   vec(k) = d.data{jj}.(cnames{i}){k}.(dstructnames{2});
%                 end
%               
%                 if( strcmpi(dtype,'double') )
%                   s.vin = cell_add(s.vin,double(vec));
%                 else
%                   s.vin = cell_add(s.vin,round(double(vec)));                
%                 end
%               else
%                 if( mdata == 1 )
%                   s.vin = cell_add(s.vin,d.data{jj}.(cnames{i}){1}.(dstructnames{2}));
%                 else
%                   for k=1:mdata                    
%                     s(k).vin = d.data{jj}.(cnames{i}){k}.(dstructnames{2});
%                   end
%                 end
%               end
%             else
%               s.vin = cell_add(s.vin,[]);
%             end
%             
%           end
%           index_liste = index_nicht_monoton(tin);
%           if( ~isempty(index_liste) )
%             tin  = vec_delete(tin,index_liste);
%             nvin = length(s);
%             if( nvin == 1 )
%               s.vin  = cell_delete(s.vin,index_liste);
%             else
%               for k=1:nvin
%                 s(k).vin = cell_delete(s(k).vin,index_liste);
%               end
%             end
%           end
%         else
%           error('%s_err: Channel %s konnte nicht eingelesen werden',mfilename,channel_name)
%         end
%         
%         nvin = length(s);
%         if( nvin == 1 )        
%           e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,s.vin,dlin);
%         else
%           for k=1:nvin
%             dname = sprintf('%s%i_%s',cnames{i},k,dstructnames{2});
%             e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,s(k).vin,dlin);
%           end
%         end
%       end       
%     end
%   end

  end
