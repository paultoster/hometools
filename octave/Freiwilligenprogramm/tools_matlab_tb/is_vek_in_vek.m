function flag = is_vek_in_vek(vek_base,vek_to_check,tol)
%
% flag = is_vek_in_vek(vek_base,vek_to_check)
% flag = is_vek_in_vek(vek_base,vek_to_check,tol)
%
% Ist Vektor vek_to_check in Vektor vek_base enthalten.
% tol kann als Toleranz angebene werden (defaul 1e-6)
%
% flag    0/1   nicht enthalten / enthalten
%
  if( ~exist('tol','var') )
    tol = 1e-6;
  end

  [n,m] = size(vek_to_check);
  flag = 1;
  for i=1:n
    for j=1:m
     f = suche_wert_in_vek(vek_base,vek_to_check(i,j),tol);
     if( ~f )
       flag = 0;
       return;
     end
    end
  end
end