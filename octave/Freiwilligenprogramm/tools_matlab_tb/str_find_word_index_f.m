function  [word,index] = str_find_word_index_f(text_string,index0,regel)
%
%  [word,index] = str_find_word_index_f(text_string,index0,regel)
%
% text_string               text zum durchsuchen
% index0                    Startpunkt i0 = max(1,min(inedx0,length(text_string)))
%
% 'v' vorwärts suchen von i0 nach word
% 'r' rückwärts suchen von i0 nach word
% 'a' vorwaerts und rueckwaerts von i0 aus
% 'va' vorwärts suchen von i0 nach word erster digit muß ein Buchstabe sein
% 'ra' rückwärts suchen von i0 nach word erster digit muß ein Buchstabe sein
% 'aa' vorwaerts und rueckwaerts von i0 aus erster digit muß ein Buchstabe sein
%
% Gibt Wort und die gesuchte Stelle zurück
% wenn nicht gefunden, dann 0 zurückgegeben
%
%
%  t = 'abc = 10; ijk';
%  [w,i] = str_find_word_index_f(t,1,'v')      => w = 'abc' i = 1
%  [w,i] = str_find_word_index_f(t,100,'r')    => w = 'ijk' i = 11
%  [w,i] = str_find_word_index_f(t,2,'a')      => w = 'abc' i = 1
%  [w,i] = str_find_word_index_f(t,100,'a')    => w = 'ijk' i = 11
%
%  t = ' 2def  = Dabc';
%  [w,i] = str_find_word_index_f(t,1,'va')     => w = 'Dabc' i = 1

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
  word  = '';

  n = length(text_string);
  
  letterflag = 0;
  if( length(regel) > 1 )
    if( regel(2) == 'a' )
      letterflag = 1;
    end
  end
  
  if( regel(1) == 'v' )

    % go forward until not space
    ivec = isalphanumspez(text_string,{'_'});
    
    i    = i0;
    while(ivec(i) == 0)
      i = i + 1;
      if( i > n )
    %     index = 0;
        return;
      end
    end
    if( letterflag )
      % search for begin withh letter
      while(~isstrprop(text_string(i),'alpha'))
        i = i + 1;
        if( i > n )
      %     index = 0;
          return;
        end
      end
    end      
    istart = i;
    if( i == n )
      iend = i;
    else
      i    = i + 1;
      while(ivec(i) ~= 0)
        if( i >= n )
           i = n+1;
           break;
        end
        i = i + 1;      
      end
      iend = i-1;
    end    
    word  = text_string(istart:iend);
    index = istart;
  elseif( regel(1) == 'r' )


    % go backward until not space
    ivec = isalphanumspez(text_string(1:i0),{'_'});
    
    i    = i0;
    while(ivec(i) == 0)
      i = i - 1;
      if( i < 1 )
    %     index = 0;
        return;
      end
    end
    
    iend = i;
    if( i == 1 )
      istart = 1;
    else
      i    = i - 1;
      while(ivec(i) ~= 0)
        if( i <= 1 )
           i = 0;
           break;
        end
        i = i - 1;      
      end
      istart = i+1;
    end    
    if( letterflag )
      % proof for letter start
      i = istart;
      while(~isstrprop(text_string(i),'alpha'))
        i = i + 1;
        if( (i > n) || (i > iend) )
      %     index = 0;
          return;
        end
      end
      istart = i;
    end

    word  = text_string(istart:iend);
    index = istart;
  else   % if( regel(1) == 'a' )
    
    % find all alphnum + '_'
    ivec = isalphanumspez(text_string,{'_'});
    
    % start
    if( ivec(i0) == 0 )
%     index = 0;
      return;
    end
    % go backward to find istart
    istart = i0;
    flag = 1;
    while(flag)
      
      if( istart-1 == 0 )
        istart = 1;
        flag = 0;
      elseif( ivec(istart-1) ~= 0 )
        istart = istart-1;
      else
        flag = 0;
      end
    end
    
    % go forward to find iend
    iend = i0;
    flag = 1;
    while(flag)
      
      if( iend+1 == n )
        iend = n;
        flag = 0;
      elseif( ivec(iend+1) ~= 0 )
        iend = iend+1;
      else
        flag = 0;
      end
    end
    
    if( letterflag )
      i = istart
      % search for begin withh letter
      while(~isstrprop(text_string(i),'alpha'))
        i = i + 1;
        if( i > iend )
      %     index = 0;
          return;
        end
      end
      istart = i;
    end      
    
    word  = text_string(istart:iend);
    index = istart;
            
  end
  
end        
    
    
    