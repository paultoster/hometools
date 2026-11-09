function [xvec,yvec,svec] = vek_2d_fit_to_ds(raw_xvec,raw_yvec,raw_svec,fit_ds)
%
% [xvec,yvec,svec] = vek_2d_fit_to_ds(raw_xvec,raw_yvec,raw_svec,fit_ds)
%
% insert points to fit path with distance between points of approximatly fit_ds
%
%
%  raw:   +--------+-----------+--------------+
%  distance should be +--+
%  output:+--+--+--+--+--+--+--+--+--+--+--+--+
%

  n = min(min(length(raw_xvec),length(raw_yvec)),length(raw_svec));

  xvec = raw_xvec(1);
  yvec = raw_yvec(1);
  svec = raw_svec(1);
  
  for i=1:n-1
    
    ds = raw_svec(i+1)-raw_svec(i);
    dx = raw_xvec(i+1)-raw_xvec(i);
    dy = raw_yvec(i+1)-raw_yvec(i);
    
    nn = round(ds/fit_ds);
    dss= ds/nn;
    
    for j=1:nn
      fac = dss*j/ds;
      d   = raw_svec(i) + ds * fac;
      svec = [svec;d];
      d   = raw_xvec(i) + dx * fac;
      xvec = [xvec;d];
      d   = raw_yvec(i) + dy * fac;
      yvec = [yvec;d];
    end
  end
end

