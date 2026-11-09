function [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel)

  ndata = length(d.data);
  
  fail = 0;
  if( isfield(d.data{1},'header') )
    
    timestamp = zeros(ndata,1);
    for j=1:ndata
      try
        timestamp(j) = d.data{j}.header.timestamp;
        
      catch
        fail = 1;
        break;
      end
    end
    if( ~fail )
      if( isfield(d,'timestamps') )
        time = double(d.timestamps)*1.0e-6;
        comment      = 'time stamp from d.timestamps';
      else
        time = double(timestamp)*1.0e-6;
        comment      = 'time stamp from header';
      end
    
      e = e_data_add_value(e,[name_channel,'_timestamp'],'us',comment,time,timestamp,0);
    end    
  else
    fail = 1;
  end
  
  if( fail )
    if( isfield(d,'timestamps') )
      time = double(d.timestamps)*1.0e-6;
    else
      exit('%s_error: no timestamp available',mflename);
    end
  end

end