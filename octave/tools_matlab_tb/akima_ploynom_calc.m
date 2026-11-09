function y = akima_ploynom_calc(p,ds,der)
%
% y = akima_ploynom_calc(p,ds,der)
% 
% p wird mit akima_polynom(xvec,yvec,index) generiert
%
% berechnet polynom an der gewünschten Stelle ds
%
% der = 0 Wert an der Stelle (default)
% der = 1 Ableitung an der Stelle
%
%  ds = (x-xvec(index))/(xvec(index+1)-xvec(index))
%  y = p(1)+ds*(p(2)+ds*(p(3)+p(4)*ds));

  if( ~exist('der','var') )
    der = 0;
  end
  if( der == 0 )
    y = p(1)+ds*(p(2)+ds*(p(3)+p(4)*ds));
  else
    y = p(2)+ds*(2.0*p(3)+3.0*p(4)*ds);
  end

end