function s = version_file_read(VersionFileName)

  s.okay = 1;
  s.errText = '';
  s.ParLat_Version_Major = [];
  s.ParLat_Version_Minor = [];
  s.ParLat_Version_Build= [];
  s.ParLong_Version_Major = [];
  s.ParLong_Version_Minor = [];
  s.ParLong_Version_Build= [];
  s.Comment = {};
  
  if( ~exist(VersionFileName,'file') )
    s.okay = 0;
    s.errText = sprintf('No Version File found : <%s> in path: <%s>',VersionFileName,pwd);
    return;
  end
  
  [ s.okay,c,~ ] = read_ascii_file( VersionFileName );
  
  if( ~s.okay )
    s.errText = sprintf('Version File: <%s> in path: <%s> could be read !!!',VersionFileName,pwd);
  end
  
  % Comment
  s.Comment = m_file_get_comment('cellarray',c,'header',1);
  
  [varlist,valuelist] = m_file_get_variables('cellarray',c);
  
  
  %
  % ParLong-Version
  %  
  jcell = cell_find_from_ipos(varlist,1,1,'ParLong_Version_Major','for');
  if( jcell )
    
    s.ParLong_Version_Major =  uint32(str2double(valuelist{jcell}));
  end
    
  jcell = cell_find_from_ipos(varlist,1,1,'ParLong_Version_Minor','for');
  if( jcell )
    
    s.ParLong_Version_Minor =  uint32(str2double(valuelist{jcell}));
  end
  jcell = cell_find_from_ipos(varlist,1,1,'ParLong_Version_Build','for');
  if( jcell )
    
    s.ParLong_Version_Build =  uint32(str2double(valuelist{jcell}));
  end
  %
  % ParLat_Version_-Version
  %  
  jcell = cell_find_from_ipos(varlist,1,1,'ParLat_Version_Major','for');
  if( jcell )
    
    s.ParLat_Version_Major =  uint32(str2double(valuelist{jcell}));
  end
    
  jcell = cell_find_from_ipos(varlist,1,1,'ParLat_Version_Minor','for');
  if( jcell )
    
    s.ParLat_Version_Minor =  uint32(str2double(valuelist{jcell}));
  end
  jcell = cell_find_from_ipos(varlist,1,1,'ParLat_Version_Build','for');
  if( jcell )
    
    s.ParLat_Version_Build =  uint32(str2double(valuelist{jcell}));
  end

end