function write_to_screen(c)
%
% write_to_screen(c)
%
% write text to screen
% a) c       cellarray of text
%
  if( iscell(c) )
    for i=1:length(c)
      
      txt = c{i};
      if( ischar(txt) )
        fprintf('%s\n',txt);
      end
    end
  else
    error('write_to_screen(c): c is not a cellarray')
  end


end