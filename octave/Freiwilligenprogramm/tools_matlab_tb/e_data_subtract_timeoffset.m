function [e] = e_data_subtract_timeoffset(e,timeoffset)
%
% e = e_data_subtract_timeoffset(e,toffset)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% timeoffset  Time Offset to subtract
  
  c_names = fieldnames(e);
  ne      = length(c_names);
  for ie=1:ne
    if( e_data_is_timevec(e,c_names{ie}) )
      e.(c_names{ie}).time = e.(c_names{ie}).time - timeoffset;
    end
  end
end