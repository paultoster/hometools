function f        = change_file_ext(filename,ext,type)
%
% f        = change_file_ext(filename,ext,type);
%
% Prüft Filename auf extension und fügt sie an oder ersetzt
% type     = 0    fügt nur an, wenn nicht vorhanden (default)
%          = 1    nimmt in jeden Fall die Vorgabe ext
%
  if( ~exist('type','var')  )
    type = 0;
  end

  s_file = str_get_pfe_f(filename);
  
  ext    = str_cut_ae_f(ext,' ');
  if( ext(1) == '.' )
    if( length(ext) > 1 )
      ext = ext(2:length(ext));
    else
      ext = '';
    end
  end
  
  if( type ) 
    f = fullfile(s_file.dir,[s_file.name,'.',ext]);
  else
    if( isempty(s_file.ext) )
      f = fullfile(s_file.dir,[s_file.name,'.',ext]);
    else
      f = filename;
    end
  end
end