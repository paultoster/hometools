function p = read_path_data(path_file)
%
% motion control: read fromMCPlanner generated path
  
  p = [];
  fid = fopen(path_file, 'r');
  
  if( fid < 0 )
    p.oaky = 0;
    return
  end
  p.okay = 1;

  p.nsec = fread(fid, 1, 'int32=>double');

  if( p.nsec == 0 )
    p.oaky = 0;
    return
  end
  
  for i=1:p.nsec
    p.secvec(i).n   = fread(fid, 1, 'int32=>double');
    p.secvec(i).ds  = fread(fid, 1, 'float=>double');
    p.secvec(i).dir = fread(fid, 1, 'int8=>double');
    
    p.secvec(i).sRAvec          = zeros(p.secvec(i).n,1);
    p.secvec(i).xRAvec          = zeros(p.secvec(i).n,1);
    p.secvec(i).yRAvec          = zeros(p.secvec(i).n,1);
    p.secvec(i).yawvec          = zeros(p.secvec(i).n,1);
    p.secvec(i).velvec          = zeros(p.secvec(i).n,1);
    p.secvec(i).yawtangensRAvec = zeros(p.secvec(i).n,1);
    p.secvec(i).kappaRAvec      = zeros(p.secvec(i).n,1);
    p.secvec(i).dxdsRAvec       = zeros(p.secvec(i).n,1);
    p.secvec(i).d2xds2RAvec     = zeros(p.secvec(i).n,1);
    p.secvec(i).dydsRAvec       = zeros(p.secvec(i).n,1);
    p.secvec(i).d2yds2RAvec     = zeros(p.secvec(i).n,1);
    p.secvec(i).timevec         = zeros(p.secvec(i).n,1);
    p.secvec(i).frictvec        = zeros(p.secvec(i).n,1);
    p.secvec(i).frictProbvec    = zeros(p.secvec(i).n,1);
    
    
    
    for j=1:p.secvec(i).n
      p.secvec(i).sRAvec(j)          = fread(fid, 1, 'float=>double');
      p.secvec(i).xRAvec(j)          = fread(fid, 1, 'float=>double');
      p.secvec(i).yRAvec(j)          = fread(fid, 1, 'float=>double');
      p.secvec(i).yawvec(j)          = fread(fid, 1, 'float=>double');
      p.secvec(i).velvec(j)          = fread(fid, 1, 'float=>double');
      p.secvec(i).yawtangensRAvec(j) = fread(fid, 1, 'float=>double');
      p.secvec(i).kappaRAvec(j)      = fread(fid, 1, 'float=>double');
      p.secvec(i).dxdsRAvec(j)       = fread(fid, 1, 'float=>double');
      p.secvec(i).d2xds2RAvec(j)     = fread(fid, 1, 'float=>double');
      p.secvec(i).dydsRAvec(j)       = fread(fid, 1, 'float=>double');
      p.secvec(i).d2yds2RAvec(j)     = fread(fid, 1, 'float=>double');
      p.secvec(i).timevec(j)         = -1.;
      p.secvec(i).frictvec(j)        = -1.;
      p.secvec(i).frictProbvec(j)    = -1.;
    end
  end
  
  p.nsum = fread(fid, 1, 'int32=>double');
  p.xRA0 = fread(fid, 1, 'float=>double');
  p.yRA0 = fread(fid, 1, 'float=>double');
  p.yaw0 = fread(fid, 1, 'float=>double');
  p.xRA1 = fread(fid, 1, 'float=>double');
  p.yRA1 = fread(fid, 1, 'float=>double');
  p.yaw1 = fread(fid, 1, 'float=>double');
  p.dir1 = fread(fid, 1, 'int8=>double');
  p.sTotal = fread(fid, 1, 'float=>double');
  p.flagClosedPath = fread(fid, 1, 'uint8=>double');

  config = fread(fid, 1, 'uint8=>uint8');
  
  if( bitand(config,1,'uint8') )
    for i=1:p.nsec
      for j=1:p.secvec(i).n
        p.secvec(i).timevec(j) = fread(fid, 1, 'float=>double');
      end
    end    
  end
  if( bitand(config,2,'uint8') )
    for i=1:p.nsec
      for j=1:p.secvec(i).n
        p.secvec(i).frictvec(j)     = fread(fid, 1, 'float=>double');
        p.secvec(i).frictProbvec(j) = fread(fid, 1, 'float=>double');
      end
    end
  end
  
  fclose(fid);
end
