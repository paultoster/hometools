function iknick = vek_2d_find_180_retun_Knick_in_path(xvec,yvec,dirvec)
%
% iknick = vek_2d_find_180_retun_Knick_in_path(xvec,yvec)
% iknick = vek_2d_find_180_retun_Knick_in_path(xvec,yvec,dirvec)
%
% schaut, ob der Pfad einen 180 grad klnick hat mit Punktprodukt
%
% dirvec enthält die Richtung dirvec(i) = -1,1 / rueckwaerts oder vorwaerts
%
% z.B. xvec = [0,1,0.5,3,4] und yvec = [10,5,7.5,10,10] hat einen Knick bei
% iknick = 2
% iknick > 0 => Knick gefunden an Stelle iknick
% iknick = 0;   kein Knick gefunden
  iknick = 0;
  n = min(length(xvec),length(yvec));
  
  if( ~exist('dirvec','var') )
    dirvec = xvec * 0.0 + 1.0;
  end
  for i = 2:n-1
    
   if( (dirvec(i) == dirvec(i-1)) && (dirvec(i) == dirvec(i+1)) )

    pp  = (xvec(i)-xvec(i-1))*(xvec(i+1)-xvec(i));
    pp  = pp + (yvec(i)-yvec(i-1))*(yvec(i+1)-yvec(i));

    if( pp < -0.001 ) 
      iknick = i;
      return
    end
   end
 end
end



