function dist = vek_2d_get_dist_two_points(x0,y0,x1,y1)
%
% dist = vek_2d_length(x0,y0,x1,y1)
%
% dx = x1-x0;
% dy = y1-y0;
% dist = sqrt(dx*dx+dy*dy);

  dx = x1-x0;
  dy = y1-y0;
  dist = sqrt(dx*dx+dy*dy);
end