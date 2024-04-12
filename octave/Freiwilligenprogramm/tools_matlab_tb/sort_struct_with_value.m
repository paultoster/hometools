function s1 = sort_struct_with_value(s,fieldname,steigend)
%
% s = sort_struct_with_value(s,fieldname)
%
% Sortiert struktur s(i) mit s(i).fieldname
%             
% s           indizierte Struktur s(i) i=1:n
%             ...
% fieldname   der zu sortierende Vektor d.(fieldname) 
% steigend    = 1 aufsteigend (default)
%             = 0 abfallend

% 
  if( ~exist('steigend','var') )
    steigend = 1;
  end
  
  if( ~isfield(s,fieldname) )
    error('der fieldname:<%s> ist in Datenstruktur nicht vorhanden',fieldname)
  end
  
  [n,m] = size(s);
  vec   = zeros(n*m,1);
  
  for i=1:m
    for j=1:n
      vec((i-1)*n+j) = s(j,i).(fieldname);
    end
  end
      
  
  if( steigend )
    [a,ivec] = sort(vec);
  else
    [a,ivec] = sort(vec, 'descend');
  end
  nvec = length(ivec);
  
  
  s1 = s;
  
  for i=1:nvec
    n0 = i;
    m0 = 1;
    while(n0-n>0)
      n0 = n0-n;
      m0  = m0+1;
    end
    n1 = ivec(i);
    m1 = 1;
    while(n1-n>0)
      n1 = n1-n;
      m1  = m1+1;
    end
    s1(n0,m0) = s(n1,m1);
  end
        
end