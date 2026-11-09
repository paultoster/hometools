function [c,n]      = m_file_elim_comment(cin,nin)
%
% [c,n]      = m_file_elim_comment(cin,nin)
%
% eleminiert Kommentar in c{i} i=1:n
%
  c = {};
  n = 0;
  if( ~exist('nin','var') )
    nin = length(cin);
  end
  % %-Kommentar
  for i=1:nin
    tt = cin{i};
    i0 = str_find_f(tt,'%','vs');
    if( i0 == 1 )
    elseif( i0 > 1 )
      c = cell_add(c,tt(1:i0-1));
      n = n+1;
    else
      c = cell_add(c,tt);
      n = n+1;
    end
  end
end
      