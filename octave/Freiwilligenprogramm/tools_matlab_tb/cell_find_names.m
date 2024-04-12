function [cold,cnew] = cell_find_names(cnames,name_old,name_new)
%
% [cold,cnew] = cell_find_names(cnames,name_old,name_new)
%  cliste     = cell_find_names(cnames,names)
%
% z.B.
% [cold,cnew] = cell_find_names({'abc_d','abc_e'},'abc_*','123_*')
% cold = { 'abc_d' ,  'abc_e' }
% cnew = { '123_d'  , '123_e' }
% z.B.
% cliste = cell_find_names({'abc_d','abc_e'},'abc_*')
% cliste = { 'abc_d' ,  'abc_e' }


  if( ischar(cnames) )
    cnames = {cnames};
  end
  
  if( ~exist('name_new','var') )
    new_name_flag = 0;
  else
    new_name_flag = 1;
  end
  
  cold = {};
  cnew = {};
  
  ifound = str_find_f(name_old,'*','vs');
  iend   = length(name_old);
  if( ifound == 1 )
    name_old_body_start    = '';
    name_old_body_end      = name_old(2:end);
    multiname              = 1;        
  elseif( ifound == iend )
    name_old_body_start    = name_old(1:ifound-1);
    name_old_body_end      = '';
    multiname              = 1;        
  elseif( ifound > 1 )
    name_old_body_start    = name_old(1:ifound-1);
    name_old_body_end      = name_old(ifound+1:end);
    multiname        = 1;
  else
    multiname     = 0;
    name_old_body_start    = name_old;
    name_old_body_end      = '';
  end
  ll_name_old_body_start = length(name_old_body_start);
  ll_name_old_body_end   = length(name_old_body_end);

  if( new_name_flag )
    ifound = str_find_f(name_new,'*','vs');
    iend   = length(name_new);
    
    if( ifound == 1 )
      name_new_body_start    = '';
      name_new_body_end      = name_new(2:end);
    elseif( ifound == iend )
      name_new_body_start    = name_new(1:ifound-1);
      name_new_body_end      = '';
    elseif( ifound > 1 )
      name_new_body_start    = name_new(1:ifound-1);
      name_new_body_end      = name_new(ifound+1:end);    
    end
    
  end
  
  if( multiname )
        
    for i=1:length(cnames)
      ll_name = length(cnames{i});
      
      if( (cnames{i}(1) == 'T') && (cnames{i}(2) == 'P') )
        a =0;
      end
      [found,i0,i1] = cell_find_names_find(cnames{i},ll_name,name_old_body_start,ll_name_old_body_start,name_old_body_end,ll_name_old_body_end);
      
      if( found )
        
        if( i0 == 0 )
          add_name = cnames{i}(1:i1-1);
        elseif( i1 == 0 )
          add_name = cnames{i}(i0+ll_name_old_body_start:end);
        else
          if( ll_name == ll_name_old_body_start+ll_name_old_body_end )
            add_name = '';
          else % i0 && i1
            add_name = cnames{i}(i0+ll_name_old_body_start:i1-1);
          end
        end
      
        cold = cell_add(cold,cnames{i});
        if( new_name_flag )
          cnew = cell_add(cnew,[name_new_body_start,add_name,name_new_body_end]);
        else
          cnew = cell_add(cnew,cold);
        end
      end
    end
    
    
  else

    ifound  = cell_find_f(cnames,name_old,'f');
    if( ~isempty(ifound) )
      cold = cell_add(cold,cnames{ifound(1)});
      if( new_name_flag )
        cnew = cell_add(cnew,name_new);
      else
        cnew = cold;
      end
    end
  end

  end
  function [found,i0,i1] = cell_find_names_find(name,ll_name,body_start,ll_body_start,body_end,ll_body_end)
    found = 0;    
    if( ll_body_start )
      i0      = str_find_f(name,body_start,'vs');
      if( i0 == 1 )
        found0 = 1;
      else
        found0 = 0;
      end
    else
      i0     = 0;
      found0 = 1;
    end
    if( ll_body_end )
      i1      = str_find_f(name,body_end,'rs');
      if( i1+ll_body_end-1 == ll_name )
        found1 = 1;
      else
        found1 = 0;
      end
    else
      i1 = 0;
      found1 = 1;
    end
    
    if( found0 && found1)
      found = 1;
    end
  end
    