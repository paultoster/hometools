function e = cg_read_ecal_channel_signal(sigliste,data,time,name_channel)
%
% e = cg_read_ecal_channel_signal(sigliste,data,time,name_channel)
%
% reads ecal-data and given time-vector into e-structur
% sigliste contains info about searched signal
% sigliste = {name,index,unit,type,lin,comment}
% f.e
% sigliste = {'signals.car_id'           , 1,'enum'     ,'int'    , 1, ''}
% sigliste = {'lateral_deviation_y'      , 1,'m'        ,'double' , 1, ''}
% name: if structered then structurename then '.' and signal name
%       this structured name should be found in data[i}
% index: data{i}.name is a vector with n-tuples index says wich tuple
%        (normally index=1
% unit:  text with unit 'm', 'km/h', 'enum', '-'
% type:  double or int
% lin:   0/1  if transformed use linear or constant interploation
% comment: comment

  dstructnames = str_split(sigliste{1},'.');
  dname        = cell_concatenate_str_cells(dstructnames,'_');
  dindex       = sigliste{2};
  dunit        = sigliste{3};
  dtype        = sigliste{4};
  dlin         = sigliste{5};
  dcom         = sigliste{6};
  
  flag0  = 0;
  ndata = length(data);
  
  vec = zeros(ndata,1);
  for j=1:ndata
    
    d = get_cell_struct_data(data{j},dstructnames);
    if( ~isempty(d) )
      if( length(d) < dindex)
        dindex = length(d);
      end
      if( strcmpi(dtype,'double') )        
        vec(j) = double(d(dindex));
      else
        vec(j) = round(double(d(dindex)));
      end
      flag0   = 1;
    end
  end
  e = struct([]);
  if( flag0 )
    [tin,vin] = elim_nicht_monoton(time,vec);
     e = e_data_add_value(e,[name_channel,'_',dname],dunit,dcom,tin,vin,dlin);
  end
    
  
end
function d = get_cell_struct_data(data,dstructnames)

  flag = 0;
  n = length(dstructnames);
  for i=1:n
    if( isfield(data,dstructnames{i}) )
      data = data.(dstructnames{i});
      if( i == n )
        flag = 1;
      end
    end
  end
  if( flag )
    d = data;
  else
    d = [];
  end
end



