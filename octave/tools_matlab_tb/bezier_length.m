function l = bezier_length(s,n)
%
% l = bezier_length(s)
%
% approximation of bezier curve defined in s-structure
%
% input:
%
% s              bezier structure
%                s.d            order
%                s.B            d x d Basis Matris
%                s.dB           d x d Basis Matris
%                s.ddB          d x d Basis Matris
%                s.xvec = [x0;x1;  ... xgrad]
%                s.yvec = [y0;y1;  ... ygrad]
% n              number of segments to devide
%
% ouput:
% l              estimated length of bezier curve from t = 0.0 ... 1.0
  n  = max(2,n);
  dt = 1./(n-1.);

  l  = 0.0;
  l2 = 0.0;
  ti = 0.0;
  [fi,xi,yi] = bezier_length_f(s,ti);
  for i=1:n-1
    %ti              = (i-1)*dt;
    tii              = i*dt;
    [fii,xii,yii]    = bezier_length_f(s,tii);
    ti2              = (ti+tii)/2.;
    [fi2,~,~]        = bezier_length_f(s,ti2);
    
    li = dt/6. * (fi + 4.*fi2+fii);
    l  = l + li;
    
    dx = xii-xi;
    dy = yii-yi;
    l2 = l2 + sqrt(dx*dx+dy*dy);
    
    ti = tii;
    fi = fii;
    xi = xii;
    yi = yii;
  end
  
  %fprintf('l=%f,l2=%f,l-l2=%f\n',l,l,l-l2);
  
end 
function [fi,x,y] = bezier_length_f(s,ti)

 [x,y,xp,yp,~,~] = bezier_calc(s,ti);

 fi = sqrt(xp*xp+yp*yp);

end