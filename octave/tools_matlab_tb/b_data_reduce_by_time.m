function b = b_data_reduce_by_time(b,t_start,t_end)
%
% b = b_data_reduce_by_time(b,t_start,t_end)
%
% Reduziert b-Struktur auf b(i).time >= t_start und b(i).time <= t_end
% Wenn t_start < 0 , dann nicht berücksichtigen
% Wenn t_end < 0 , dann nicht berücksichtigen
%
  if( ~exist('t_start','var') )
    t_start = -1;
  end
  if( ~exist('t_end','var') )
    t_end = -1;
  end

  n = length(b.time);
  if( t_end < 0.0 )
    t_end = b.time(n);
  end
  if( t_start < 0.0 )
    t_start = b.time(1);
  end
  
  i0 = 0;
  i1 = 0;
  
  for i=1:n
    if( b.time(i) >= t_start )
      i0 = i;
      break;
    end
  end
  
  for i=i0:n
    if( b.time(i) > t_end )
      i1 = i;
      break;
    end
  end
  if( i0 == 0 )
    i0 = 1;
  end
  if( i1 == 0 )
    i1 = n;
  end
  
  b=b_data_reduce(b,i0,i1);
end
function  b=b_data_reduce(b,i0,i1)

 b.time    = b.time(i0:i1);
 b.id      = b.id(i0:i1);
 b.channel = b.channel(i0:i1);
 b.len     = b.len(i0:i1);
 b.byte0   = b.byte0(i0:i1);
 b.byte1   = b.byte1(i0:i1);
 b.byte2   = b.byte2(i0:i1);
 b.byte3   = b.byte3(i0:i1);
 b.byte4   = b.byte4(i0:i1);
 b.byte5   = b.byte5(i0:i1);
 b.byte6   = b.byte6(i0:i1);
 b.byte7   = b.byte7(i0:i1);
 b.receive = b.receive(i0:i1);
end
