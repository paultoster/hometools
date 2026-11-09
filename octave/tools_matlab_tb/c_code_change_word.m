function [t,changed] = c_code_change_word(t,nameold,namenew)
%
% [t,changed] = c_code_change_word(t,nameold,namenew)
%
% change in strin t all full words with nameold into namenew
% changed = 1 means it was changed
%
  changed = 0;
  ivec = strfind(t,nameold);
  
  for i=1:length(ivec)
    
    [w,i0]     = str_find_word_index_f(t,ivec(i),'a');
    
    if( strcmp(w,nameold) )
      changed = 1;
      ll = length(w);
      t  = str_cut_index(t,i0,ll);
      i0 = i0-1;
      t  = str_insert_index(t,i0,namenew);
      ivec = strfind(t,nameold);
    end
  end
end