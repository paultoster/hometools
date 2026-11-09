function e = cg_read_ecal_channel_Default(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
                
  e    = struct([]);

  cnames = fieldnames(d.data{1});
  
  ifound = cell_find_f(cnames,'header','f');
  if( ~isempty(ifound) )
    n         = length(d.data);
    timestamp = zeros(n,1);
    for j=1:n
      timestamp(j) = d.data{j}.header.timestamp;
    end
%   else
%     cnames = fieldnames(d);
%     ifound = cell_find_f(cnames,'timestamps','f');
%     if( ~isempty(ifound) )
%       if( ~isnumeric(d.timestamps) )
%         warning('Channel: <%s> kann kein timestamp geelsen werden',channel_name)
%         return
%       else
%         timestamp = d.timestamps;
%       end
%     else
%       warning('Channel: <%s> hat keinen Header und damit kein timestamp',channel_name)
%       return
%     end
  end
  
  if( isfield(d,'timestamps') )
    time = double(d.timestamps)*1.0e-6;
  elseif( exist('timestamp','var') )
    time = double(timestamp)*1.0e-6;
  else
    error('%_err: time is not available',mfilename)
  end

  if( exist('timestamp','var') )
    e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  end

  cnames = fieldnames(d.data{1});
  n      = length(d.data);
  
  if( ~isnumeric(d.data{1}.(cnames{1})(1)) )
    warning('In Channel: <%s> is die data-STruktur komplexer',channel_name)
    return
  else
    for i=1:length(cnames)
      if( ~strcmp(cnames{i},'header') )      
        vec = zeros(n,1);
        for jj=1:n
          vec(jj) = double(d.data{jj}.(cnames{i})(1));
        end
        [tin,vin] = elim_nicht_monoton(time,vec);
        e = e_data_add_value(e,[name_channel,'_',cnames{i}],'','',tin,vin,1);
      end
    end
  end
end