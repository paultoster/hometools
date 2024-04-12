function [e,okay,errtext] = e_data_mat_canalyser_read(canmatfile,c_my_Ssig_files)
%
% [e,okay,errtext] = e_data_mat_canalyser_read(canmatfile,c_my_Ssig_files);
%
% e             e-Datenstruktur mit e.time,e.vec,e.lin
%
% canmatfile       char   Name des von Canalyser gewandelten mat-Files
% c_my_Ssig_files  cell/char   Name des m-Files, das die Ssig-Struktur bildet
%                              Ssig = c_my_Ssig_files;
%   Ssig(i).name_in      = 'signal name';
%   Ssig(i).unit_in      = 'dbc unit';              (default '')
%   Ssig(i).lin_in       = 0/1;                     (default 0)
%   Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%   Ssig(i).name_out     = 'output signal name';    (default name_in)
%   Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%   Ssig(i).comment      = 'description';           (default '')
%
% name_in      is name from dbc, could also be used with two and mor names
%              in cell array {'nameold','namenew'}, if their was an change
%              in dbc, use for old measurements
% unit_in      will used if no unit is in dbc for that input signal
% lin_in       =0/1 linearise if to interpolate to a commen time base
% name_sign_in if in dbc-File is a particular signal for sign (how VW
%              uses) exist
% name_out     output name in Matlab
% unit_out     output unit
% comment      description
  
  okay = 1;
  errtext = '';

  if( ~exist('canmatfile','var') )
    error('canmatfile ist nicht gegben')
  end
  if( ~exist('c_my_Ssig_files','var') )
    c_my_Ssig_files = {};
  end
  if( ischar(c_my_Ssig_files) )
    c_my_Ssig_files = {c_my_Ssig_files};
  end

  % Daten einlesen in Struktur
  s_read    = load(canmatfile);
  if( ~data_is_canalyser_format_f(s_read) ) % Canalyser
    error('Mat-Datei: %s ist keine Canalyser gewandelte Datei');
  end
  
  [e,okay] = e_data_mat_canalyser_read_wandle(s_read);
  
  n = length(c_my_Ssig_files);
  if( n == 0 )
    e = e_data_wandle_mit_Ssig(e,[],0);
  else
    for i = 1:n
      s_file = str_get_pfe_f(c_my_Ssig_files{i});
      if( ~isempty(s_file.dir) )
        org_dir = pwd;
        cd(s_file.dir);
        try
          Ssig = eval(s_file.name);
          cd(org_dir);
        catch exception
          cd(org_dir);
          throw(exception)
        end
      else
        try
          Ssig = eval(s_file.name);
        catch exception
          throw(exception)
        end
        
      end
      e = e_data_wandle_mit_Ssig(e,Ssig,0);
    end
  end
end
function [e,okay] = e_data_mat_canalyser_read_wandle(s_can)  
  okay = 1;
  e    = [];
  % Feldnamen bestimmen
  c_names = fieldnames(s_can(1));

  % empty-Vektoren bereinigen
  for ic = 1:length(c_names)
    
    if( ~isempty(s_can(1).(c_names{ic})) )
        s_can1.(c_names{ic}) = s_can(1).(c_names{ic});
    end
  end
  s_can   = s_can1;
  c_names = fieldnames(s_can);

  % Anzahl der Feldnamen prüfen
  clen = length(c_names);
  if( clen == 0 )
    okay = 0;
    return
  end


  for ic = 1:clen
    if( isnumeric(s_can(1).(c_names{ic})) )   
        [n,m] = size(s_can(1).(c_names{ic}));
        if( m == 2 )
            if( is_monoton_steigend(s_can(1).(c_names{ic})(:,1)) )
                if( length(s_can(1).(c_names{ic})(:,1)) > 1 )
                    e.(c_names{ic}).time  = s_can(1).(c_names{ic})(:,1);
                    e.(c_names{ic}).vec   = s_can(1).(c_names{ic})(:,2);
                    e.(c_names{ic}).unit  = '';
                end
            else
                warning('Zeitsignal des can-Signals <%s> ist nicht monoton steigend',c_names{ic});
            end
        end
    end
  end
end
