function [c] = cell_get_with_ipos(carr,icell0,ipos0,icell1,ipos1,type)
%
% cellarray = cell_get_with_ipos(carr,icell0,ipos0,icell1,ipos1,'cell')
% text      = cell_get_with_ipos(carr,icell0,ipos0,icell1,ipos1,'text')
% text      = cell_get_with_ipos(carr,icell0,ipos0,icell1,ipos1)
% text      = cell_get_with_ipos(carr)
%
% erstellt cellarray oder Text von carr{icell0}(ipos0) bis carr{icell1}(ipos1),
% 
%
  c = {};
  if( ~exist('type','var') )
    type = 't';
  end
  type = lower(type);
  if( (type(1) ~= 't') || (type(1) ~= 'c') )
    type = 't';
  end
  nc = length(carr);
  if( ~exist('ipos1','var') )
    ipos1 = length(carr{nc});
  end
  if( ~exist('icell1','var') )
    icell1 = nc;
  end
  if( ~exist('ipos0','var') )
    ipos0 = 1;
  end
  if( ~exist('icell0','var') )
    icell0 = 1;
  end
  
  if( icell0 < 1 ), icell0 = 1; end
  if( icell1 > nc ), icell1 = nc; end
  if( icell1 < icell0 ), return; end
  [icell0,ipos0] = cell_get_with_ipos_check(carr,nc,icell0,ipos0);
  [icell1,ipos1] = cell_get_with_ipos_check(carr,nc,icell1,ipos1);
  if( icell1 == icell0 )
    if(ipos1 < ipos0) , return; end
    c{1} = carr{icell0}(ipos0:ipos1);
  else
    ic    = 1;
    c{ic} = carr{icell0}(ipos0:length(carr{icell0}));
    icell = icell0+1;
    while( icell <= icell1 )
      if( icell == icell1 )
        ic = ic+1;
        c{ic} = carr{icell1}(1:ipos1);
      else
        ic = ic + 1;
        c{ic} = carr{icell};
      end
      icell = icell+1;
    end
  end
  if( type(1) == 't' )
    tt = '';
    for ic = 1:length(c)
      tt = [tt,c{ic}];
    end
    c = tt;
  end
end    
function [icell,ipos] = cell_get_with_ipos_check(carr,nc,icell,ipos)
  % Wenn ipos durch aufaddieren größer als die angesprochene Zelle:
  while( ipos > length(carr{icell}) )
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
end
    
    