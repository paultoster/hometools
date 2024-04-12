function youtvec = interpolation(xvec,yvec,xoutvec,lin,extrap,dxout)
%
% youtvec = interpolation(xvec,yvec,xoutvec,lin,extrap,dxout)
%
% xvec,yvec    vector pair to interpolate yvec = f(xvec)
% xoutvec      new x-base
% lin          0/1    constant or linear
% extrap       0/1    no extrapolation or extrapolation
% dxout              value for timeout detecting if not used set -1.
%

  try
    youtvec = mex_interpolation(xvec,yvec,xoutvec,lin,extrap,dxout);
  catch exception
    youtvec = [];
    warning('Warn:interpol','lineare Interpolation mit <%s> gescheitert\n%s',name,getReport(exception)); 
  end


end