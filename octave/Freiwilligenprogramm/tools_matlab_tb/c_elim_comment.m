function [c,n]      = c_elim_comment(cin,nin)
%
% [c,n]      = elim_c_comment(cin,nin)
%
% eleminiert C-Code Kommentar in c{i} i=1:n
%
  c = {]
  n = 0;
  if( ~exist('nin','var') )
    nin = length(cin);
  end
  % //-Kommentar
  for i=1:nin
    tt = cin{i};
    i0 = str_find_f(tt,'//','vs');
    if( i0 == 1 )
    elseif( i0 > 0 )
      c = cell_add(c,tt(1:i0-1);
    end
  end

  such_flag = 1;
  while( such_flag )
    [jcell,jpos] = cell_find_from_ipos(c,1,1,'/*');
    if( jcell )
      [kcell,kpos] = cell_find_from_ipos(c,jcell,jpos+1,'*/');
      if( kcell == 0 )
        kcell = length(c);
        kpos  = length(c{kcell});
      else
        c = cell_elim_with_ipos(c,jcell,jpos,kcell,kpos);
      end
    else
      such_flag = 0;
    end
  end
end
      