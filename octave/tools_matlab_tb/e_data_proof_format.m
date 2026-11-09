function okay = e_data_proof_format(e)
%
%  okay = e_data_proof_format(e);
%
% Proof if structur and e.name.time and e.name.vec or e.name.param exist
%
  okay = 0;
  if( isstruct(e) )
      cnames = fieldnames(e);
      name   = cnames{1};
      if( isstruct(e.(name)) && ...
          (  (isfield(e.(name),'time') && isfield(e.(name),'vec')) ...
          || isfield(e.(name),'param') ...
          ) ...
        )

          okay = 1;
      end
  end
    
end
