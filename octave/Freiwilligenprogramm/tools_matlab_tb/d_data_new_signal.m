function [d,u,c] = d_data_new_signal(d,u,c,sig_in,sig_new,unit_new,comment_new,set_zero)
%
% [d,u,c] = d_data_new_signal(d,u,c,sig_in,sig_new,unit_new[,comment_new,set_zero])
%
% set_zero   = 1  make new signal if sig_in is not available (default=0)
%
  if( ~exist('comment_new','var') )
    comment_new = '';
  end
  if( ~exist('set_zero','var') )
    set_zero = 0;
  end
  
  if( isfield(d,sig_in) )
    [fac,offset] = get_unit_convert_fac_offset(u.(sig_in),unit_new);
   
    d.(sig_new) = d.(sig_in) * fac + offset;
    u.(sig_new) = unit_new;
    c.(sig_new) = comment_new;
  elseif( set_zero )
    if( isfield(d,'time') )
      d.(sig_new) = d.('time')*0.0;
    else
      c = fieldnames(d);
      if( ~isempty(c) )
        d.(sig_new) = d.(c{1});
      else
        d.(sig_new) = 0.0;
      end
    end
    u.(sig_new) = unit_new;
    c.(sig_new) = comment_new;
  end
end
