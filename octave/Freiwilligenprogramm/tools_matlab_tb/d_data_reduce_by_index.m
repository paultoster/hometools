function   d = d_data_reduce_by_index(d,i0,i1,zero_flag)
%
% d = d_data_reduce_by_index(d,i0,i1,zero_flag)
%
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% i0          Index Beginn
% i1          Index ende
% zero_flag   flag Zeitvektor geht aus null raus default = 0
% 
  if( ~exist('zero_flag','var') )
    zero_flag = 0;
  end
  i0 = round(i0);
  i1 = round(i1);
  
  if( i0 > i1 )
    error('Ausschnitt von i0...i1 geht nicht i0=%i, i1=%i',i0,i1);
  end
  c_names = fieldnames(d);
  nd      = length(d);
  for id=1:nd
    ii1 = min(i1,length(d(id).time));
    ii0 = max(i0,1);
    
    if( zero_flag )
      d(id).(c_names{1}) = d(id).(c_names{1})(ii0:ii1) - d(id).(c_names{1})(ii0);
    else
      d(id).(c_names{1}) = d(id).(c_names{1})(ii0:ii1);
    end
    for j = 2:length(c_names)
      try
        d(id).(c_names{j}) = d(id).(c_names{j})(ii0:ii1);
      end
        
    end
  end