function alphav = Winkel_2pi_Sprung(alphav,unit)
%
% alphav = Winkel_2pi_Sprung(alphav,unit)

% Behandlung von Heading bei 2*pi -Sprünge
%
  n = length(alphav);
  % Einheit
  if( ~isempty(unit) )
    unit_in  = unit;
  else
    unit_in  = 'Degrees';
  end
  [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,'rad');    
  if( ~isempty(errtext) )
    error('Fehler bei unit-convert in Signal <%s> \n%s','Heading',errtext)
  end
    
  vec = alphav * fac + offset;
  
  pdelta0 = 2*pi*0.8;
  pdelta1 = 2*pi*1.2;
  mdelta0 = -2*pi*0.8;
  mdelta1 = -2*pi*1.2;
  add     = 0.0;
  vec1    = vec*0.0;
  vec1(1) = vec(1);
  for i=2:n
    
    val0  = vec(i-1) ; %+ ydiff_f(i-1) * (h.time(i)-h.time(i-1));
    vdiff = vec(i) - val0;
    
    if( (vdiff > pdelta0) && (vdiff < pdelta1) )
      add = add - pi*2.0;
    elseif( (vdiff < mdelta0) && (vdiff > mdelta1) )
      add = add + pi*2.0;
    end
    
    vec1(i) = vec(i)+add;
  end
  
%   figure(100)
%   plot(vec*180/pi,'k-')
%   hold on
%   plot(vec1*180/pi,'r-')
%   hold off 
%   grid on
  
  
  alphav = (vec1-offset)/fac;
      
end
