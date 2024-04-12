function state_space_print_sys(type,a1,a2,a3,a4,a5)
%
% state_space_print_sys('cont',A,B,C[,D]) 
% state_space_print_sys('discr',Ts,A,B,C[,D]) 
%
% print on screen sys from  continous or discrete
%
%
  if( (type(1) == 'c') || (type(1) == 'C') )
    is_contious = 1;
  else
    is_contious = 0;
  end

  if( is_contious )
    if( nargin < 4 )
      error('call state_space_print_sys(''c'',A,B,C) see help');
    end
    Ts = 0.;
    A = a1;
    B = a2;
    C = a3;
    if( nargin > 4 )
      D = a4;
    end
  else
    if( nargin < 5 )
      error('call state_space_print_sys(''d'',Ts,A,B,C) see help');
    end
    Ts = a1;
    A = a2;
    B = a3;
    C = a4;
    if( nargin > 5 )
      D = a5;
    end
  end

  [n,m] = size(A);
  if( n ~= m ) 
    error('A is not symetric')
  end
  [nn,m] = size(B);
  if( n ~= nn ) 
    error('B is not compatible to A')
  end

  [q,nn] = size(C);
  if( n ~= nn ) 
    error('C is not compatible to A')
  end

  if( ~exist('D','var') )
    D = [];
  end

  if( ~isempty(D) )
    [qq,mm] = size(D);
    if( qq ~= q ) 
      error('D is not compatible to C')
    end
    if( mm ~= m ) 
      error('D is not compatible to B')
    end
  end  
  
  lambdas = eig(A);


  fprintf('--------------------------------------------------------------------------------------------\n');
  fprintf('Input  m  := %i\n',m);
  fprintf('State  n  := %i\n',n);
  fprintf('Output q  := %i\n',q);
  
  for i=1:length(lambdas)
    if( imag(lambdas(i)) == 0.0 )
      fprintf('lambda(%i)  = %f',i,lambdas(i));
    else
      fprintf('lambda(%i)  = %f + %f * i',i,real(lambdas(i)),imag(lambdas(i)));
    end
    
    if( ~is_contious )
      fprintf(' =>  radius(%f)',sqrt(real(lambdas(i))^2+imag(lambdas(i))^2));
    end
    
    fprintf('\n');
  end

  if( ~is_contious )
    fprintf('Disrete Ts = %f\n',Ts);
  end
  
  fprintf('\n');
  
  ca    = cell(n,n);
  carow = cell(n,1);
  for i=1:n
    carow{i} = '';
    for j=1:n
      ca{i,j} = sprintf(' %10.3f ',A(i,j));
      carow{i} = [carow{i},ca{i,j}];
    end
  end

  cb = cell(n,m);
  cbrow = cell(n,1);
  for i=1:n
    cbrow{i} = '';
    for j=1:m
      cb{i,j} = sprintf(' %10.3f ',B(i,j));
      cbrow{i} = [cbrow{i},cb{i,j}];
    end
  end

  cc    = cell(q,n);
  ccrow = cell(q,1);
  for i=1:q
    ccrow{i} = '';
    for j=1:n
      cc{i,j} = sprintf(' %10.3f ',C(i,j));
      ccrow{i} = [ccrow{i},cc{i,j}];
    end
  end

  if( ~isempty(D) )
    cd = cell(q,m);
    cdrow = cell(q,1);
    for i=1:q
      cdrow{i} = '';
      for j=1:m
        cd{i,j} = sprintf(' %10.3f ',D(i,j));
        cdrow{i} = [cdrow{i},cd{i,j}];
      end
    end
  end
  tspace = sprintf(' %10s ',' ');
  
  % A - matrix
  


  if( is_contious )
    txpline  = ' xp(t) = ';
    txpspace = '         ';

    txline  = ' * x(t)      ';
    txspace = '             ';

    tyline  = '  y(t) = ';
    tyspace = '         ';
  else
    txpline  = ' x(k+1) = ';
    txpspace = '          ';

    txline  = ' * x(k)      ';
    txspace = '             ';

    tyline  = '   y(k) = ';
    tyspace = '          ';
  end
  
  % erste Gleichung
  if( n == 1 )

    fprintf('%s%s',txpline,carow{1});
    
    if( m == 1 )
      fprintf('%s%s * u(t)\n',txline,cbrow{1});
    elseif( m > 1 )
      fprintf('%s[%s] * u(t)\n',txline,cbrow{1});
    end
      

  else
    % obere dekorierung
    fprintf('%s+',txpspace);
    for i=1:n,fprintf('%s',tspace);end
    fprintf('+');
    
    if( m > 0 )
      fprintf('%s+',txspace);
      for i=1:m,fprintf('%s',tspace);end
      fprintf('+\n');
    end
    
    % matrix
    for i=1:n
      if( i==1 )
        fprintf('%s|',txpline);
      else
        fprintf('%s|',txpspace);
      end
      
      fprintf('%s',carow{i});
      
      if( i==1 )
        fprintf('|%s',txline);
      else
        fprintf('|%s',txspace);
      end
      
      if( m > 0 )
        fprintf('|%s',cbrow{i});
        if( i==1 )
          fprintf('| * u(t)\n');
        else
          fprintf('|\n');
        end
      end
    end
    
    % untere dekorierung
    fprintf('%s+',txpspace);
    for i=1:n,fprintf('%s',tspace);end
    fprintf('+');
    
    if( m > 0 )
      fprintf('%s+',txspace);
      for i=1:m,fprintf('%s',tspace);end
      fprintf('+\n');
    end
  end 
  
  % zweite Gleichung
  fprintf('\n');
  if( q == 1 )
    
    if( n == 1 )
      fprintf('%s%s*%s',tyline,ccrow{1},txline);
    else
      fprintf('%s[%s]%s',tyline,ccrow{1},txline);
    end
    
    if( ~isempty(D) )
    
      if( m == 1 )
        fprintf('+%s * u(t)\n',cdrow{1});
      elseif( m > 1 )
        fprintf('+[%s] * u(t)\n',cdrow{1});
      end
    else
      fprintf('\n');
    end
    
  else
    
    % obere dekorierung
    fprintf('%s+',tyspace);
    for i=1:n,fprintf('%s',tspace);end
    fprintf('+');
    
    if( m > 0 )
      fprintf('%s+',txspace);
      for i=1:m,fprintf('%s',tspace);end
      fprintf('+\n');
    end
    
    % matrix
    for i=1:q
      if( i==1 )
        fprintf('%s|',tyline);
      else
        fprintf('%s|',tyspace);
      end
      
      fprintf('%s',ccrow{i});
      
      if( i==1 )
        fprintf('|%s',txline);
      else
        fprintf('|%s',txspace);
      end
      
      if( m > 0 && ~isempty(D) )
        fprintf('|%s',cdrow{i});
        if( i==1 )
          fprintf('| * u(t)\n');
        else
          fprintf('|\n');
        end
      else
        fprintf('\n');
      end
    end
    
    % untere dekorierung
    fprintf('%s+',tyspace);
    for i=1:n,fprintf('%s',tspace);end
    fprintf('+');
    
    if( m > 0 )
      fprintf('%s+',txspace);
      for i=1:m,fprintf('%s',tspace);end
      fprintf('+\n');
    end

  end 

  fprintf('--------------------------------------------------------------------------------------------\n');

end