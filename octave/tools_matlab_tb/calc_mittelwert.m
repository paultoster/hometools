function [ymit,nmit,ystd] = calc_mittelwert(y,typ,z,zmin,zmax)
%
% ymit = mittelwert(y,typ,z,zmin,zmax)
% 
% y     der zu mittelnde Vektor oder auch meherere Vektoren (Matrix)
% typ   'all'      Aus allen Werten mitteln
%       'zcond'    Es muﬂ die Bedingung zmin < z(i) < zmax erf¸llt sein
%       'conected' Berechnet den Mittelwert aus dem ersten
%                  Zusammenh‰ngenden St¸ck mit der Bedigung zmin < z(i) < zmax
%       'gleit'    Gleitender Mittelwert  [ymit,nmit,ystd] = calc_mittelwert(y,typ,n)
%
% z     Bedingungswert
% zmin  minimale Schwelle der Bedingung
% zmax  maximale Schwelle der Bedingung
%
% ymit  gemittelter Wert
% nmit  Anzahl der gefunden Punkte zum mitteln
% ystd  Standardabweichung

  if( ~exist('typ','var') )
      typ = 'a';
  end

  if( typ(1) == 'a' )
      [m,n] = size(y);
      nmit  = n*m;
      i1 = 0;
      for i=1:m
          for j=1:n
              i1 = i1+1;
              y1(i1) = y(i,j);
          end
      end
      ymit  = mean(y1);
      ystd  = std(y1);


  elseif( typ(1) == 'z' | typ(1) == 'c' )

      if( typ(1) == 'c' )
          connected_typ = 1;
      else
          connected_typ = 0;
      end    

      if( ~exist('z','var') )
          error('Vektor z ist nicht vorhanden')
      end
      if( ~exist('zmin','var') )
          zmin = min(min(z));
      end
      if( ~exist('zmax','var') )
          zmax = max(max(z));
      end

      if( iscell(y) )

          if( ~iscell(z) )            
              error('y ist cellaray und z nicht !!!')
          end

          if( length(y) ~= length(z) )
              error('cell-array y und z haben nicht die gleiche cell array-L‰nge')
          end

          for i=1:length(y)

              if( length(y{i}) ~= length(z{i}) )

                  error('Die einzelnen Cellarrays y un z stimmen nicht mit ihren L‰ngen jeweils zusammen')
              end
          end

          yy = y;
          zz = z;
      else

          [m,n]=size(y);
          [mz,nz]=size(z);

          if( mz ~= m )
              error('Matrix/Vektor y und z stimmen in der Spaltenl‰nge nicht ¸berein')
          elseif( nz ~= n )
              error('Matrix/Vektor y und z stimmen in der Zeilenl‰nge nicht ¸berein')
          end

          if( m > n )

              for i=1:n

                  yy{i} = y(:,i);
                  zz{i} = z(:,i);
              end
          else

              for i=1:m

                  yy{i} = y(i,:)';
                  zz{i} = z(i,:)';
              end
          end
      end        

      y1 = [];
      for i=1:length(yy)

          found_flag = 0;

          for j=1:length(yy{i})

              if( zz{i}(j) >= zmin && zz{i}(j) <= zmax )

                  if( connected_typ && ~found_flag )
                      found_flag = 1;
                  end
                  y1 = [y1;yy{i}(j)];
              elseif( connected_typ && found_flag )

                  break
              end
          end
      end
      nmit = length(y1);
      ymit = mean(y1);
      ystd = std(y1);
  elseif( typ(1) == 'g' || typ(1) == 'G' )

      n = max(round(z),1);
      b = ones(1,n)/n;
      a = 1;
      %ymit = filter(b,a,y);
      ymit = calc_mittelwert_gleit(y,n);
      nmit = length(ymit);
      ystd = std(ymit);

  end        
    
end   
function ymit = calc_mittelwert_gleit(y,ngl)

  n    = length(y);
  ngl  = min(n,ngl);
  ymit = y*0.0;

  for i=1:n

    if( i >= 370 )
      t=0;
    end
    y0 = 0.;
    i0 = 0;
    for j=ngl:-1:1

      i1 = i-j+1;
      if( i1 >= 1 )
        
        %y0 = y0+y(i1);
        i0 = i0 + 1;
        y0 = y0*(i0-1)/i0 + y(i1)/i0;
      end
    end
    %ymit(i) = y0/i0;
    ymit(i) = y0;
  end
  
 
end
    
    
        

        
    
    