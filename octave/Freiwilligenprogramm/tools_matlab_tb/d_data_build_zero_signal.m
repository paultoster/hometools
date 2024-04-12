function [d,u,c] = d_data_build_zero_signal(d,u,c,signame_new,unit_new,comment_new)
%
% [d,u,c] = d_data_build_zero_signal(d,u,c,signame_new,unit_new[,comment_new])
%
% 
  if( ~isfield(d,signame_new) )
    if( ~exist('comment_new','var') )
      comment_new = '';
    end

    if( isfield(d,'time') )   
      d.(signame_new) = d.('time') * 0.0;
      u.(signame_new) = unit_new;
      c.(signame_new) = comment_new;
    else
      error('%s: d.time nicht vorhanden',mfilename);
    end
  end
end
