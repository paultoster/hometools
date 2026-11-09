function [x,y,xp,yp,xpp,ypp] = bezier_calc(s,t)
%
% [x,y,xp,yp,xpp,ypp] = bezier_calc(s,t)
%
% Calculation Bezier define by s = bezier_def() 
% at t = [0.0 ... 1.0]
% 
% input
% s              outputstruture from bezier_def
% t              undimension value 0 <= t <= 1
%
% ouput:
% x              x-value
% y              y-value
% xp             derivation dx/dt
% yp             derivation dy/dt
% xpp            2nd derivation d2x/dt2
% ypp            2nd derivation d2y/dt2

  tvec = ones(1,s.d);
  for i= s.d-1:-1:1
    tvec(i) = tvec(i+1) * t;
  end
  x   = tvec * s.B   * s.xvec;
  y   = tvec * s.B   * s.yvec;
  xp  = tvec * s.BP  * s.xvec;
  yp  = tvec * s.BP  * s.yvec;
  xpp = tvec * s.BPP * s.xvec;
  ypp = tvec * s.BPP * s.yvec;
end  