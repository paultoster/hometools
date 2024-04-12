function [dd,uu,cc]=d_data_elim_vector_w_name(cenames,d,u,c)
%
% [dd,uu,cc]=d_data_elim_vector_w_name(cenames,d,u,c)
% Eleminiert Signale mit Namen, die cenames{i} enthält
%
  if( length(d) > 1 )
    error('Struktur d soll kein array sein, sonst nicht gut zu bereinigen')
  end
  if( exist('c','var') && ~isempty(c) )
    cflag = 1;
  else
    cflag = 0;
  end
  if( exist('u','var') && ~isempty(u) )
    uflag = 1;
  else
    uflag = 0;
  end
  if( ischar(cenames) )
    cenames = {cenames};
  end
  csnames = fieldnames(d);
  dd = [];
  uu = [];
  cc = [];
  for i = 1:length(csnames)
    flag = 1;
    for j = 1:length(cenames)
      if( str_find_f(csnames{i},cenames{j},'vs') > 0 )
        flag = 0;
      end
    end
    if( flag )
      dd.(csnames{i}) = d.(csnames{i});
      if( uflag )
        if( isfield(u,csnames{i}) )
          uu.(csnames{i}) = u.(csnames{i});
        else
          uu.(csnames{i}) = '';
        end
      end
      if( cflag )
        if( isfield(c,csnames{i}) )
          cc.(csnames{i}) = c.(csnames{i});
        else
          cc.(csnames{i}) = '';
        end
      end
    end
  end
end