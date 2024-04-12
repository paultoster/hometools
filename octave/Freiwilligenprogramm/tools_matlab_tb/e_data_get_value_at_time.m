function [nlengthmax,nlengthmin,nlengthmean,nlengthstd] = e_data_get_value_at_time(e,signame)
%
% [nlengthmax,nlengthmin,nlengthmean,nlengthstd] = e_data_get_signal_max_vec_length(e,signame)
%
% if e.signame.vec is cellarray with vectors, then it calculates statistics
% of all vectors
% 
  nlengthmax=1;nlengthmin=1;nlengthmean=1;nlengthstd = 0;
  if( ~isfield(e,signame) )
    error('e.(%s) is not existend',signame);
  end
  if( e_data_is_timevec(e,signame) && e_data_is_vecinvec(e,signame) )
    n = length(e.(signame).vec);
    nvec = zeros(n,1);
    for i=1:length(e.(signame).vec)
      
      vec = e.(signame).vec{i};
      
      nvec(i) = length(vec);
    end
    nlengthmean = mean(nvec);
    nlengthstd  = std(nvec);
    nlengthmax  = max(nvec);
    nlengthmin  = min(nvec);
  end

end