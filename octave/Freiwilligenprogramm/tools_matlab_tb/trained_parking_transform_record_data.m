function record2 = trained_parking_transform_record_data(record,varargin )
%
%  recordA = trained_parking_transform_record_data(record,'type','replace','x0',x0,'y0',y0,'yaw0',yaw0)
% 
%   Take record (e.g. record = trained_parking_read_record_data('tpl_record000.dat'))
%   and trasform x-y to set zero at x0,y0 and turn path into -yaw0
%
%  recordB = trained_parking_transform_record_data(record,'type','set','frict0',frict0)
%  recordB = trained_parking_transform_record_data(record,'type','set','frictProb0',frictProb0)
%
% recordA ======================================================================================================
%
% Take record (e.g. record = trained_parking_read_record_data('tpl_record000.dat'))
% and trasform x-y to set zero at x0,y0 and turn path into -yaw0
%
% recordA ======================================================================================================
%  set constant values right now:
%
%  'frict0',frict0:          record.frictvec(i)     = frict0   i=1:n
%  'frictProb0',frictProb0:  record.frictProbvec(i) = frictProb0   i=1:n
% 
% ==============================================================================================================
%   structure of record:
%   
%   record.okay
%
%   inut from file:
%
%   record.n
%   record.xRAvec
%   record.yRAvec
%   record.dsRAvec
%   record.yawvec
%   record.dirvec
%   record.velvec
%   record.timevec                  set -1 if not read
%   record.frictvec                 set -1 if not read
%   record.frictProbvec             set -1 if not read
%
% extra calculated:
%   
%   record.secvec(i).xRAvec
%   record.secvec(i).yRAvec
%   record.secvec(i).dsRAvec
%   record.secvec(i).yawvec
%   record.secvec(i).dirvec
%   record.secvec(i).velvec
%   record.secvec(i).timevec
%   record.secvec(i).frictvec
%   record.secvec(i).frictProbvec
%   record.secvec(isec).svec 
%   record.secvec(isec).yawtangensvec 
%   record.secvec(isec).kappaRAvec 
%   record.secvec(isec).dxdsRAvec 
%   record.secvec(isec).d2xds2RAvec 
%   record.secvec(isec).dydsRAvec 
%   record.secvec(isec).d2yds2RAvec 

%   xvec_mod =  (xvec-xoffsetsub)*cos(dyaw)+(yvec-yoffsetsub)*sin(dyaw) + xoffsetadd
%   yvec_mod = -(xvec-xoffsetsub)*sin(dyaw)+(yvec-yoffsetsub)*cos(dyaw) + yoffsetadd


  type       = '';
  x0         = 0.0;
  y0         = 0.0;
  yaw0       = 0.0;
  frict0     = 0.0;
  setfrict   = 0;
  frictProb0 = 0.0;
  setfrictProb = 0;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'type'
              type = varargin{i+1};
              if( ~ischar(type) )                
                  error('%s: Wert für Attribut <%s>  ist kein char',mfilename,varargin{i})
              end        
          case 'x0'
              x0   = varargin{i+1};
              if( ~isnumeric(x0) )
                  error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
              end        
          case 'y0'
              y0   = varargin{i+1};
              if( ~isnumeric(y0) )
                  error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
              end        
          case 'yaw0'
              yaw0   = varargin{i+1};
              if( ~isnumeric(yaw0) )
                  error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
              end        
          case 'frict0'
              frict0   = varargin{i+1};
              setfrict = 1;
              if( ~isnumeric(frict0) )
                  error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
              end        
          case 'frictprob0'
              frictProb0   = varargin{i+1};
              setfrictProb = 1;
              if( ~isnumeric(frictProb0) )
                  error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
              end        
          otherwise
              error('%s: Attribut <%s>  nicht okay',mfilename,varargin{i})

      end
      i = i+2;
  end

  if( type(1) == 'r' )  % replace
    fprintf('===>replace recorded path to x0=%f , y0=%f , and turn -yaw0 = %f \n',x0,y0,-yaw0);
    record2 = trained_parking_transform_record_data_replace(record,x0,y0,yaw );
  elseif( type(1) == 'l' )  % set limit
    fprintf('===>kappen recorded path to x0=%f , y0=%f , and turn -yaw0 = %f \n',x0,y0,-yaw0);
    record2 = trained_parking_transform_record_data_limit(record,frict0 );
  elseif( type(1) == 's' )  % set
    fprintf('===>set constant value\n');
    r = record;
    if( setfrict )
      fprintf('===>set friction = %f \n',frict0);
      r = trained_parking_transform_record_data_set_frict0(r,frict0 );
    end
    if( setfrictProb )
      fprintf('===>set frictionProb = %f \n',frictProb0);
      r = trained_parking_transform_record_data_set_frictProb0(r,frictProb0 );
    end
    record2 = r;
  end
  
end
function r = trained_parking_transform_record_data_replace(record,x0,y0,yaw )
  strans.xoffsetsub  = x0;
  strans.yoffsetsub  = y0;
  strans.dyaw        = yaw0;
  strans.xoffsetadd  = 0.0;
  strans.yoffsetadd  = 0.0;

  [xvec,yvec] = vek_2d_transform_strans(record.xRAvec,record.yRAvec,strans);
  [~,dsvec,~] = vek_2d_s_ds_alpha(xvec,yvec);
  
  r = trained_parking_transform_record_data_vec(length(xvec) ...
                                               ,xvec ...
                                               ,yvec ...
                                               ,dsvec ...
                                               ,record.yawvec - strans.dyaw ...
                                               ,record.dirvec ...
                                               ,record.velvec ...
                                               ,record.timevec ...
                                               ,record.frictvec ...
                                               ,record.frictProbvec);
  
end
function r = trained_parking_transform_record_data_set_frict0(record,frict0 )

   r          = record;
   r.frictvec = ones(record.n,1)*frict0;
   r          = read_record_data_section(r,r.n); 
   r.okay     = 1;
end
function r = trained_parking_transform_record_data_limit(record,frict0 )

   r          = record;
   for i=1:r.n
     if( r.frictvec(i) > frict0
      r.frictvec(i) = frict0;
     end
     
   end
   r          = read_record_data_section(r,r.n); 
   r.okay     = 1;
end

function r = trained_parking_transform_record_data_set_frictProb0(record,frictProb0 )
   r              = record;
   r.frictProbvec = ones(record.n,1)*frictProb0;
   r              = read_record_data_section(r,r.n); 
   r.okay         = 1;
end
function   r = trained_parking_transform_record_data_vec(n ...
                                                        ,xvec ...
                                                        ,yvec ...
                                                        ,dsvec ...
                                                        ,yawvec ...
                                                        ,dirvec ...
                                                        ,velvec ...
                                                        ,timevec ...
                                                        ,frictvec ...
                                                        ,frictProbvec)
                                                      
                                                      
  r.n       = n;
  r.xRAvec  = xvec;
  r.yRAvec  = yvec;
  r.dsRAvec = dsvec;
  r.yawvec  = yawvec;
  r.dirvec  = dirvec;
  r.velvec  = velvec;
  r.timevec = timevec;
  r.frictvec = frictvec;
  r.frictProbvec = frictProbvec;
   
  r = read_record_data_section(r,r.n); 
  r.okay    = 1;
                                                      
end
