function [okay,errtext] = build_dir(dirname,stopbyerr)
%
% [okay,errtext] = build_dir(dirname,stopbyerr)
%
% dirname   string mit Verzeichnis
% stopbyerr =1 (default) bei Fehler mir error() abbrechen
%           =0 nicht abbrechen Fehlertext ausgeben
% okay = 1  Verzeichnis existiert oder wurde gebildet
%      = 0  Fehler aufgetreten
% errtetx   Fehler text ausgabe
  okay = 1;
  errtext = '';
  if( ~exist('stopbyerr','var') )
    stopbyerr = 1;
  end
  if( ~exist(dirname,'dir') )
    [s, mess, messid] = mkdir(dirname);
    if( s == 0 )
      if( stopbyerr )
        error(mess);
      else
        okay = 0;
        errtext = mess;
      end
    end
  end
end
