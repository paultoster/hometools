function r = trained_parking_build_recording(xvec,yvec,ds,vel0,time_flag)
%
%r = build_recording(xvec,yvec,ds,vel0,time_flag)
%

[s,ds,alpha,x,y] = vek_2d_s_ds_alpha(xvec,yvec,0.0,ds);


r.n            = length(s);
r.xRAvec       = x;
r.yRAvec       = y;
r.dsRAvec      = ds;
r.yawvec       = alpha;
r.dirvec       = s*0.0+1;
r.velvec       = s*0.0+vel0;
r.timevec      = cumsum(ds/vel0);
if( time_flag )
  r.timevec      = r.timevec - r.timevec(1);
else
  r.timevec     = s*0.0-1.;
end
r.frictvec     = s*0.0-1.;
r.frictProbvec = s*0.0-1.;


end