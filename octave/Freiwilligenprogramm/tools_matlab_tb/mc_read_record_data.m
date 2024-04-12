function r = mc_read_record_data(record_file)
%
%   r = mc_read_record_data(record_file)
%
% motion control: read fromMCPlanner generated record
%   r.okay
%   r.xRAvec
%   r.yRAvec
%   r.dsRAvec
%   r.yawvec
%   r.dirvec
%   r.velvec
%   r.timevec                  set -1 if not read
%   r.frictvec                 set -1 if not read
%   r.frictProbvec             set -1 if not read
%
%   r.secvec(i).xRAvec
%   r.secvec(i).yRAvec
%   r.secvec(i).dsRAvec
%   r.secvec(i).yawvec
%   r.secvec(i).dirvec
%   r.secvec(i).velvec
%   r.secvec(i).timevec
%   r.secvec(i).frictvec
%   r.secvec(i).frictProbvec
%   r.secvec(isec).svec 
%   r.secvec(isec).yawtangensvec 
%   r.secvec(isec).kappaRAvec 
%   r.secvec(isec).dxdsRAvec 
%   r.secvec(isec).d2xds2RAvec 
%   r.secvec(isec).dydsRAvec 
%   r.secvec(isec).d2yds2RAvec 

  r = [];
  r.okay = 1;
  
  if( ~exist(record_file,'file') )    
    error('Datei: <%s> existiert nicht!!!',record_file)
  end
  fid = fopen(record_file, 'r');
  
  if( fid < 0 )
    error('could not open RecordFile :%s',record_file);
  end

  n = fread(fid, 1, 'int32=>double');

  if( n == 0 )
    error('recordFile: %s \nn = 0 !!!',record_file);
  end

  r.xRAvec = zeros(n,1);
  r.yRAvec = zeros(n,1);
  r.dsRAvec = zeros(n,1);
  r.yawvec = zeros(n,1);
  r.dirvec = zeros(n,1);
  r.velvec = zeros(n,1);
  r.timevec = zeros(n,1);
  r.frictvec     = zeros(n,1);
  r.frictProbvec = zeros(n,1);
  
  for i=1:n
    r.xRAvec(i) = fread(fid, 1, 'float=>double');
    r.yRAvec(i) = fread(fid, 1, 'float=>double');
    r.dsRAvec(i) = fread(fid, 1, 'float=>double');
    r.yawvec(i) = fread(fid, 1, 'float=>double');
    r.dirvec(i) = fread(fid, 1, 'int8=>double');
    r.velvec(i) = fread(fid, 1, 'float=>double');
    r.timevec(i) = -1.;
    r.frictvec(i) = -1.;
    r.frictProbvec(i) = -1.;
  end
  
  config = fread(fid, 1, 'uint8=>uint8');
  
  if( bitand(config,1,'uint8') )
    r.timevec = zeros(n,1);
    for i=1:n
      r.timevec(i) = fread(fid, 1, 'float=>double');    
    end
  end
  if( bitand(config,2,'uint8') )
    r.frictvec     = zeros(n,1);
    r.frictProbvec = zeros(n,1);
    for i=1:n
      r.frictvec(i)     = fread(fid, 1, 'float=>double');
      r.frictProbvec(i) = fread(fid, 1, 'float=>double');
    end
  end
  
  fclose(fid);

  isec   = 1;
  dir0   = r.dirvec(1);
  icount = 0;
  
  for i=1:n
    if( r.dirvec(i) == dir0 )
      icount = icount +1 ;
    else
      isec   = isec + 1;
      icount = 1;
    end
    if( icount == 1)
      r.secvec(isec).xRAvec         = r.xRAvec(i);       
      r.secvec(isec).yRAvec         = r.yRAvec(i);
      r.secvec(isec).dsRAvec        = r.dsRAvec(i);
      r.secvec(isec).yawvec         = r.yawvec(i);
      r.secvec(isec).dirvec         = r.dirvec(i);
      r.secvec(isec).velvec         = r.velvec(i);
      r.secvec(isec).timevec        = r.timevec(i);
      r.secvec(isec).frictvec       = r.frictvec(i);
      r.secvec(isec).frictProbvec   = r.frictProbvec(i);
    else
      r.secvec(isec).xRAvec           = [r.secvec(isec).xRAvec;   r.xRAvec(i)];       
      r.secvec(isec).yRAvec           = [r.secvec(isec).yRAvec;   r.yRAvec(i)];
      r.secvec(isec).dsRAvec          = [r.secvec(isec).dsRAvec;  r.dsRAvec(i)];
      r.secvec(isec).yawvec         = [r.secvec(isec).yawvec; r.yawvec(i)];
      r.secvec(isec).dirvec         = [r.secvec(isec).dirvec; r.dirvec(i)];
      r.secvec(isec).velvec         = [r.secvec(isec).velvec; r.velvec(i)];
      r.secvec(isec).timevec        = [r.secvec(isec).timevec; r.timevec(i)];
      r.secvec(isec).frictvec       = [r.secvec(isec).frictvec; r.frictvec(i)];
      r.secvec(isec).frictProbvec   = [r.secvec(isec).frictProbvec; r.frictProbvec(i)];
    end
    
    r.nsec = length(r.secvec);
  end
  for isec=1:r.nsec

    [~ ...
    ,~ ...
    ,r.secvec(isec).svec ...
    ,r.secvec(isec).yawtangensvec ...
    ,r.secvec(isec).kappaRAvec ...
    ,r.secvec(isec).dxdsRAvec ...
    ,r.secvec(isec).d2xds2RAvec ...
    ,r.secvec(isec).dydsRAvec ...
    ,r.secvec(isec).d2yds2RAvec ...
    ] = vek_2d_path_calc(r.secvec(isec).xRAvec,r.secvec(isec).yRAvec,'iord',7);
  
    [~,r.secvec(isec).dsRAvec,~] = vek_2d_s_ds_alpha(r.secvec(isec).xRAvec,r.secvec(isec).yRAvec);

  end
    
end
