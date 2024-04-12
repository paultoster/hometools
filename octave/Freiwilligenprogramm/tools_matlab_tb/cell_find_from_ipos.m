function [jcell,jpos] = cell_find_from_ipos(carr,icell,ipos,str,type)
%
% [jcell,jpos] = cell_find_from_ipos(carray,icell,ipos,str,type)
%
% Sucht von carr{icell}(ipos) bis an das Ende nach str,
% wenn gefunden wird jcell > 0 und jpos > 0 zurückgegeben
%
% type = 'for':    forward
%        'back':   backward
%
  if( ~exist('type','var') )
    type = 'for';
  end
  jcell = 0;
  jpos  = 0;
  runfl = 1;
  nstr  = length(str);
  nc    = length(carr);
  % Wenn ipos durch aufaddieren größer als die angesprochene Zelle:
  while( nc && (ipos > length(carr{icell})) )
    icell = icell + 1;
    if( icell > nc )
      icell = nc;
      ipos  = length(carr{nc});
    else
      ipos = ipos - length(carr{icell-1});
    end
  end
  % Wenn ipos durch Subtraktion kleiner 1 ist:
  while( ipos < 1 )
    icell = icell-1;
    if( icell < 1 )
      icell = 1;
      ipos  = 1;
    else
      ipos = length(carr{icell}) + ipos;
    end
  end
  if( strcmpi(type(1),'f') )    
    while( icell <= nc && runfl )
      npos = length(carr{icell});
      tt   = carr{icell};
      while( ipos <= npos && runfl )
        i1 = ipos+nstr-1;
        if( i1 > npos )
          ipos = npos+1;
        else
          if( strcmp(tt(ipos:i1),str) )
            jcell = icell;
            jpos  = ipos;
            runfl = 0;
          else
            ipos = ipos + 1;
          end
        end
      end
      icell = icell + 1;
      ipos  = 1;
    end
  else % backward
    while( icell >= 1 && runfl )
      tt   = carr{icell};
      while( ipos >= 1 && runfl )
        i0 = ipos-nstr;
        i1 = i0+nstr-1;
        if( i0 > 0 )
          if( strcmp(tt(i0:i1),str) )
            jcell = icell;
            jpos  = i0;
            runfl = 0;
          end    
        end
        ipos = ipos - 1;
      end
      icell = icell - 1;
      if( icell > 0 )
        npos = length(carr{icell});
        ipos = npos;
      end
    end
  end
end
      
      
    
    