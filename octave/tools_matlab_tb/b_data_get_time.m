function time  = b_data_get_time(b,type,id,channel)
%
% time  = b_data_get_time(b,type,id,channel)
%
% time  = b_data_get_time(b,1,id)
% time  = b_data_get_time(b,2,id,channel)
%
% Rückgave Zeitvektor fo message mit id mit entspr. channel
%
  if( ~data_is_bstruct_format_f(b) )
    error('%s: b hat nicht das richtige Datenformat b.time(i), b.id(i), b.channel(i), b.len(i), b.byte0(i), ...  b.byte7(i), d.receive(i)',mfilename);
  end
  if( ~exist('id','var') )
    error('%s_error: id fehlt',mfilename);
  end
  time = [];
  if( type == 1 )
    for i=1:length(b.time)

      if( b.id(i) == id )
        time = [time;d.time(i)];
      end
    end
  else
    if( ~exist('channel','var') )
      error('%s_error: channel fehlt',mfilename);
    end
    for i=1:length(b.time)

      if( (b.id(i) == id) && (b.channel(i) == channel) )
        time = [time;b.time(i)];
      end
    end
  end
end
