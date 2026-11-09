function  index = str_find_word_f(text_string,index0,word,regel)
%
%  
%  index = str_find_word_f(text_string,index0,word,regel)
%
% text_string               text zum durchsuchen
% index0                    Startpunkt i0 = max(1,min(inedx0,length(text_string)))
% word                      gesuchtes wort
% regel                     'l'   independent of upper/iower case
%
% sucht Wort und und gibt gesuchte Stelle zurück
% wenn nicht gefunden, dann index = 0 zurückgegeben
%
%
%  t = 'abc = 10; ijk ABC';
%  i = str_find_word_f(t,1,'IJK','l')      => i = 11;
%  i = str_find_word_f(t,1,'ABC')          => i = 15;
%  i = str_find_word_f(t,10,'abc','l')      => i = 15;
%

  if( ~ischar(text_string) )
    error('1. Parameter kein string');
  end
  if( ~exist('index0','var') )
    error('2. Parameter index0 fehlt')
  end
  if( ~exist('word','var' ) )
      error('3. Parameter zu suhendes word fehlt')
  end
  if( ~exist('regel','var') )
    low = 0;
  elseif( isempty(regel) || ~ischar(regel) )
    low = 0;
  elseif( regel(1) == 'l' )
    low = 1;
  else
    low = 0;
  end
      
  

  i0 = max(1,min(index0,length(text_string)));
  n = length(text_string);
  

  index = 0;
  
  while( i0 <= n )
    
    [tt,i] = str_find_word_index_f(text_string,i0,'v');
    
    if( i == 0 )
      break;
    end
    
    if( low )
      
      if( strcmpi(tt,word) )
        index = i;
        break;
      end
      
    else
      
      if( strcmp(tt,word) )
        index = i;
        break;
      end
      
    end
      
    i0 = i + length(tt);
    
    
  end

end        
    
    
    