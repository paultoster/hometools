function [d,u,h, okay] =ccmread(varargin)
%
% Wenn aus einem CarMaker-Projekt ausgelesen werden soll
% [d,u,h,okay] = ccmread('project_path','D:\ipg\ggg');
%
% Wenn man direkt aus einem Pfad mit Ergebnissen auslesen will
% [d,u,h,okay] = ccmread('erg_path','.');
%
% Wenn man direkt ein File mit Ergebnissen auslesen will
% [d,u,h] = ccmread('erg_file','D:\IPG\CContiguard\SimOutput\FRLXNJ0D\20110606\BadCambergL_3030_134744.erg');
%
%
% Läd Ergebinsfiles von carmaker ein im duh-Format
% d struktur mit Datenvektoren Zeitvektor 
%
% Zusätzlich kann eine Signalnamenliste mit runtergegeben werden,
% die dann Signale aus dieser Liste und 'time' einläd
% Ist sie nichtvorhanden oder leer {}, dann werden alle gelesen
% [d,u,h,okay] = ccmread(...,'sig_name_list',{'Vref','ASoll','THand'});
%
  addpath('C:\LegacyApp\IPG\hil\win32-6.0.5\Templates\Car\src');
  okay = 1;
  d = [];
  u = [];
  h = {};
  project_path  = '';
  erg_path      = '';     %pwd;
  erg_file      = '';
  sig_name_list = {};
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'project_path','projectpath'};
              project_path = varargin{i+1};
          case {'erg_path','ergpath'};
              erg_path = varargin{i+1};
          case {'erg_file','ergfile'};
              erg_file = varargin{i+1};
          case {'sig_name_list','signamelist'};
              sig_name_list = varargin{i+1};
          otherwise
              error('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i}); 

      end
      i = i+2;
  end


  %
  % Projekt Pfad/ Ergebnispfad
  %===========================
  if( isempty(erg_file) )
    if( isempty(project_path) )

      if( isempty(erg_path) )

        % Projekt auswählen
        %------------------
        s_frage.comment = 'Wähle Projekt-Pfad einer CarMaker-Simulation aus';
        [okay,c_dirname] = o_abfragen_dir_f(s_frage);
        if( ~okay )
          warning('%s: Es konnte kein Projekt-Pfad ausgewählt werden',mfilename);
          okay = 0;
          return
        end
        project_path = c_dirname{1};
        erg_path     = fullfile(project_path,'SimOutput');
      end
      if( ~exist(erg_path,'dir') )
        warning('%s: Ergebnis-Pfad <%s> kann nicht gefunden werden',mfilename,erg_path);
        okay = 0;
        return
      end

    else

      if( ~exist(project_path,'dir') )
        warning('%s: Projekt-Pfad <%s> kann nicht gefunden werden',mfilename,project_path);
        okay = 0;
        return
      else
        erg_path     = fullfile(project_path,'SimOutput');
        if( ~exist(erg_path,'dir') )
          warning('%s: Ergebnis-Pfad <%s> kann nicht gefunden werden',mfilename,erg_path);
          okay = 0;
          return
        end
      end
    end
  else
     s = str_get_pfe_f(erg_file);
    
    if( isempty(s.ext) )
      search_file = [s.name,'.erg'];
    else
      search_file = [s.name,'.',s.ext];
    end
    search_dir = s.dir;
    
    if( isempty(project_path) )
      
      isuch = str_find_f(search_dir,'SimOutput','vs');
      if( isuch > 0 )
        project_path = search_dir(1:isuch-2);
      end
    end
    
  end  
  % set path eintragen un cmenv ausführen
  %
  if( ~isempty(project_path) )
      src_cm4sl_path = fullfile(project_path,'src_cm4sl');
      addpath(src_cm4sl_path);
      cmenv;
      % Projektfad anzeigen
      %====================
      fprintf('\n[d,u,h,okay] = ccmread(''project_path'',''%s'');\n',project_path);
  end
  
  
  % Ergebnisdatei
  %==============
  if( ~isempty(erg_file) )
    
    
    if( ~isempty(search_dir) )
      file_list = suche_one_file_f(search_dir,search_file,1);
    else
      file_list = suche_one_file_f(erg_path,search_file,1);
    end
    
    if( length(file_list) > 1 )
      fprintf('mehrere Dateien gefunden:\n')
      for i=1:length(file_list)
        fprintf('<%s>\n',file_list(i).full_file)
      end
      warning('%s: Mehrere Dateien gefunden (siehe oben)',mfilename);
      okay = 0;
      return
    end
    if( ~exist('cmread') )
      try
        cmenv
      catch
        error('cmenv kann nicht aufgerufen werden')
      end
    end
    if( isempty(file_list) )
      
      a = cmread(erg_path);
    else
      a = cmread(file_list(1).full_name);
      %====================
      fprintf('[d,u,h,okay] = ccmread(''erg_file'',''%s'');\n',file_list(1).full_name);
      fprintf('\nDatei: <%s>\n',file_list(1).full_name);

    end
  else
    a = cmread(erg_path);
  end

  if( ~isempty(a) )
  
    [okay,d,u,h] = data_transform_carmaker_to_duh_f(a,sig_name_list);
    
    if( ~okay )
      d = [];
      u = [];
      h = {};
    end
  end
end