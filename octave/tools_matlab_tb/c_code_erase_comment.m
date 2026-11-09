function t = c_code_erase_comment(t)
%
% t = c_code_erase_comment(t)
%
% erase from string t all comments
% 1) //.... \n
% 2) /* ... */
%

  flagrun = 1;
  while(flagrun)
    
    index = 0;
    i0 = str_find_index_f(t,index,'v','/*');
    
    if( i0 == 0 )
      flagrun = 0;
    else
      i1 = str_find_index_f(t,i0,'v','*/');
      if( i1 == 0 )
        i1 = length(t);
      end
      l  = (i1+1)-i0+1;
      t = str_cut_index(t,i0,l);
    end
  end
  
  flagrun = 1;
  while(flagrun)
    
    index = 0;
    i0 = str_find_index_f(t,index,'v','//');
    
    if( i0 == 0 )
      flagrun = 0;
    else
      i1 = str_find_index_f(t,i0,'v',sprintf('\n'));
      if( i1 == 0 )
        i1 = length(t)+1;
      end
      l  = i1-i0;
      t = str_cut_index(t,i0,l);
    end
  end
  
  
end
