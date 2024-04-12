function [pb] = pb_data_subtract_timeoffset(pb,timeoffset)
%
% pb = pb_data_subtract_timeoffset(pb,toffset)
%
% pb          protbuf-Datenstruktur: pb.name.time
%                                   ,pb.name.timestamps
%                                   ,pd.name.data
%             ...
% timeoffset  Time Offset to subtract
  
  c_names = fieldnames(pb);
  npb      = length(c_names);
  for ip=1:npb
    pb.(c_names{ip}).time = pb.(c_names{ip}).time - timeoffset;
  end
end