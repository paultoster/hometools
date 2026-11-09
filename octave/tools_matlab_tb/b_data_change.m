function b  = b_data_change(b,type,par1,par2)
%
% b  = b_data_change(b,type,par1,par2)
%
%==========================================================================
% type = 1:  change channel
%
% b  = b_data_change(b,1,channel_list_search,channel_lsit_replace)
%
% z.B. b  = b_data_change(b,1,[1,2],[3,4])
% Nimmt die Messs-Struktur c und wechselt Channel 1 -> 3 und 2 -> 4
%
  if( ~data_is_bstruct_format_f(b) )
    error('%s: b hat nicht das richtige Datenformat b.time(i), b.id(i), b.channel(i), b.len(i), b.byte0(i), ...  b.byte7(i), d.receive(i)',mfilename);
  end
  
  if( type == 1 )
    
    if( ~exist('par1','var') )
      error('%s: type = 1,change chnnel, channel_list_search(par1) not in par-list',mfilename)
    else
      chan_s = par1;
    end
    if( ~exist('par2','var') )
      error('%s: type = 1,change chnnel, channel_list_replace(par2) not in par-list',mfilename)
    else
      chan_r = par2;
    end
    
    b_n      = length(b.time);
    chan_n = min(length(chan_s),length(chan_r));
    
    for i = 1:b_n
      for j=1:chan_n
        if( b.channel(i) == chan_s(j) )
          b.channel(i) = chan_r(j);
        end
      end
    end
 
  else
    error('%s type = %i ist nicht programmiert',mfilename,type)
  end
end  