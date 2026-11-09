function flag_in_square = vek_2d_proof_same_point_square(x0,y0,x1,y1,d)
%
% flag_in_square = vek_2d_proof_same_point_square(x0,y0,x1,y1,d)
%
% template <typename T> bool Vek2DProofSamePointSquare(T &x0, T &y0, T &x1, T &y1, T &d)
% {
%   T dx = x1 - x0;
%   T dy = y1 - y0;
% 
%   if( (dx < d) && (dx > -d) && (dy < d) && (dy > -d) ) return true;
%   else                                                 return false;
% }
%
  dx = x1 - x0;
  dy = y1 - y0;

  if( (dx < d) && (dx > -d) && (dy < d) && (dy > -d) ) 
    flag_in_square = 1;
  else
    flag_in_square = 0;
  end
end
