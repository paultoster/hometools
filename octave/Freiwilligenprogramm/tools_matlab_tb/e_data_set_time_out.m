function e = e_data_set_time_out(e,timeout,c_names)
%
% e = e_data_set_time_out(e,timeout,c_names)
%
% e             e-Datenstruktur mit e.time,e.vec,e.lin
%
% timeout       timeout für die Signale
%
% c_names       welche STrukturnamen setzen {}:alle (default {})
%
  if( isempty(timeout) || timeout < 0 )
    return; % nicht setzen
  end
  if( ~exist('c_names','var') )
    c_names = {};
  end

  if( isempty(c_names) )
    c_names = fieldnames(e);
  end

  n = length(c_names);

  for i=1:n  
    e.(c_names{i}).timeout = timeout;
  end

end
  