function vec = vec_shift(vec,ishift)
%
% vec = vec_shift(vec,ishift)
%
% verschiebt Inhalt vektor um ishift = 1,2,3,... index nach vorne (vergrößern)
% verschiebt Inhalt vektor um ishift = -1,-2,-3,... index nach hinten (verkleinern)
% 

  if( ~isnumeric(vec) )
    error('Falscher Typ: erster Parameter muss ein vekotor sein')
  end
  if( ~exist('ishift','var') )
      error('vec_shift: ishift ist nicht vorhanden')
  end
  
  [nrow,ncol] = size(vec);
  
  if( nrow == 1 )
    trans = 1;
    vec = vec';
    nn = nrow;
    %rnow = ncol;
    ncol = nn;
  else
    trans = 0;
  end
  
  n = length(vec);
  
  if( ncol > 1 )
    error('vec is not a vector but a matrix')
  end
  
  ishift = round(ishift);
  if( ishift > 0 )
    for i=n:-1:1
      vec(i+ishift) = vec(i);
    end
  elseif(ishift < 0 )
    ishift = -ishift;
    if( ishift > n )
      vec = [];
    else
      vec1 = zeros(n-ishift,1);
      for i=1:n-ishift
        vec1(i) = vec(i+ishift);
      end
      vec = vec1;
    end
  end
  
  if( trans && ~isempty(vec) )
    vec = vec';
  end
end