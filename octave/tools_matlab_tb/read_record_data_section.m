function   r = read_record_data_section(r,n)
%
% r = read_record_data_section(r,n)
% build section
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
%
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