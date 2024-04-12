function  index = str_find_next_wspace_f(text_string,index0,regel)
%
%  index = str_find_next_wspcae(text_string,index0,type)
%
% text_string               text zum durchsuchen
% index0                    Startpunkt i0 = max(1,min(inedx0,length(text_string)))
% regel =
%     'v' vorwärts suchen von index0 bis whitespave kommt, wenn nicht dann
%     index = 0
%     'r' rückwärts suchen von index0 bis whitespave kommt, wenn nicht dann
%     index = 0
%     'vn' vorwärts suchen von index0 bis kein whitespace mehr kommt, wenn nicht dann
%     index = 0
%     'rn' rückwärts suchen von index0 bis kein whitespace mehr kommt, wenn nicht dann
%     index = 0
%
%
%  t = 'abc =10; ijk';
%  i = str_find_next_wspace_f(t,5,'v')      => i = 9
%  i = str_find_next_wspace_f(t,5,'vn')     => i = 5
%  i = str_find_next_wspace_f(t,4,'vn')     => i = 5
%  i = str_find_next_wspace_f(t,10,'v')     => i = 0

  if( ~ischar(text_string) )
    error('1. Parameter kein string');
  end
  if( ~exist('index0','var') )
    error('2. Parameter index0 fehlt')
  end
  if( ~exist('regel','var' ) )
      error('3. Parameter regel fehlt')
  elseif( isempty(regel) || ~ischar(regel) )
      error('3. Parameter regel ist leer oder kein string')
  end

  i0 = max(1,min(index0,length(text_string)));

  index = 0;

  n = length(text_string);
  
  ivec = isstrprop(text_string,'wspace');

  type = 0;
  if( regel(1) == 'v' )
    if( (length(regel) > 1 ) && (regel(2) == 'n' ))
      type = 2; % vn
    else
      type = 1; % v
    end
  else
    if( (length(regel) > 1 ) && (regel(2) == 'n' ))
      type = 4; % rn
    else
      type = 3; % r
    end
  end

  if( type == 1  ) % v

    % go forward until whitespace
    i    = i0;
    while(ivec(i) == 0)
      i = i + 1;
      if( i > n )
    %     index = 0;
        return;
      end
    end
    index = i;
  elseif( type == 2 ) % vn
    
    % go forward until not whitespace
    i    = i0;
    while(ivec(i) ~= 0)
      i = i + 1;
      if( i > n )
    %     index = 0;
        return;
      end
    end
    index = i;
  elseif( type == 3  ) % r

    % go backward until whitespace
    
    i    = i0;
    while(ivec(i) == 0)
      i = i - 1;
      if( i < 0 )
    %     index = 0;
        return;
      end
    end
    index = i;
  elseif( type == 4 ) % rn
    
    % go backward until no whitespace
    i    = i0;
    while(ivec(i) ~= 0)
      i = i - 1;
      if( i < 1 )
    %     index = 0;
        return;
      end
    end
    index = i;
  end  
end        
    
    
    