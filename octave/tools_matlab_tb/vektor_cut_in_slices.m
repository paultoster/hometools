function [slices,nslices] = vektor_cut_in_slices(xvec,delta_x,type)
%-------------------------------
% [slices,nslices] = vektor_cut_in_slices(xvec,delta_x,type)
% 
% Zerlegt Vektor in delta_x-Stücken
%
% xvec           Vektor monoton stegend oder fallend
% delta_x        x-Laenge zu Einteilen
% type           'u'    ueberlappend mit dem ersten Wert
%                       ansonsten getrennt
%
% slices(1:nslices).xstart
% slices(1:nslices).xend
% slices(1:nslices).n
% slices(1:nslices).i0
% slices(1:nslices).i1
% slices(1:nslices).xvec
%
%-------------------------------

  if( ~exist('type','var') )
    type = 'n';
  end
  
  if( type(1) == 'u' )
    add_one = 0;
  else
    add_one = 1;
  end

  [n,m] = size(xvec);

  if( m > n )
      trans_flag = 1;
      xvec = xvec';
      dum = n;
      n   = m;
      m   = dum;
  else
      trans_flag = 0;
  end

  if( is_monoton(xvec,1,0) )
    msteigend = 1;
  elseif( is_monoton(xvec,2,0) )
    msteigend = 0;
  else
    error('%s: Der x-Vektor ist nicht monoton',mfilename)
  end
  
  
  
  nvec = length(xvec);
  
  if( msteigend )
    vergleich_text = '>=';
    delta_x        = abs(delta_x);
  else
    vergleich_text = '<=';
    delta_x        = -abs(delta_x);
  end   
  
  slices.xstart = xvec(1);
  slices.i0     = 1;

  nslices       = 1;
  flag = true;
  while( flag )
    index = suche_schwelle(xvec,slices(nslices).xstart+delta_x,vergleich_text,eps);
    if( index == 0 )
      slices(nslices).i1   = nvec;
      slices(nslices).xend = xvec(slices(nslices).i1);
      slices(nslices).xvec = xvec(slices(nslices).i0:slices(nslices).i1);
      flag = 0;
    else
      slices(nslices).i1   = index;
      slices(nslices).xend = xvec(slices(nslices).i1);
      slices(nslices).xvec = xvec(slices(nslices).i0:slices(nslices).i1);

      if( slices(nslices).i1 == nvec )
        flag = 0;
      else
        nslices = nslices + 1;

        if( add_one ) % nicht ueberlappend
          index = index +1;
        end
        slices(nslices).xstart = xvec(index);
        slices(nslices).i0     = index;
      end  
    end
  end
  
  if( trans_flag )
    for i=1:nslices
      slices(i).xvec = (slices(i).xvec)';
    end
  end
    
end
