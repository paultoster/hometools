function text = cell_str_build_text(cc,flag)
%
% function text = cell_str_build_text(cc)
% function text = cell_str_build_text(cc,flag)
%
% bilde einen Text aus cellarray mit strings
%
% cc           cellarrayy mit strings
% flag         0: (default) ohne Zeilentrennung ('\n')
%              1: mit Zeilentrennung ('\n')
%
  if( ~exist('flag','var') )
    flag = 0;
  end

  text = [];
  if( iscell(cc) )
    
    for i=1:length(cc)
        
       str = cc{i};
       if( ischar(str) )
          
         text = [text,str];
         
         if( flag )
           text = [text,sprintf('\n')];
         end
       end
    end
  end
end
