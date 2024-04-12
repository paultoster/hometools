function yaw = reduce_angle_2pi(yaw)
%
% yaw = reduce_angle_2pi(yaw)
%
% reduziert 2*pi Vielfaches
%
  [n,m] = size(yaw);

  for i=1:n
    for j=1:m
      while( yaw(i,j) > 2*pi )
        yaw(i,j) = yaw(i,j) - 2*pi;
      end
      while( yaw(i,j) < -2*pi )
        yaw(i,j) = yaw(i,j) + 2*pi;
      end
    end
  end
end
