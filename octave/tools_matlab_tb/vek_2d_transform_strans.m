function   [xvec_mod,yvec_mod] = vek_2d_transform_strans(xvec,yvec,strans)
%
%
% [xvec_mod,yvec_mo] = vek_2d_transform_strans(xvec,yvec,strans)
%
% 
% strans.xoffsetsub       
% strans.yoffsetsub
% strans.dyaw           [rad]
% strans.xoffsetadd
% strans.yoffsetadd
%
% Berechnung:
%
% xvec_mod =  (xvec-xoffsetsub)*cos(dyaw)+(yvec-yoffsetsub)*sin(dyaw) + xoffsetadd
% yvec_mod = -(xvec-xoffsetsub)*sin(dyaw)+(yvec-yoffsetsub)*cos(dyaw) + yoffsetadd
%

  if( ~isstruct(strans) )
    error('Error_%s: 3.Parameter muss Struktur sein',mfilename);
  end
  if( ~isfield(strans,'xoffsetsub') )
    error('Error_%s: xoffsetsub nicht in Struktur 3.Parameter',mfilename);
  end
  if( ~isfield(strans,'yoffsetsub') )
    error('Error_%s: yoffsetsub nicht in Struktur 3.Parameter',mfilename);
  end
  if( ~isfield(strans,'xoffsetadd') )
    error('Error_%s: xoffsetadd nicht in Struktur 3.Parameter',mfilename);
  end
  if( ~isfield(strans,'yoffsetadd') )
    error('Error_%s: yoffsetadd nicht in Struktur 3.Parameter',mfilename);
  end
  if( ~isfield(strans,'dyaw') )
    error('Error_%s: dyaw nicht in Struktur 3.Parameter',mfilename);
  end
  
  if( isempty(xvec) || isempty(yvec) )
    xvec_mod = xvec;
    yvec_mod = yvec;
    return
  end
  
  [xvec,yvec]  = vek_2d_transform_strans_check_size(xvec,yvec);

  cyaw     = cos(strans.dyaw(1));
  syaw     = sin(strans.dyaw(1));
  T        = [cyaw,syaw;-syaw,cyaw];
  x        = [(xvec-strans.xoffsetsub(1))';(yvec-strans.yoffsetsub(1))'];
  y        = T*x;
  xvec_mod = y(1,:)' + strans.xoffsetadd(1);
  yvec_mod = y(2,:)' + strans.yoffsetadd(1);
  
end
function  [xvec,yvec]  = vek_2d_transform_strans_check_size(xvec,yvec)
  [xvec,n] = vek_2d_transform_strans_spalten_vektor(xvec);
  [yvec,m] = vek_2d_transform_strans_spalten_vektor(yvec);
  
  if( n > m )
    xvec = xvec(1:m);
  elseif( m > n )
    yvec = yvec(1:n);
  end
end

function  [vec,n] = vek_2d_transform_strans_spalten_vektor(vec)
%
% mache einen Spaltenvektor
  [n,m] = size(vec);
  if( m > n )
    vec = vec';
    ii      = m;
    m       = n;
    n       = ii;
  end
  if( m > 1 )
    vec = vec(:,1);
  end
end
