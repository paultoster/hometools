function n = cell_char_max_length(c)
%
% n = cell_char_max_length(c)
%
% search for max-length in cell array with char
%
% n = 0  no char was set or empty
%
  
  n = 0;
  for i=1:length(c)
    if( ischar(c{i}) )
      n = max(n,length(c{i}));
    end
  end
end