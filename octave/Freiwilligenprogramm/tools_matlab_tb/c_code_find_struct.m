function s = c_code_find_struct(t,structname,nameofstruct)
%
% s = c_code_find_struct(t,structname)
% s = c_code_find_struct(t,structname,nameofstruct)
%
% find in code struct definition with structname
% Wenn nameofstruct mit angegeben, dannn s(i).varname = nameofstruct.structvaribale
%
% s(i).varname         variable name
% s(i).type            typedefinition (real_t,float,uint32, ...)
%

  if( exist('nameofstruct','var') )
    vflag = 1;
  else
    vflag = 0;
  end
  
  s = struct([]);
  ns = 0;
  t = c_code_erase_comment(t);
  ivec = strfind(t,structname);
  
  for i=1:length(ivec)
    
    okay = 1;
    
    index  = ivec(i)+length(structname); % first index after struct name
    % vorwaerts suchen
    [w,i0]     = str_find_next_item_f(t,index,'v');
    
    if( w(1) == '{' )  % struct name {.....};
      
      istart = i0;
      % suche ende
      index = str_find_index_f(t,istart,'a','}','{');
      
      if( index == 0 )
        okay = 0; % nicht gefunden
      else
      
        [w,~] = str_find_next_item_f(t,ivec(i)-1,'r');
        if( str_find_f(w,'struct') == 0 )
         okay = 0; 
        else
          koerper = t(istart+1:index-1);
        end
      end
    else % typedef struct {.....} name;
      % rückwaerts suchen
      index = ivec(i)-1;
      if( index == 0 )
        okay = 0; % nichts gefunden
      else
        [w,i0] = str_find_next_item_f(t,index,'r');
      
        if( w(end) == '}' )
          % suche Anfang
          iend = i0 + length(w) - 1;
          index = str_find_index_f(t,iend,'b','{','}');
          if( index == 0 )
            okay = 0; % nicht gefunden
          else
            [w,~] = str_find_next_item_f(t,index-1,'r');
            if( str_find_f(w,'struct') == 0 )
             okay = 0; 
            else
              koerper = t(index+1:iend-1);
            end
          end
        else
          okay = 0; % nichts gefunden
        end
      end
    end
    
    if( okay ) % something found
      [c,n] = str_split(koerper,';');
      for i=1:n
        tt = str_cut_ae_wspace(c{i});
        if( ~isempty(tt) )
          
          n     = length(tt);
          [var,i0] = str_find_word_index_f(tt,n,'ra');  
          i0       = str_find_next_wspace_f(tt,i0-1,'rn');
          ty       = tt(1:i0);
          if( vflag )
            var = sprintf('%s.%s',nameofstruct,var);
          end
          if( ns == 0 )
            s = struct('type',ty,'varname',var);
            ns = 1;
          else
            ns = ns+1;
            s(ns).type    = ty;
            s(ns).varname = var;
          end
        end
      end
    end
  end
end

% index = str_find_index_f(t,istart,'a','}','{');