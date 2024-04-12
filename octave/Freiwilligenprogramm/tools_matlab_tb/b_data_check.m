function found  = b_data_check(b,type,par1,par2,par3)
%
% found  = b_data_check(b,type,par1,par2,par3)
%
%==========================================================================
% type = 1:  find message id without channel
%
% found  = b_data_check(b,1,id)
%
% z.B. found  = b_data_check(b,1,596)
% sucht, ob 596 (dec) mindestens einmal vorhanden
%
%--------------------------------------------------------------------------
% type = 2:  find message id with channel
%
% found  = b_data_check(b,1,id,channel)
%
% z.B. found  = b_data_check(b,1,596,1)
% sucht, ob 596 (dec) im channel 1 mindestens einmal vorhanden
%
  if( ~data_is_bstruct_format_f(b) )
    error('%s: b hat nicht das richtige Datenformat b.time(i), b.id(i), b.channel(i), b.len(i), b.byte0(i), ...  b.byte7(i), d.receive(i)',mfilename);
  end
  
  if( type == 1 )
    
    if( ~exist('par1','var') )
      error('%s: type = 1,find message id without channel: found  = b_data_check(b,1,id)',mfilename)
    else
      id = par1;
    end
  elseif( type == 2 )
    if( ~exist('par1','var') )
      error('%s: type = 1,find message id without channel: found  = b_data_check(b,1,id)',mfilename)
    else
      id = fix(par1);
    end
    if( ~exist('par2','var') )
      error('%s: type = 2,find message id with channel: found  = b_data_check(b,1,id,channel)',mfilename)
    else
      channel = fix(par2);
    end
  else
    error('%s type = %i ist nicht programmiert',mfilename,type)
  end
  
  found = 0;
  if( type == 1 )
    n      = length(b.time);    
    for i = 1:n
      if( id == b.id )
        found = 1;
        break;
      end
    end
  else
    n      = length(b.time);    
    for i = 1:n
      if( (id == b.id(i)) && (channel == b.channel(i) ) )
        found = 1;
        break;
      end
    end
  end

end  