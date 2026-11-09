function vec = build_aequi_dist_vektor(v0,v1,dv,type)
%
% vec = build_aequi_dist_vec(v0,v1,dv,0);
% vec = build_aequi_dist_vec(v0,v1,nv,1);
%
% v0      startwert
% v1      endwert
% dv      delta Wert
% nv      Anzahl der Punkte

  if( type )
    nv = max(2,round(dv));
    dv = (v1-v0)/(nv-1);
    vec = [v0:dv:v1]';
  else
    if( v1 >= v0 ) 
      dv = abs(dv);
      if( v1 < v0+dv )
        dv = v1 - v0;
      end
    else
      dv = -abs(dv);
      if( v1 > v0+dv )
        dv = v1 - v0;
      end
    end
    vec = [v0:dv:v1]';
  end
end
