function s = bezier_length_order4(x0, y0, x1, y1, x2, y2, x3, y3)
%
% s = bezier_length_order4(x0, y0, x1, y1, x2, y2, x3, y3)
%
% Approximated length of bezier curve build with P0,P1,P2,P3
%
% C(t) = (1-t)^3*P0 + 3*t*(1-t)^2*P1 + 3*t^2*(1-t)*P2 + t^3*P3
% t    = 0 ... 1
%
  % s = sqrt(bezier_length_order4_recursive(x0, y0, x1, y1, x2, y2, x3, y3,0));
  n  = 1001;
  dt = 1./(n-1);
  
  [xa,ya] = bezier_order4(x0, y0, x1, y1, x2, y2, x3, y3,0.0,0);
  s       = 0.0;
  for i=1:n-1
    t  = i*dt;
    [xb,yb] = bezier_order4(x0, y0, x1, y1, x2, y2, x3, y3,t,0);
    dx      = xb-xa;
    dy      = yb-ya;
    s       = s + sqrt(dx*dx+dy*dy);
    xa      = xb;
    ya      = yb;
  end
end
function   s = bezier_length_order4_recursive(x0, y0, x1, y1, x2, y2, x3, y3,depth)
  MAX_DEPTH           = 10;
  RELATIVE_TOLLERANCE = 0.001;

  dx  = x3 - x0; 
  dy  = y3 - y0; 
  d1x = x1 - x0; 
  d1y = y1 - y0; 
  d2x = x2 - x3; 
  d2y = y2 - y3; 

  dlenSq = dx*dx + dy*dy; 

  if( dlenSq > 0.0)  
     dist1Sq = distanceFromVectorLineSegmentSquared(d1x, d1y, dx, dy, dlenSq); 
     dist2Sq = distanceFromVectorLineSegmentSquared(d2x, d2y, -dx, -dy, dlenSq); 
  else 
     dist1Sq = 0.0; 
     dist2Sq = 0.0; 
  end
  if ((depth >= 1 && (dist1Sq + dist2Sq) < RELATIVE_TOLLERANCE * dlenSq) || (depth >= MAX_DEPTH)) 
     s = dlenSq; 
  else
     x01 = (x0 + x1) / 2.0; 
     y01 = (y0 + y1) / 2.0; 
     x12 = (x1 + x2) / 2.0; 
     y12 = (y1 + y2) / 2.0; 
     x23 = (x2 + x3) / 2.0; 
     y23 = (y2 + y3) / 2.0; 
   
     x012 = (x01 + x12) / 2.0; 
     y012 = (y01 + y12) / 2.0; 
     x123 = (x12 + x23) / 2.0; 
     y123 = (y12 + y23) / 2.0; 
   
     x0123 = (x012 + x123) / 2.0; 
     y0123 = (y012 + y123) / 2.0; 
   
     s = bezier_length_order4_recursive(x0, y0, x01, y01, x012, y012, x0123, y0123, depth+1) ...
       + bezier_length_order4_recursive(x0123, y0123, x123, y123, x23, y23, x3, y3, depth+1); 
  end 
end
% * Returns the squared distance from a Point <b>p</b> to a line segment 
% * from the origin (0,0) to the endpoint <b>v</b>. 
% * @param px the x coordinate of the point 
% * @param py the y coordinate of the point 
% * @param vx the x component of the direction vector from the line 
% * @param vy the y component of the direction vector from the line 
% * @param vlen2 the squared length of the vector v 
% * @return a double value of the squared distance of p to the line 
function d = distanceFromVectorLineSegmentSquared(px,py,vx,vy, vlen2)  
  dot = vx*px + vy*py; 
  if (dot > 0.0)  
    px = px - vx; 
    py = py - vy; 
    dot = vx*px + vy*py; 
    if (dot > 0.0) 
      d = px*px + py*py; 
    else
      cross = px*vy - py*vx; 
      d = (cross * cross) / vlen2; 
    end
  else 
    d = px*px + py*py; 
  end
end
% https://www.c-plusplus.net/forum/277322-full
% private static final int MAX_DEPTH = 10; 
%  private static final double RELATIVE_TOLLERANCE = 0.001; 
% 
%  public static double approximateArcLength(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3) { 
%      return approximateArcLengthRecursive(x0, y0, x1, y1, x2, y2, x3, y3, 0); 
%  } 
% 
%  private static double approximateArcLengthRecursive(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3, int depth) { 
%      double dx = x3 - x0; 
%      double dy = y3 - y0; 
%      double d1x = x1 - x0; 
%      double d1y = y1 - y0; 
%      double d2x = x2 - x3; 
%      double d2y = y2 - y3; 
% 
%      double dlenSq = dx*dx + dy*dy; 
%      double dist1Sq, dist2Sq; 
%      if (dlenSq > 0.0) { 
%          dist1Sq = distanceFromVectorLineSegmentSquared(d1x, d1y, dx, dy, dlenSq); 
%          dist2Sq = distanceFromVectorLineSegmentSquared(d2x, d2y, -dx, -dy, dlenSq); 
%      } else { 
%          dist1Sq = 0.0; 
%          dist2Sq = 0.0; 
%      } 
% 
%      if ((depth >= 1 && (dist1Sq + dist2Sq) < RELATIVE_TOLLERANCE * dlenSq) || (depth >= MAX_DEPTH)) { 
%          return Math.sqrt(dlenSq); 
%      } 
% 
%      double x01 = (x0 + x1) / 2.0; 
%      double y01 = (y0 + y1) / 2.0; 
%      double x12 = (x1 + x2) / 2.0; 
%      double y12 = (y1 + y2) / 2.0; 
%      double x23 = (x2 + x3) / 2.0; 
%      double y23 = (y2 + y3) / 2.0; 
% 
%      double x012 = (x01 + x12) / 2.0; 
%      double y012 = (y01 + y12) / 2.0; 
%      double x123 = (x12 + x23) / 2.0; 
%      double y123 = (y12 + y23) / 2.0; 
% 
%      double x0123 = (x012 + x123) / 2.0; 
%      double y0123 = (y012 + y123) / 2.0; 
% 
%      return approximateArcLengthRecursive(x0, y0, x01, y01, x012, y012, x0123, y0123, depth+1) 
%           + approximateArcLengthRecursive(x0123, y0123, x123, y123, x23, y23, x3, y3, depth+1); 
%  } 
% 
%  /** 
%   * Returns the squared distance from a Point <b>p</b> to a line segment 
%   * from the origin (0,0) to the endpoint <b>v</b>. 
%   * @param px the x coordinate of the point 
%   * @param py the y coordinate of the point 
%   * @param vx the x component of the direction vector from the line 
%   * @param vy the y component of the direction vector from the line 
%   * @param vlen2 the squared length of the vector v 
%   * @return a double value of the squared distance of p to the line 
%   */ 
%  private static double distanceFromVectorLineSegmentSquared(double px, double py, double vx, double vy, double vlen2) { 
%      double dot = vx*px + vy*py; 
%      if (dot > 0.0) { 
%          px -= vx; 
%          py -= vy; 
%          dot = vx*px + vy*py; 
%          if (dot > 0.0) 
%              return px*px + py*py; 
%          double cross = px*vy - py*vx; 
%          return (cross * cross) / vlen2; 
%      } 
%      return px*px + py*py; 
%  }
     