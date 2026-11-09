function index_liste = index_nicht_monoton(xin,toleranz,steig_flag)
%  
% index_liste = index_nicht_monoton(xin,toleranz,steig_flag)
%
% Sucht nicht monotone Stellen in xin und gibt die Stelle aus
%
% toleranz      Toleranzangabe default: eps
% steig_flag    Steigend oder fallend default steigend steig_flag = 1
%

  n = length(xin);

  if( ~exist('toleranz','var') )
      toleranz = eps;
  else
      toleranz = abs(toleranz);
  end

  if( ~exist('steig_flag','var') )  
      steig_flag = 1;
  end
  index_liste = [];
  for i=2:n

      if( steig_flag )
        if( (xin(i)-xin(i-1)) < toleranz )
          index_liste = [index_liste,i];
        end
      else
        if( (xin(i-1) - xin(i)) < toleranz )
          index_liste = [index_liste,i];
        end
      end
  end
end