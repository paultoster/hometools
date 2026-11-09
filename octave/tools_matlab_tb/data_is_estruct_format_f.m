function  okay = data_is_estruct_format_f(s)                      

okay = 0;
if( isstruct(s) )
  if( isfield(s,'e') )
    e = s.e;
    okay = e_data_proof_format(e);
  end
end
                       