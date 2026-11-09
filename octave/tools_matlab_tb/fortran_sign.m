function val = fortran_sign(val,signval)
%
% val = fortran_sign(val,signval);
%
% val = sign(signval) * abs(val);
%
  if( val >= 0.0 )
    if( signval < 0.0 )
      val = -val;
    end
  else
    if( signval >= 0.0 )
      val = -val;
    end
  end
end