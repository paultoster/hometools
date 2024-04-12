function index = struct_find_in_field(s,fieldname,item)
%
% index = struct_find_in_field(s,fieldname,item)
%
% Find in struct s(i).name = item
% 
% s             struct with Index
% fieldname     fieldname of s
% item          char or num-value
%
% index         not found index = 0
  index = 0;

  if( ~isstruct(s) )
    error('%s_error: s (first parameter) no struct',mfilename);
  end
  if( ~isfield(s,fieldname) )
    error''%s_error: fieldname: %s is not in structure',mfilename,fieldname);
  end

  n = length(s);
  if( ischar(item) )
    
    if( ~ischar(s(1).(fieldname)) )
      error('%_error: s.%s is kein char',mfilename)
    end
    
    for i=1:n
      if( strcmp(s(i).(fieldname),item) )
        index = i;
        return;
      end
    end
  elseif( isnumeric(item) )
    
    if( ~isnumeric(s(1).(fieldname)) )
      error('%_error: s.%s is kein numeric',mfilename)
    end
    e = eps*10;
    for i=1:n
      if( abs(s(i).(fieldname)(1)-item(1)) < e )
        index = i;
        return;
      end
    end
  else
    error('%s_error: type of item not numeric or char and is not implemented',mfilename);
  end
end