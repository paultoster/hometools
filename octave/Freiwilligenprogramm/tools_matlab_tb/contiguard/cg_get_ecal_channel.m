function e = cg_get_ecal_channel(d,channel_name)

  % get path of m-file
  datfiledir = fullfile_get_dir(datfilename('fullpath'));
  % build fullfilename of the description file
  datdescriptfile = fullfile(datfiledir,[channel_name,'_descipt.dat']);
  
  % if description m-File  does not exist build template with unstructered single values
  if( ~exist(datdescriptfile,'file') )
    sigliste = cg_get_ecal_channel_build_template(d.data);
    cg_get_ecal_channel_write_sigliste(datdescriptfile,sigliste);
  end
  
  % read signal description
  sigliste = cg_get_ecal_channel_read_sigliste(datdescriptfile);

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  %               name,          index, unit, type, lin, com
  sigliste     = {{'response'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'scenarioManager'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'planningId'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'trackProviderStatus'  , 1,'m'  ,'int'   ,0,''} ...
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
  
  cnames = fieldnames(d.data{1});
  
  for i=1:length(cnames)
    for j=1:length(sigliste)
      dname  = sigliste{j}{1};
      dindex = sigliste{j}{2};
      dunit  = sigliste{j}{3};
      dtype  = sigliste{j}{4};
      dlin   = sigliste{j}{5};
      dcom   = sigliste{j}{6};
      
      if( strcmpi(cnames{i},dname) )
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
        e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
      end       
    end
  end

end
