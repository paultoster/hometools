function [xvecout,yvecout] = vek_2d_transform_shift_razvan(xvec,yvec,xoffset,yoffset,cyaw,syaw,index)
%
%  [xvecout,yvecout] = vek_2d_transform_shift(xvec,yvec,xoffset,yoffset,cyaw,syaw,index)
%
% @brief shift and transform x-y-vector with rotation about index 
% 
% shift and transform x-y-vector
% xvec,yvec        Vector to shift and turn
% xoffset,yoffset  Offset for turning point
% cyaw,syaw        cosinus and sinus of yaw angle
% true:            turn positive around xoffset,yoffset
% 


  n = min(length(xvec),length(yvec));
  
  xvecout = zeros(n,1);
  yvecout = zeros(n,1);
    
	for ii = 1:n
    
		xvec(ii) = xvec(ii) + xoffset;
		yvec(ii) = yvec(ii) + yoffset;
  
  end
	offset_x = xvec(index);
	offset_y = yvec(index);
	for ii=1:n
	
		xvec(ii) = xvec(ii) - offset_x;
		yvec(ii) = yvec(ii) - offset_y;
	
  end
	% rotate with angle and translate back
	for ii=1:n
	
		x = xvec(ii);
		y = yvec(ii);

    xvec(ii) = cyaw * x + syaw * y;
    yvec(ii) = -syaw * x + cyaw * y;

    xvecout(ii) = xvec(ii) + offset_x;
		yvecout(ii) = yvec(ii) + offset_y;
	
  end 

end