function [okay,errText] = version_file_write(VersionFileName,s)
%
% [okay,errText] = writeVersionFile(VersionFileName,s)
%
% Write Information from structure s into VersionFile
%
%  s.Comment
%  s.ParLat_Version_Major
%  s.ParLat_Version_Minor
%  s.ParLat_Version_Build
%  s.ParLong_Version_Major
%  s.ParLong_Version_Minor
%  s.ParLong_Version_Build
%
%  It could be that only long or lat Parameter are available

  c = {};
  errText = '';

  %
  % Header Comment
  %

  if( isfield(s,'Comment') )

    for i=1:length(s.Comment)
      
      tt = s.Comment{i};
      
      i0 = str_find_f(str_cut_ae_f(tt,' '),'%','vs');
      if( (i0 == 0) || (i0 > 1) )
        tt = ['% ',tt];
      end
      c = cell_add(c,tt);
    end
    
    c = cell_add(c,'');
    c = cell_add(c,'');
  end
  
  cn = {'ParLat_Version_Major','ParLat_Version_Minor','ParLat_Version_Build'};
  for j=1:length(cn)
    if( isfield(s,cn{j}) )
      c = cell_add(c,sprintf('%s = %i;',cn{j},s.(cn{j})));
    end
  end
  c = cell_add(c,'');
  c = cell_add(c,'');
  cn = {'ParLong_Version_Major','ParLong_Version_Minor','ParLong_Version_Build'};
  for j=1:length(cn)
    if( isfield(s,cn{j}) )
      c = cell_add(c,sprintf('%s = %i;',cn{j},s.(cn{j})));
    end
  end
  
  okay = write_ascii_file(VersionFileName,c);
  
  if( ~okay )
    errText = sprintf('File: %s could not be written',VersionFileName);
  end
  
end