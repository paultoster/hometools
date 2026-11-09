function ext        = get_file_ext(filename)
%
% ext        = get_file_ext(filename)
%
% Gibt extension des Files aus
%

  s_file = str_get_pfe_f(filename);
  
  ext    = str_cut_ae_f(s_file.ext,' ');
  if( ext(1) == '.' )
    if( length(ext) > 1 )
      ext = ext(2:length(ext));
    else
      ext = '';
    end
  end
end