function kappa_vec = path_calc_kappa_vec(alpha_vec,ds_vec,TypeOfCurvePreCalc)
%
% kappa_vec = path_calc_kappa_vec(alpha_vec,ds_vec,TypeOfCurvePreCalc)
%
% Calculation of curvature with alpha(i) und ds(i) i = 1:n-1
%
% TypeOfCurvePreCalc = 0   :   curvature at knot (default 0 )
% TypeOfCurvePreCalc = 1   :   curvature between knot
%
% alpha_vec            Steigung entlang der Bahn 
%                      alpha(i) = atan((y(i+1)-y(i))/(x(i+1)-x(i)))
% ds_vec               Streckendifferenz 
%                      ds(i)    = s(i+1) - s(i)
% 
% kappa_vec            curvature at knot mit kappa(n) = 0
%

  if( ~exist('TypeOfCurvePreCalc','var') )
    TypeOfCurvePreCalc = 0;
  end

  % in case of cell array with vektors
  if( iscell(alpha_vec) && iscell(ds_vec) )
    
    n = min(length(alpha_vec),length(ds_vec));
    kappa_vec = cell(1,n);
    
    for i=1:n
      
      if( isempty(alpha_vec{i}) || isempty(ds_vec{i}) )
        kappa =  [];
      else
        m = min(length(alpha_vec{i}),length(ds_vec{i}));
        kappa = path_calc_kappa(alpha_vec{i},ds_vec{i},m,TypeOfCurvePreCalc);
      end
      kappa_vec{i} = kappa;
    end
  % in case of vector
  else
    m = min(length(alpha_vec),length(ds_vec));
    kappa_vec = path_calc_kappa(alpha_vec,ds_vec,m,TypeOfCurvePreCalc);
  end
end
