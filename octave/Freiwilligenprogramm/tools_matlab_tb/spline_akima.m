function [yout,ypout] = spline_akima( xin,yin,xout )
%
%   yout = spline_akima( xin,yin,xout )
%
  if( ~is_monoton_steigend(xin) )
    error('spline_akima: xin ist nicht monoton steigend')
  end
  if( ~is_monoton_steigend(xout) )
    error('spline_akima: xout ist nicht monoton steigend')
  end
  
  dxin = diff(xin);
  dxin(length(dxin)+1) = 0.0;
  
  yout = xout * 0.0;
  ypout = xout * 0.0;
  index = 0;
  for i=1:length(xout)
    
    wert = suche_index(xin,xout(i),'===','v',0.0001,index);
    index = max(1,floor(wert));
    ds    = wert-floor(wert);
    
    pol = akima_polynom(xin,yin,index);
    yout(i)  = akima_ploynom_calc(pol,ds,0);
    ypout(i) = akima_ploynom_calc(pol,ds,1);
    
  end


end

