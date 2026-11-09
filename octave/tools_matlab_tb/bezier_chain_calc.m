function [xvec,yvec,yawvec,curvevec] = bezier_chain_calc(s_chain,svec)
%
%  [xvec,yvec]                 = bezier_chain_calc(s_chain,svec)
%  [xvec,yvec,yawvec]          = bezier_chain_calc(s_chain,svec)
%  [xvec,yvec,yawvec,curvevey] = bezier_chain_calc(s_chain,svec)
%
%  calculate with vector svec distance along bezier all points
%
%
%  input:
%
%  s_chain             definition of a  bezier chain 
%                       s_chain.s(i)        ith bezier definition
%                       s_chain.n           number of beziers
%                       s_chani.slen(i)     slen(i) is start of s(i) and slen(i+1) is end of
%                                           s(i) => length(slen) = n+1
%  svec                distance vektor with points on bezier svec(i) >= 0.
%  
%  output:
%
%  xvec,yvec           vector points
%  yawvec              yaw angle
%  curvevec            curvature


  n        = length(svec);
  xvec     = zeros(n,1);
  yvec     = zeros(n,1);
  yawvec   = zeros(n,1);
  curvevec = zeros(n,1);
  ns       = length(s_chain.s);
  for i=1:n
    rindex              = suche_index(s_chain.slen,svec(i),'===');
    index               = floor(rindex);
    t                   = rindex - index;
    while( index > ns )
      index = index -1;
      t     = t + 1.;
    end
    [x,y,xp,yp,xpp,ypp] = bezier_calc(s_chain.s(index),t);
    xvec(i)             = x;
    yvec(i)             = y;
    yawvec(i)           = atan2(yp,xp);
    curvevec(i)         = path_calc_kappa_from_derivations(xp,xpp,yp,ypp);
  end
end
