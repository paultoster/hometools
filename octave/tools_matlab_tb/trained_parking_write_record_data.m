function okay = trained_parking_write_record_data(r,record_file_name)
%
% okay = trained_parking_write_record_data(r,record_file_name)
%
% 
% r.n            = length(s);
% r.xRAvec       = x;
% r.yRAvec       = y;
% r.dsRAvec      = ds;
% r.yawvec       = alpha;
% r.dirvec       = s*0.0+1;
% r.velvec       = s*0.0+vel0;
% r.timevec      = cumsum(ds/vel0);
% r.timevec      = r.timevec - r.timevec(1);
% r.frictvec     = s*0.0-1.;
% r.frictProbvec = s*0.0-1.;
  okay = 1;
  fid = fopen(record_file_name, 'w');

  if( fid < 0 )
    warning('could not open Binary file :%s',record_file_name);
    okay = 0;
    return
  end

  count =  fwrite(fid, int32(r.n), 'int32');
  

  for i=1:r.n
     count = fwrite(fid, r.xRAvec(i), 'float');
     count = fwrite(fid, r.yRAvec(i), 'float');
     count = fwrite(fid, r.dsRAvec(i), 'float');
     count = fwrite(fid, r.yawvec(i), 'float');
     count = fwrite(fid, int8(r.dirvec(i)), 'int8');
     count = fwrite(fid, r.velvec(i), 'float');
  end
  
  % config ================================================================
  config = uint8(0);
  if( mean(r.timevec) > 0. )
    config = config + uint8(1);
  end
  if( mean(r.frictvec) > 0. )
    config = config + uint8(2);
  end
  
  count = fwrite(fid, config, 'uint8');
  
  if( bitand(config,1,'uint8') )
    for i=1:r.n
      count = fwrite(fid, r.timevec(i), 'float');    
    end
  end
  if( bitand(config,2,'uint8') )
    for i=1:r.n
      count = fwrite(fid, r.frictvec(i), 'float');
      count = fwrite(fid, r.frictProbvec(i), 'float');
    end
  end
  
  
  fclose(fid);

end