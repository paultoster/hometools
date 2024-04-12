function okay = figure_proof_if_line(line_obj)
%
% okay = figure_proof_if_line(line_obj)
%
% proofs if line object is line
%
  okay = 0;
  h = findobj('type','line');
  
  for i=1:length(h)
    if( h(i) == line_obj )
      okay = 1;
      return
    end
  end
end