function okay = write_nvectors_binary_file(c,file_name)
%
% okay = write_nvectors_binary_file(c)
%
% write vectors/matrix into binary-file
%
% c   cellary contains a numeric array/vecotr or singler value
%
% f.e. c = {2.3,[1;2;3;4;5;6],[1,2,3;11,12,13;21,22,23]}

  n = length(c);
  ci_liste = {};
  for i=1:n
    if( isnumeric(c{i}) )
      [ni,mi] = size(c{i});
      iliste = [i,ni,mi];
      ci_liste = cell_add(ci_liste,iliste);
    end
  end
  if( ~isempty(ci_liste) )
    okay = 1;
    fid = fopen(file_name, 'w');
  
    if( fid < 0 )
      error('could not open Binary file :%s',file_name);
    end

    for ilist=1:length(ci_liste)
      
      icell = ci_liste{ilist}(1);
      ni    = ci_liste{ilist}(2);
      mi    = ci_liste{ilist}(3);
      
      fwrite(fid, ni, 'uint32');
      fwrite(fid, mi, 'uint32');

      for i=1:ni
        for j=1:mi
          fwrite(fid, c{icell}(i,j), 'double');
        end
      end
    end
    
    fclose(fid);
  else
    okay = 0;
  end
    
end
