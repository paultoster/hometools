function [xivec,yivec,alphaivec,dPathVec,indexVec,devlatVec] = vek_2d_intersection_vec(xvec,yvec,xsearchvec,ysearchvec,alphasearchvec,typ,nearest)
%
% [xivec,yivec,alphaivec,dPathVec,indexVec] = vek_2d_intersection_vec(xvec,yvec,xsearchvec,ysearchvec,alphasearchvec,typ)
% [xivec,yivec,alphaivec,dPathVec,indexVec] = vek_2d_intersection_vec(xvec,yvec,xsearchvec,ysearchvec,alphasearchvec,typ,nearest)
%
% [xivec,yivec,alphaivec,dPathVec,indexVec,devlatVec] = vek_2d_intersection_vec(xvec,yvec,xsearchvec,ysearchvec,alphasearchvec,typ)
% [xivec,yivec,alphaivec,dPathVec,indexVec,devlatVec] = vek_2d_intersection_vec(xvec,yvec,xsearchvec,ysearchvec,alphasearchvec,typ,nearest)
%
% Calc Intersection-Point of vector xsearchvec,xsearchvec,alphasearchvec on xvec,yvec
%
% xvec,yvec                             Vektor with 2d-coordinates of Trajectory
% xsearchvec,ysearchvec,alphasearchvec  actual point (Odometrie)
% typ                                  (default: 1)
%                                      0: rectangle to direction alphasearchvec 
%                                      1: rectangle t0 xvec,yvec
%
% xivec,yivec      Point og interection on xvec,yvec linear
% alphaivec        direction of vector xvec,yvec
% dPathVec         portion of intersection defined to s(i+1)-s(i)
% indexVec         index of intersection i
% devlatVec        perpendicular deviation (typ=1) to alpha of trajectory
%                  or (typ=0) to yaw of vehicle
% nearest          search first nearest point   

  if( ~exist('typ','var') )
    typ = 1;
  end
  if( ~exist('nearest','var') )
    nearest = 0;
  end
  
  if( nargout == 6 )
    flagdevlat = 1;
  else
    flagdevlat = 0;
  end
  
  iact = 1;
  n    = min(length(xsearchvec),length(ysearchvec));
  if( typ == 0 )
    n    = min(n,length(alphasearchvec));
  end
  
  xivec     = zeros(n,1);
  yivec     = zeros(n,1);
  dPathVec  = zeros(n,1);
  alphaivec = zeros(n,1);
  indexVec  = zeros(n,1);
  
  if( flagdevlat )
    devlatVec = zeros(n,1);
  end
  
  if( typ == 0 )
    for i=1:n
      
      if( nearest )
        iact = vek_2d_nearest_point(xvec,yvec,xsearchvec(i),ysearchvec(i));
      end
      
      [xivec(i),yivec(i),dPathVec(i),alphaivec(i),iact]    = vek_2d_intersection(xvec,yvec ...
                                                               ,xsearchvec(i) ...
                                                               ,ysearchvec(i) ....
                                                               ,alphasearchvec(i) ...
                                                               ,typ,iact);
      indexVec(i) = iact;
      
      if( flagdevlat )
       devlatVec(i) = vek_2d_intersection_vec_devlat(xivec(i)-xsearchvec(i),yivec(i)-ysearchvec(i),alphasearchvec(i));
      end

    end
  else
    for i=1:n

      if( nearest )
        iact = vek_2d_nearest_point(xvec,yvec,xsearchvec(i),ysearchvec(i));
      end
      [xivec(i),yivec(i),dPathVec(i),alphaivec(i),iact]    = vek_2d_intersection(xvec,yvec ...
                                                               ,xsearchvec(i) ...
                                                               ,ysearchvec(i) ....
                                                               ,0.0 ...
                                                               ,typ,iact);
      indexVec(i) = iact;
      if( flagdevlat )
       devlatVec(i) = vek_2d_intersection_vec_devlat(xivec(i)-xsearchvec(i),yivec(i)-ysearchvec(i),alphaivec(i));
      end
    end
  end
end
function devlat = vek_2d_intersection_vec_devlat(dx,dy,alpha)
%
%
%
%    alpha = 0     +----->    direction alpha
%                             dx0 = cos(alpha) = 1.0 
%                             dy0 = sin(alpha) = 0.0
%
%                  ^
%                  |
%                  |
%    perpendicular +          dx0 = -sin(alpha) = 0.0
%                             dy0 = cos(alpha)  = 1.0
%
%   
  dx0 = -sin(alpha);
  dy0 = cos(alpha);
  
  devlat = dx*dx0 + dy*dy0;
  
end