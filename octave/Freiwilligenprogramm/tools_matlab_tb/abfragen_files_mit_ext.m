function c_liste =abfragen_files_mit_ext(q)
%
%  Abfragen nach Dateien mit bestimmter extension
%  a) aus einem directoy, b dir mit allen unter-dirs, c) eintzelne Dateien
%
%  q.read_type = 1      a) dir mit allen Unter-dirs auswaehlen
%              = 2      b) nur dir 
%              = 3      c) einzelne Dateien
%  q.start_dir          Startverzeichnis zum suchen
%  q.files_spec         *.abc extension, aber auch '*.jpg;*.tiff'
%
  c_liste = {};
  if( ~check_val_in_struct(q,'read_type','num',1) )

    s_frage.c_liste  = {'Dir auswaehlen','Dir mit Sub-Dirs auswaehlen','Dateien auswaehlen'};
    s_frage.frage    = ' Welche Option für Datenauswahl';
    s_frage.single   = 1;
    [okay,q.read_type] = o_abfragen_listbox_f(s_frage);  
  end

  if( ~check_val_in_struct(q,'start_dir','char',1) || ~exist(q.start_dir,'file') )

    c = getdrives;
    q.start_dir = c{1};
  end

  if( ~check_val_in_struct(q,'files_spec','char',1) )
    q.files_spec = '*.*';
  end

  if( (q.read_type == 1) || (q.read_type == 2) )
    clear s_frage
    s_frage.comment = 'Verzeichnis auswählen';
    s_frage.start_dir = q.start_dir;
    [okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( okay )
      if( q.read_type == 1 )
        file_list = suche_files_f(c_dirname{1},q.files_spec,1,0);
      else
        file_list = suche_files_f(c_dirname{1},q.files_spec,0,0);
      end
      for i=1:length(file_list)
        c_liste = cell_add(c_liste,file_list(i).full_name);
      end
    else
      return
    end
  else
    clear s_frage
    s_frage.comment     = 'Dateien auswählen';
    s_frage.file_spec   = q.files_spec;
    s_frage.start_dir   = q.start_dir;
    [okay,c_liste]  = o_abfragen_files_f(s_frage);

  end
end