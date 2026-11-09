function newfilename = get_new_filename_by_count(fdir,schablone)
%
% newfilename = get_new_filename_by_count(fdir,schablone)
% e.g.
% newfilename = get_new_filename_by_count('D:\temp','SimModellFallback_GMV_*_e.mat')
%
% =>  newfilename = 'D:\temp\SimModellFallback_GMV_000_e.mat' if not exist,
% otherwise count up SimModellFallback_GMV_001_e - SimModellFallback_GMV_999_e
%

  s_file = str_get_pfe_f(schablone);
  
  ifound = str_find_f(s_file.body,'*','vs');
  
  if( ifound )
    bodynew = get_new_filename_ifound(ifound,s_file,fdir);
  else
    bodynew = get_new_filename_inotfound(s_file,fdir);
  end
  
  newfilename = fullfile(fdir,[bodynew,'.',s_file.ext]);
end
function bodynew = get_new_filename_ifound(ifound,s_file,fdir)   
  if( ifound == 1 )
    body0 = '';
  else
    body0 = s_file.body(1:ifound-1);
  end
  if( ifound ==  length(s_file.body) )
    body1 = '';
  else
    body1 = s_file.body(ifound+1:end);
  end

  if( ~isempty(body0) || ~isempty(body1) )

    if( ~isempty(body0) )
      s_files = suche_files_body(fdir,body0,-1,0);
      if( ~isempty(body1) )
        is_files1 = 0;
        s_files1 = struct([]);
        for i=1:length(s_files)
          i0 = str_find_f(s_files(i).body,body1,'v');
          if( (length(s_files(i).body)-i0+1) == length(body1) )
            is_files1 = is_files1 + 1;
            if( is_files1 == 1 )
              s_files1 = s_files(i);
            else
              s_files1(is_files1) = s_files(i);
            end
          end
        end          
        s_files = s_files1;
      end
    else % isempty(body0) && ~isempty(body1)
      s_files = suche_files_body(fdir,body1,-2,0);
    end
  else
    s_files = struct([]);
  end

  inew = 0;
  if( isempty(s_files) )
    inew = 0;
  else
    cc = {};
    for i=1:length(s_files)

      tt = s_files(i).body(ifound:end);
      i0 = str_find_f(tt,body1,'v');
      if( i0 )
        tt = tt(1:i0-1);
      end

      cc = cell_add(cc,tt);
    end
    for i=0:999
      tt = sprintf('%3.3i',i);
      if( isempty(cell_find_f(cc,tt,'f')) )
        inew = i;
        break;
      end
    end
  end
  bodynew = sprintf('%s%3.3i%s',body0,inew,body1);   
end
function bodynew = get_new_filename_inotfound(s_file,fdir)   
  s_files = suche_files_body(fdir,s_file.body,-1,0);
  nbody = length(s_file.body);
  inew = 0;
  if( isempty(s_files) )
    inew = 0;
  else
    cc = {};
    for i=1:length(s_files)
      n = length(s_files(i).body);
      if( n > nbody )        
        tt = s_files(i).body(nbody+1:end);
        cc = cell_add(cc,tt);
      end
    end
    for i=1:999
      tt = sprintf('%3.3i',i);
      if( isempty(cell_find_f(cc,tt,'f')) )
        inew = i;
        break;
      end
    end
  end
  bodynew = sprintf('%s%3.3i',s_file.body,inew);   
end