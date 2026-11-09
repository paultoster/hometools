function ds_lat = path_calc_lateral_deviation(xpath,ypath,yawpath,xego,yego)
%
% ds_lat = path_calc_lateral_deviation(xpath,ypath,yawpath,xego,yego)
%
%
% Calculation of deviation from ego to path, normale beta = yaw+90
%
  n = min(length(xpath),length(ypath));
  n = min(n,length(yawpath));
  n = min(n,length(xego));
  n = min(n,length(yego));
  ds_lat = zeros(n,1);
  % lateral deviation
  for i=1:n
   
   dx = xpath(i)-xego(i);
   dy = ypath(i)-yego(i);
   
   ds_lat(i) = dy * cos(yawpath(i)) - dx * sin(yawpath(i));
  end
end
