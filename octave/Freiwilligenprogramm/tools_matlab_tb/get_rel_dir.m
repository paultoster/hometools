function [rel_dir,okay,errtext] = get_rel_dir(target_dir,abs_dir)
%
% rel_dir = get_rel_dir(target_dir,abs_dir)
%
% Sucht zum target_dir in Bezug zum abs_dir den relativen Pfad
%
  okay = 1;
  errtext ='';
  rel_dir = '';
  cs = str_split(abs_dir,'\');
  cs = cell_delete_last_if_empty(cs,1);
  ncs = length(cs);
  ct = str_split(target_dir,'\');
  ct = cell_delete_last_if_empty(ct,1);
  nct = length(ct);
  
  if( ~strcmpi(cs{1},ct{1}) )
    errtext = sprintf('Die absoluten Pfade sind auf anderen Laufwerken target_dir:<%s>, abs_dir:<%s>',target_dir,abs_dir);
    okay = 0;
    return;
  end
  
  n = min(ncs,nct);
  
  if( n == 1 )
    rel_dir = '.';
  else
    istart = n;
    for i = 2:n 
      if( ~strcmpi(cs{i},ct{i}) )
        istart = i-1;
        break;
      end
    end
    if(  (istart == n) && (ncs == nct) )
      rel_dir = '.';
    else
      if( ncs > istart )
        rel_dir = '..';
        for i=istart+2:ncs
          rel_dir = [rel_dir,'\..'];
        end
      else
        rel_dir = '.';
      end
      if( nct > istart )
        for i=istart+1:nct
          rel_dir = [rel_dir,'\',ct{i}];
        end
      end
          
    end
  end
end
