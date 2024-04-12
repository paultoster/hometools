function out = gps_calc_xyyaw(in)
%
% out = gps_calc_xyyaw(in)
%
% in.long_t        Zeitvektor
% in.long          vector longitudinal coordinate
% in.u_long        unit  longitudinal coordinate
% in.lat           vector lateral coordinate
% in.u_lat         unit  lateral coordinate
% in.head          vector heading  angle
% in.u_head        unit heading  angle
% in.peakfiltfag   0/1  peak filter
% in.filtflag      0/1  filter signal
% in.s_filt        [m]  filter-constant (default 10.0 m )
% in.ds_build      build path with difference ds_build (default 0.1 m ) 
% in.start_lat     Latitudecoordinate zur Skalierung (rad) (default [] =>
%                  Basisstation suchen )
% in.start_long    Longitudecoordinate zur Skalierung (rad)(default [] =>
%                  Basisstation suchen )
% in.head_fac      Factor von Heading zum Gierwinkel
% in.head_offset   Offset von Heading zum Girewinkel
%
% out.xRaw         raw-value x-direction
% out.u_xRaw       unit
% out.yRaw         raw-value x-direction
% out.u_yRaw       unit
% out.yawRaw       raw-value yaw-angle
% out.u_yawRaw     unit
% out.xFilt         filt-value x-direction
% out.u_xFilt       unit
% out.yFilt         filt-value x-direction
% out.u_yFilt       unit
% out.yawFilt       filt-value yaw-angle
% out.u_yawFilt     unit
% out.start_lat     Latitudecoordinate zur Skalierung (rad) 
% out.start_long    Longitudecoordinate zur Skalierung (rad)

  if( ~isfield(in,'long') )
    error('%s_error: vector longitudinal coordinate in.long',mfilename);
  end
  if( ~isfield(in,'u_long') )
    error('%s_error: unit  longitudinal coordinate in.u_long',mfilename);
  end
  if( ~isfield(in,'lat') )
    error('%s_error: vector lateral coordinate in.lat',mfilename);
  end
  if( ~isfield(in,'u_long') )
    error('%s_error: unit  lateral coordinate in.u_lat',mfilename);
  end
  if( ~isfield(in,'head') )
    error('%s_error: vector heading  angle in.head',mfilename);
  end
  if( ~isfield(in,'u_long') )
    error('%s_error: unit  heading  angle in.head',mfilename);
  end
  
  if( ~isfield(in,'peakfiltfag') )
    in.peakfiltfag = 0;
  end
  if( ~isfield(in,'filtflag') )
    in.filtflag = 0;
  end
  if( ~isfield(in,'s_filt') )
    in.s_filt = 10.0;
  end
  if( ~isfield(in,'ds_build') )
    in.ds_build = .1;
  end
  if( ~isfield(in,'start_lat') )
    in.start_lat = [];
  end
  if( ~isfield(in,'start_long') )
    in.start_long = [];
  end
  if( ~isfield(in,'head_fac') )
    in.head_fac = [];
  end
  if( ~isfield(in,'head_offset') )
    in.head_offset = [];
  end
  
  
  
  
  
  
  % peakfilter
  if( in.peakfiltfag )
    a.long  = in.long;
    b.long  = 100/60/180*pi;  % Schwelle zum ausfiltern
    a.lat   = in.lat;
    b.lat   = 100/60/180*pi;  % Schwelle zum ausfiltern
    a.head  = in.head;
    b.head  = 10000;        % auf utopischen Wert lassen
                                 % damit nicht gesucht, aber trotzdem
                                 % mitgefiltert wird
    
    [a,found_flag] = peak_filterA(a,b);                                 

    if( found_flag )
      in.long = a.long;
      in.lat  = a.lat;
      in.head = a.head;
    end
  end
  
  if(  isfield(in,'head_fac') && ~isempty(in.head_fac) ...
    && isfield(in,'head_offset') && ~isempty(in.head_offset) ...
    )
    HeadFac    = in.head_fac;
    HeadOffset = in.head_offset
  else
    if( isfield(in,'typ') )
      if( in.typ(1) == 'V' )
        HeadFac = -1.;
        HeadOffset = pi/2;
      elseif( in.typ(1) == 'R' )
        HeadFac = -1.;
        HeadOffset = pi/2;
      else
      HeadFac = 1.;
      HeadOffset = 0.;
      end
    else
      HeadFac = 1.;
      HeadOffset = 0.;
    end
  end    

  [x,y,phi,b] = LongLatToPos( in.lat, in.u_lat, in.long, in.u_long , in.head , in.u_head, in.start_lat, in.start_long,HeadFac,HeadOffset);
  
  out.start_lat    = b.LatBasisStation;
  out.start_long   = b.LongBasisStation;
  out.tRaw         = in.long_t;
  out.xRaw         = x;
  out.u_xRaw       = 'm';
  out.yRaw         = y;
  out.u_yRaw       = 'm';
  out.yawRaw       = phi;
  out.u_yawRaw     = 'rad';
  
  
  if( in.filtflag )
    [svec,xvec,yvec,ivec] = vek_2d_build_s(x,y,length(x),0.0,0.001);
    time = out.tRaw(ivec);
    nvec = length(svec);
  
    [xmod,ymod,yawmod,errflag] = gps_filt_xy(xvec,yvec,in.ds_build,in.s_filt);
    if( errflag )
      out.tFilt         = out.tRaw;
      out.xFilt         = out.xRaw;
      out.yFilt         = out.yRaw;
      out.yawFilt       = out.yawRaw;
    else
      smod               = vek_2d_build_s(xmod,ymod,length(xmod),0.0,-1.);

      out.tFilt         = interp1(svec,time,smod,'linear','extrap');
      out.xFilt         = xmod;
      out.yFilt         = ymod;
      out.yawFilt       = yawmod;
    end
      
  else
    out.tFilt         = out.tRaw;
    out.xFilt         = out.xRaw;
    out.yFilt         = out.yRaw;
    out.yawFilt       = out.yawRaw;
  end
  out.u_xFilt   = out.u_xRaw;
  out.u_yFilt   = out.u_xRaw;
  out.u_yawFilt = out.u_yawRaw;
end