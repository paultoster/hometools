function [dspath,dxpath,dypath] = vek_2d_build_ds(spath,xpath,ypath,n)
%
% [dspath]               = vek_2d_build_ds(spath)
% [dspath,dxpath,dypath] = vek_2d_build_ds(spath,[xpath,ypath,n])
% 
% Bildet Differenz Weg x un y 
% (default: n = min(length(xpath),length(ypath),length(spath)))
%
  if( exist('xpath','var') )
    flagx = 1;
  else
    flagx = 0;
  end
  if( exist('ypath','var') )
    flagy = 1;
  else
    flagy = 0;
  end
  if( ~exist('n','var') )
    n = length(spath);
    if( flagx)
      n = min(n,length(xpath));
    end
    if( flagy)
      n = min(n,length(ypath));
    end
  end
  dspath = zeros(n,1);
  dxpath = zeros(n,1);
  dypath = zeros(n,1);
  
  for i = 1:n-1
    dspath(i) = spath(i+1)-spath(i);
  end
  dspath(n)    = dspath(n-1);
  if( flagx )
    for i = 1:n-1
      dxpath(i) = xpath(i+1)-xpath(i);    
    end
    dxpath(n)    = dxpath(n-1);
  end
  if( flagy )
    for i = 1:n-1
      dypath(i) = ypath(i+1)-ypath(i);
    end
    dypath(n)    = dypath(n-1);
  end
  
  
  
end

