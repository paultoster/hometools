function  index = str_find_index_f(text_string,index0,regel,text1,text2)
%
%  index = str_find_index_f(text_string,index0,regel,text1,text2)
%
% Sucht text1 in Abhängikeit von Regel und index0:
%
% text_string               text zum durchsuchen
% inde0                     Startpunkt i0 = max(1,min(inedx0,length(text_string)))
%
% 'v' vorwärts suchen von i0 an nach text1
% 'r' rückwerts suchen von i0-length(text1)+1 an nach text1
% 'a' vorwärts suchen von i0 an nach text1, wenn aber text2 auftaucht(n-mal), dann
%     wird n+1 mal der text1 gesucht,d.h t = '123456{89{12}456}89012';
%     immer bei index0=7 anfangen um i=17 zu finden
% 'b' rückwaerts suchen von i0 an nach text1, wenn aber text2 auftaucht(n-mal), dann
%     wird n+1 mal der text1 gesucht,d.h t = '123456{89{12}456}89012';
%     immer bei index0=17 anfangen um i=7 zu finden
% 'c'
% 'd' rückwärts ob das nachsten Zeichen/folge text1 ist, überspringe ' ','\n','\t'
%
% Gibt die gesuchte Stelle zurück
% wenn nicht gefunden, dann 0 zurückgegeben
%
% Beispiel 'v'
%
%  t = '123456{89{12}456}89012';
%  i = str_find_index_f(t,1,'v','{')      => i = 7
%  i = str_find_index_f(t,7,'v','{')      => i = 10
%  i = str_find_index_f(t,7,'r','2')     => i = 2
%  i = str_find_index_f(t,7,'a','}','{') => i = 17
%  i = str_find_index_f(t,17,'b','{','}') => i = 7

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


  if( ~exist('text1','var') )
      error('4. Parameter text1 nicht vorhanden')
  end

  if( regel(1) == 'n' )
    if( ~exist('text2','var') )
      error('5. Parameter text2 nicht vorhanden')
    end
  end

  i0 = max(1,min(index0,length(text_string)));

  ivec = strfind(text_string,text1);

  index = 0;

  if( regel(1) == 'v' )

    for i=1:length(ivec)
      if( ivec(i) >= i0 )
        index = ivec(i);
        break;
      end
    end

  elseif( regel(1) == 'r' )

    i0 = i0 - length(text1) + 1;
    if( i0 < 1 ) 
      return
    end
    for i=length(ivec):-1:1
      if( ivec(i) <= i0 )
        index = ivec(i);
        break;
      end
    end
  elseif( regel(1) == 'a' )
    
    ivec2      = strfind(text_string,text2);
    flagrun    = 1;
    indexproof = 0;
    m          = 0;
    
%     % wenn erstes == text2 dann ein mehr
%     if( strcmp(text_string(i0:min(i0+length(text2)-1,length(text_string))),text2) )
%       iadd = 1;
%     else
%       iadd = 0;
%     end
    
    while(flagrun)
      
      k = 0;
      % find next text1  
      for i=1:length(ivec)
        if( ivec(i) >= i0 )
          indexproof = ivec(i);
          k = k+1;
          if( k >= m )
            break;
          end
        end
      end

      % proof index
      mproof = 0;
      for i=1:length(ivec2)
        
        if( ivec2(i) > indexproof )
          break;
        elseif( (ivec2(i) >= i0) )
          mproof = mproof + 1;
        end
      end
      
%       if( m == (mproof+iadd) )
      if( m == mproof )
        flagrun = 0;
        index   = indexproof;
      else
        m = mproof;
      end
    end
    
    
  elseif( regel(1) == 'b' )
    
    
    ivec2      = strfind(text_string,text2);
    flagrun    = 1;
    indexproof = 0;
    m          = 0;
        
    while(flagrun)
      
      k = 0;
      % find next text1  
      for i=length(ivec):-1:1
        if( ivec(i) <= i0 )
          indexproof = ivec(i);
          k = k+1;
          if( k >= m )
            break;
          end
        end
      end

      % proof index
      mproof = 0;
      for i=length(ivec2):-1:1
        
        if( ivec2(i) < indexproof )
          break;
        elseif( (ivec2(i) <= i0) )
          mproof = mproof + 1;
        end
      end
      
      if( m == mproof )
        flagrun = 0;
        index   = indexproof;
      else
        m = mproof;
      end
    end
    
  elseif( regel(1) == 'd' )
    
    ivec=isspace(text_string(1:i0));
    
    % go backward until not space
    flag = 1;
    i    = i0-1;
    while(flag)
      
      if( i < 1 )
%       index = 0;
        return
      elseif( ivec(i) ) % isspace
        i = i-1;
      else
        flag = 0;
      end
    end
    j = i;
    i = i - length(text1) + 1;
    if( i < 1 )
%     index = 0;
      return;
    end
    
    if( strcmp(text_string(i:j),text1) )
      index = i;
%     else
%       index = 0;
    end
    
  else
    error('Regel nicht bekannt regel= <%s>',regel)
  end
  
end        
    
    
    