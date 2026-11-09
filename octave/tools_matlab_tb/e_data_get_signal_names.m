function cnames = e_data_get_signal_names(e,part_of_signame,on_screen)
%
% cnames = e_data_get_signal_names(e,part_of_signame)
% cnames = e_data_get_signal_names(e,part_of_signame,on_screen)
%
% get from e-structure all signalnames containing part_of_signame
% 
% 
%    e-structure
%
%    e.('signame').time    zeitvektor
%    e.('signame').vec     Wertevektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%    e.('signame').lin     1 linear interpolieren
%                          0 konstant interpolieren
%    e.('signame').leading_time_name    Damit wird alle mit diesem Namen
%                                       versehenen Vektoren mit dieser Zeitbasis aus e gleich in d-STruktur
%                                       gewandelt
%
%    part_of_signame       char         part of the to search signal names
%    on_screen             0/1          (default 0) print on screen
%

  if( ~exist('on_screen','var') )
    on_screen = 0;
  end
  
  signames = fieldnames(e);
  iliste = cell_find_f(signames,part_of_signame,'n');
  
  cnames = {};
  for i=1:length(iliste)
    cnames = cell_add(cnames,signames{iliste(i)});
  end
  
  if( on_screen )
    fprintf('Signal-Names:\n');
    for i=1:length(cnames)
      fprintf('%3.3i: %s\n',i,cnames{i});
    end
  end
  
end
  