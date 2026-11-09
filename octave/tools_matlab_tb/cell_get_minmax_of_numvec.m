function [vmin,vmax,okay] = cell_get_minmax_of_numvec(carray,i0,i1)
%
% [vmin,vmax,okay] = cell_get_minmax_of_numvec(carray)
% [vmin,vmax,okay] = cell_get_minmax_of_numvec(carray,i0,i1)
%
% Sucht in einem cellarray carray nach min und max Wert, wenn numerischen Vektor
% i0            start Index
% i1            end Index
%
% vmin          minimaler Wert ([]  wenn kein vektor)
% vmax          maximaler Wert ([]  wenn kein vektor)
% okay          0: keine numerischer vektor
%               1: Werte gefunden

  vmin   = 1/eps;
  vmax   = -eps;
  okay   = 0;
  
  ii0    = 1;
  ii1    = length(carray);
  
  if( ~exist('i0','var') )
    i0 = ii0;
  else
    i0 = max(i0,ii0);
  end
  if( ~exist('i1','var') )
    i1 = ii1;
  else
    i1 = max(i1,ii1);
  end
  
  for i=i0:i1
    
    if( isnumeric(carray{i}) )
      
      vmax = max(max(carray{i}),vmax);
      vmin = min(min(carray{i}),vmin);
      okay = 1;
    end
       
  end
  
  if( ~okay )
    vmin = [];
    vmax = [];
  end
end