function  okay = d_data_proof_format(d)
%
% okay = d_data_proof_format(d)
% 
% proof if struct and has one Vektor
okay = 0;
if( isstruct(d) )
  cnames = fieldnames(d);
  for i=1:length(cnames)
    if( isnumeric(d.(cnames{i})) && (length(d.(cnames{i})) > 1 ) )
      okay = 1;
      break;
    end
  end
end
                       