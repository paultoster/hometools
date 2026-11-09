function [xvecm,yvecm,errmax,errmean,errstd] = GemittelteAbweichung(xvec,yvec)
%
% [xvecm,yvecm,errmax,errmean,errstd] = GemittelteAbweichung(xvec,yvec)
%
%   n = min(length(xvec),length(yvec));
%   xvec = xvec(1:n);
%   yvec = yvec(1:n);
% 
% 
%   xmean = mean(xvec);
%   ymean = mean(yvec);
%   xvecm = xvec - xmean;
%   yvecm = yvec - ymean;
% 
%   dxvec = (xvec-xmean);
%   dyvec = (yvec-ymean);
%   errvec = sqrt(dxvec.*dxvec + dyvec.*dyvec );
% 
%   errmax  = max(errvec);
%   errmean = mean(errvec);
%   errstd  = std(errvec);

  n = min(length(xvec),length(yvec));
  xvec = xvec(1:n);
  yvec = yvec(1:n);


  xmean = mean(xvec);
  ymean = mean(yvec);
  xvecm = xvec - xmean;
  yvecm = yvec - ymean;

  dxvec = (xvec-xmean);
  dyvec = (yvec-ymean);
  errvec = sqrt(dxvec.*dxvec + dyvec.*dyvec );

  errmax  = max(errvec);
  errmean = mean(errvec);
  errstd  = std(errvec);
end