function [c,okay] = read_nvectors_binary_file(file_name)
%
% [c,okay] = read_nvectors_binary_file(file_name)
%
% read vectors/matrix from binary-file
%
% c   cellary contains a numeric array/vecotr or singler value
%
% f.e. c = {2.3,[1;2;3;4;5;6],[1,2,3;11,12,13;21,22,23]}

  okay = 1;
  c    = {};
  fid = fopen(file_name, 'r');
  
  if( fid < 0 )
    error('could not open Binary file :%s',file_name);
  end
  
  readFinished = 1;
  while(readFinished)
  
    try
      readFinished = 0;
      ni = fread(fid, 1, 'uint32=>double');
      if( isempty(ni) )
        break;
      end
      mi = fread(fid, 1, 'uint32=>double');
      if( isempty(mi) )
        break;
      end

      vek = zeros(ni,mi);

      for i=1:ni
        for j=1:mi
          vek(i,j) = fread(fid, 1, 'double');
        end
      end
      readFinished = 1;
    catch
      readFinished = 0;
    end
    if( readFinished )
      c = cell_add(c,vek);
    end
  end
  fclose(fid);
end