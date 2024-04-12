function index = vek_2d_naechster_punkt(xvec,yvec,xwert,ywert)
%
% index = vek_2d_naechster_punkt(xvec,yvec,xwert,ywert)
%
% nächster Punkt in 2D
% xvec          x-vektor
% yvec          y-vektor
% xwert,ywert   vorgegebener Punkt
%
    index = []; %Kreuzungspunkt, wenn 1

    n = min(length(xvec),length(yvec));
    m = min(length(xwert),min(ywert));
    
    index = zeros(m,1);
    for i=1:m
    
      d = ones(n,1);
      for j= 1:n
        d(j) = sqrt((xvec(j)-xwert(i))^2 + (yvec(j)-ywert(i))^2);
      end
      [dmin,ind] = min(d);
      index(i) = ind;
    end
end