function liste = c_code_find_function_names(t)
%
% cliste = c_code_find_function_names(txt)

  liste = {};

  t = c_code_erase_comment(t);
  
  flagrun = 1;
  index = 0;
  while(flagrun)
    
   % n�chsten Suche Funktionsrumpf
   index = str_find_index_f(t,index,'v','{');
   istart = index;
   
   if( index == 0 )
     % keine Funktion Ende
     flagrun = 0;
   else
     
     % Suche r�ckw�rts Parameter klammern '(',')'
     i = str_find_index_f(t,index,'d',')');
     
     if( i ) % klammer gefunden
       index = str_find_index_f(t,i,'r','(');       
%    else
%      index = index;
     end
     % ggehe eins ur�ck
     index = index - 1;
     % r�ckwaerts das n�chste wort
     [w,~]     = str_find_word_index_f(t,index,'r');
     
     if( isempty(w) )
       flagrun = 0;
     else
       liste = cell_add(liste,w);
       index = str_find_index_f(t,istart,'a','}','{');
     end
   end
  end
  
end