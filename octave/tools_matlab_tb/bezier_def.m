function s = bezier_def(xvec,yvec,svec)
%
% s = bezier_def(xvec,yvec)
%
% defines bezier-structure order = min(length(xvec),length(yvec))
% grad is order-1
%
% f.e. xvec = [x0;x1;x2];yvec = [y0;y1;y2];
% order = 3 grad = 2
% => x(t) = (1-t)^2 * x0 + 2*t*(1-t)*x1 + t^2*x2
% => y(t) = (1-t)^2 * y0 + 2*t*(1-t)*y1 + t^2*y2
%
%                       [ 1,-2,1]   [x0]
%    x(t) = [t^2,t,1] * |-2, 2,0| * |x1|
%                       [ 1, 0,0]   [x2]
%
%                           [x0]
%    x(t) = [t^2,t,1] * B * |x1|
%                           [x2]
% ouput:
% s.d            order
% s.B            d x d Basis Matris
% s.BP           d x d Basis Matris
% s.BPP          d x d Basis Matris
% s.xvec = [x0;x1;  ... xgrad]
% s.yvec = [y0;y1;  ... ygrad]
% s.length       approximated length

  ep = 1;
  s.d = min(length(xvec),length(yvec));
  if( s.d < 2 )
    error('Vector length min(length(xvec),length(yvec) < 2');
  end
  
  if( ~exist('svec','var') )
    [svec,~,~]     = vek_2d_s_ds_alpha(xvec,yvec,0.0);
  end
  
  
  s.xvec = zeros(s.d,1);
  s.yvec = zeros(s.d,1);
  for i=0+ep:s.d-1+ep    
    s.xvec(i) = xvec(i);
    s.yvec(i) = yvec(i);  
  end
  
  % approximated length with mean of chord length |Pend-P1| and control net length
  % svec(end)-svec(1)
  dx = xvec(end)-xvec(1);
  dy = yvec(end)-yvec(1);
  s.length = sqrt(dx*dx+dy*dy);
  s.length = s.length + svec(end)-svec(1);
  s.length = not_zero(s.length / 2.);
  
  
  s.B   = zeros(s.d,s.d);
  s.BP  = zeros(s.d,s.d);
  s.BPP = zeros(s.d,s.d);
  for i=0:s.d-1  
    p   = bezier_build_bernsteinpolynom(s.d-1,i);   
    der = polyder(p);
    pp  = [0.,der];
    if( length(der) < 2 )
      ppp = zeros(1.,s.d);
    else
      der = polyder(der);
      ppp = [0.,0.,der];
    end
    
    
    s.B(:,i+ep) = p';
    s.BP(:,i+ep) = pp'/s.length;
    s.BPP(:,i+ep) = ppp'/s.length/s.length;
  end
  