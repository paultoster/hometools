function fname        = get_file_name(filename,type)
%
% fname        = get_file_name(filename,type)
%
% Gibt den Datei-Namen ohne Pfad zurück
% type = 0 (default) voller name mit ext
% type = 1 nur body
%
  if( ~exist('type','var') )
    type = 0;
  end
  s_file = str_get_pfe_f(filename);
  if( type == 0 )
    fname    = str_cut_ae_f(s_file.filename,' ');
  else
    fname    = str_cut_ae_f(s_file.name,' ');
  end
end