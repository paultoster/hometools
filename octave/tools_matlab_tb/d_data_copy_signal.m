function [d,u,c] = d_data_copy_signal(d,u,c,sig_src,sig_trg,unit_trg,comment_trg,copyifnot,set_zero)
%
% [d,u,c] = d_data_new_signal(d,u,c,sig_src,sig_trg,unit_trg[,comment_trg,copyifnot,set_zero])
%
% copyifnot   = 1  copy signal if does not exist (default 0)
% set_zero    = 1  set vector zero with time*0.0(default 0)
%
  if( ~exist('comment_trg','var') )
    comment_trg = '';
  end
  if( ~exist('copyifnot','var') )
    copyifnot = 0;
  end
  if( ~exist('set_zero','var') )
    set_zero = 0;
  end
  
  if( ~copyifnot || ~isfield(d,sig_trg) )
      if( isfield(d,sig_src) )
        [fac,offset] = get_unit_convert_fac_offset(u.(sig_src),unit_trg);

        d.(sig_trg) = d.(sig_src) * fac + offset;
        u.(sig_trg) = unit_trg;
        c.(sig_trg) = comment_trg;
      elseif(set_zero)
        if( ~isfield(d,'time') )
          error('%s: d.%s ist zum kopieren nicht vorhanden',mfilename,'time')
        end
        d.(sig_trg) = d.('time')*0.0;
        u.(sig_trg) = unit_trg;
        c.(sig_trg) = comment_trg;
      else
        error('%s: d.%s ist zum kopieren nicht vorhanden',mfilename,sig_src)
      end
  end
end
