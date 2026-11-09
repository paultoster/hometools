function flag = iscellstring(cval)
%
% flag = iscellstring(cval)
%
% cval is a cell-array with strings

  flag = 0;
  
  if( iscell(cval) )
    for i=1:length(cval)
      if( ~ischar(cval{i}) )
        return
      end
    end
  end

  flag = 1;
end