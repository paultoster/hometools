function [path_okay,q] = wand_cm_erg_to_mat(q)
%
% [okay,read_meas_path] = wand_cm_erg_to_mat(q)
%
% Wandelet erg-Files aus IPG-Simulation in Mat-File mit dennotwendigen
% Signalen
%
% q.file_list         cell array liste mit Ergebnissefiles
% q.read_meas_path    wenn kein file_list vorhanden, dann meas_path angeben
%                     ansosnten wird Pfad erfragt (bei start_dir)
% q.star_dir          Startverzeichnis
% q.use_start_dir     1: benutze Info
%                     0: nenutze nicht
%
% q.if_no_mat         Keine Wandlung, wenn schon vorhanden
% q.save_type         'mat_duh'     Mat-Format d,u,h -Struktur (default)
%                     'mat_dspa'    Mat-Format-DSpace-Format
%                     
% q.add_to_save_file_name  = '';    diesen Namen an den Savenamen anhängen
%
% q.index_start = 1   Index Start
% q.index_end = -1    Index Start
% q.tstart = -1.;     startzeit (default -1.)
% q.tend = -1.;       endzeit (default -1.)
% q.zero_time = 1;    Zeit nullen 
%
% q.delta_t = 0.01;   Zeitschritt
%
% q.cell_sig_list     cell-array mit signameliste:
%
%                     % Liste mit Signalen und Wandlung (normal und mehere Möglichk.)
%                     % ,{ {typ1,name1,unit1,lin1,name_sign1}...
%                     %  , {typ2,{name2,name2alt},unit2,lin2,name_sign2}...
%                     %  , ...
%                     %  , {Ausgabe,name,unit,comment}...
%                     %  } ...
%                     %  Wenn gleiche Signale für alle vier Räder
%                     % ,{ {typ1,name1<i1,i2,i3,i4>,unit1,lin1,name_sign1}...
%                     %  , ...
%                     %  , {Ausgabe,name<A,B,C,D>,unit,comment}...
%                     %  } ...
%                     %  z.B.
%                     % cell_sig_list= ...
%                     % {{ {'can','time','s',0,''}...             
%                     %  , {'ipg','time','s',1,''}...
%                     %  , {'out','time','s','Zeitvektor'}...
%                     %  } ...
%                     % ,{ {'can','VehSpd',1/3.6,0,0,''}...
%                     %  , {'ipg','Car_v',1,0,1,''}...
%                     %  , {'out','vVeh','m/s','Fahrzeuggeschwindigkeit'}...
%                     %  } ...
%                     %    alter und neuer Name, z.B. wenn alte Messungen verwendet werden
%                     %  ,{ {'can',{'VehSpd','vVeh'},1/3.6,0,0,''}...
%                     %  , {'ipg','Car_v',1,0,1,''}...
%                     %  , {'out','vVeh','m/s','Fahrzeuggeschwindigkeit'}...
%                     %  } ...
%                     %  ,{ {'can','none','rad',1,''}...                         
%                     %  , {'ipg','Car_WheelSpd_<FL,FR,RL,RR>','rad/s',1,''}...
%                     %  , {'out','OmegaWh<Fl,Fr,Rl,Rr>','rad/s','Raddrehgeschwindigkeit '}...
%                     %  } ...  
%                     

  if( ~exist('q','var') )
    q = [];
  end
  
%   % Fahrzeug-Type
%   if( ~isfield(q,'fzg_type') )
%    
%     q.fzg_type = 1;        % 0: BMW: Can1:FahrzeugCan Can2: PrivateVPUCan
%                            % 1: Passat CC: Can1:FahrzeugCan Can2: PrivateVPUCan
%   end
  
  % fest vorgegebene Liste mit Files
  if( ~isfield(q,'file_list') || isempty(q.file_list) )   
    q.file_list = {};
  end
    
  % start-DIr
  if( ~isfield(q,'start_dir') || isempty(q.start_dir) )
    q.start_dir = 'D:\';
  end
  
  if( ~isfield(q,'use_start_dir') )
    q.use_start_dir = 1;
  end

  path_okay = 0;
  if( ~isempty(q.file_list) )
    path_okay = 1;
  else
    if( ~isfield(q,'read_meas_path') || isempty(q.read_meas_path))

      % Path auswählen
      %---------------
      s_frage.comment   = 'Pfad mit den Simulationen auswählen';
      if( q.use_start_dir )
        s_frage.start_dir = q.start_dir;
      end
      [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
      if( path_okay )
        q.read_meas_path = c_dirname{1};
      end
    else
      if( exist(q.read_meas_path,'dir') )
        path_okay = 1;
      end
    end
  end  
                         
  % Nur wandeln, wenn kein matfile vorhanden
  %-----------------------------------------
  if( ~isfield(q,'if_no_mat') )
    q.if_no_mat = 0;
  end
  
  % Save-Type
  %==========
  if( ~isfield(q,'save_type') )
    q.save_type = 'mat_duh';   % 'mat_dspa'    Mat-Format-DSpace-Format
                               % 'mat_duh'     Mat-Format d,u,h -Struktur 
  end
  
  if( ~isfield(q,'add_to_save_file_name') )
    q.add_to_save_file_name = '';
  end
  
  % Ausschnitt bearbeiten
  %----------------------
  if( ~isfield(q,'index_start') )
    q.index_start = 1;
  end
  if( ~isfield(q,'index_end') )
    q.index_end   = -1.;
  end
  if( ~isfield(q,'tstart') )
    q.tstart = -1.;
  end
  if( ~isfield(q,'tend') )
    q.tend   = -1.;
  end
  if( ~isfield(q,'zero_time') )
    q.zero_time   = 1;
  end
  %  Zeit bei null beginnen lassen
  
  if( ~isfield(q,'zero_time') )
    q.zero_time = 1;
  end
  
  % Zeitschritt
  %------------
  if( ~isfield(q,'delta_t') )
    q.delta_t = 0.02;
  end
  

  % Signalliste
  %------------
  if( ~isfield(q,'cell_sig_list') )
    q.Ssig = [];
  else
    q.Ssig = wand_cm_erg_to_mat_set_sig_liste('ipg',q.cell_sig_list);
  end
  
  % Start
  %======
  if( path_okay )
    
    if( ~isempty(q.file_list) )
      mess_files = suche_files_f(q.file_list,'erg',1,1);
    else

      mess_files = suche_files_f(q.read_meas_path,'erg',1);
    end
    if( isempty(mess_files) )
      warning('Keine erg-Simdaten in Pfad: <%s> enthalten\',read_meas_path);
    else
    
      i = 1;
      fail = 0;
      while(i <= length(mess_files) )
      
         mat_mess_file = wand_cm_erg_to_mat_build_mat_mess_file_name(mess_files(i).full_name);
        % Wenn q.if_no_mat = 0, wird immer gewandelt
        % ist q.if_no_mat = 1 dann wird gewandelt, wenn mat_mess_file nicht
        % existiert
        %------------------------------------------------------------------
        if( ~q.if_no_mat || ~exist(mat_mess_file,'file') )
          
          % Sim-Daten lesen
          [d,u,c,h] = read_cm_erg_and_filter(mess_files(i).full_name,q);

          % Daten nachträglich bearbeiten
          %-------------------------------------
          [d,u,c] = d_data_add_known_name_signals(d,u,c);
% 
%           if( exist('mod_data.m','file') )
%             [d,u,c] = mod_data(d,u,c,q);
%           end

          h{length(h)+1} = [mess_files(i).body,'/IPG'];
          h{length(h)+1} = c;

          if( ~isempty(d) )

            % Matlab-File speichern
            %----------------------
            h{length(h)+1} = c;

             if( ~isempty(q.add_to_save_file_name) )
              mfile = suche_files_f(mat_mess_file,'',1,1);
              mat_mess_file = fullfile(mfile(1).dir,[mfile1(i).body,q.add_to_save_file_name,'.mat']);
            end
            q.mat_file{i} = mat_mess_file;

            switch(q.save_type)
              case 'mat_dspa'

                okay = d_data_save(q.mat_file{i},d,u,h,'dspa');
                fprintf('Mat-Ausgabe-Datei dspa-Format: <%s>\n========================================================================================================\n' ...
                        ,q.mat_file{i});
              case 'mat_duh'

                okay = d_data_save(q.mat_file{i},d,u,h,'duh');
                fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n' ...
                        ,q.mat_file{i});
              otherwise
                fprintf('Kein gültiges Format für <%s>\n========================================================================================================\n' ...
                        ,q.mat_file{i});

            end       
          end


          clear d u h S
          pause(1.0)
        
%         okay = iqf_prepare_tacc_mess_check_data(mat_mess_file,q.Ssig);
%         if( okay )
%           i = i+1;
%           fail = 0;
%         else
%           fail = fail + 1;
%           if( fail > 3 )
%             error('iqf_prepare_tacc_mess: Messung dreimal eingelesen, Daten stimmen nicht')
%           end
%         end
        end
      i = i+1;
      end
    end
  end
end
function okay = iqf_prepare_tacc_mess_check_data(full_name,S)

  
  [okay,d,u,h] = d_data_read_mat(full_name);
  
  c_text = fields(d);
  
  n = 0;
  for i=1:length(S)
    
    if( S(i).notwendig )
      n = n +1;
      c_such{n} = S(i).name_out;
    end
  end
  for i=1:n
    
    ifound = cell_find_f(c_text,c_such{i},'f');
    
    if( isempty(ifound) )
      
      okay = 0;
    end
  end
end
function S = wand_cm_erg_to_mat_set_sig_liste(type,clist)

  S = struct;
  iScount = 0;
  
  % Schleife über alle Signale
  %---------------------------
  for i=1:length(clist)
    
    citem = clist{i};
    % Suche nach type und 'out'
    iout  = 0;
    itype = 0;
    for j=1:length(citem)
      ccitem = citem{j};
      if( ischar(ccitem{1}) )
        if( strcmpi(ccitem{1},type) )
          itype = j;
        elseif( strcmpi(ccitem{1},'out') )
          iout = j;
        end
      end
    end
    if( itype && iout )
      
      % items überprüfen
      %-----------------
      if( length(citem{itype}) < 5 )
        if( ischar(citem{itype}{2}) )
          t = citem{itype}{2};
        elseif( iscell(citem{itype}{2}) )
          t = citem{itype}{2}{1};
        else
          t = 'nicht_defnierter_name';
        end
         error('In Cell-Liste der %ite Listenwert mit type <%s> (name:%s) besitzt keine 5 Werte (type,name,einheit,lin,sig_name)',i,t,citem{itype}{2});
      end
      if( length(citem{iout}) < 4 )
        error('In Cell-Liste der %ite Listenwert mit type <out> (name:%s) besitzt keine 4 Werte (type,name,einheit,comment)',i,citem{iout}{2});
      end
      if( ~iscell(citem{itype}{2}) )
        citem{itype}{2} = {citem{itype}{2}};
      end
      for k=1:length(citem{itype}{2});
        if( ~strcmpi(citem{itype}{2}{k},'none') )
          
          wheel_names_in  = str_get_quot_f(citem{itype}{2}{k},'<','>','i');
          if( isempty(wheel_names_in) )
            iScount = iScount + 1;
            S(iScount).name_out     = citem{iout}{2};
            S(iScount).unit_out     = citem{iout}{3};
            S(iScount).comment      = citem{iout}{4};
            S(iScount).name_in      = citem{itype}{2}{k};
            S(iScount).unit_in      = citem{itype}{3};
            S(iScount).lin_in       = citem{itype}{4};
            S(iScount).name_sign_in = citem{itype}{5};
          else
            wheel_names_in  = wheel_names_in{1};
            [name_list_in,ncount_in] = str_split(wheel_names_in,',');
            
            wheel_names_out = str_get_quot_f(citem{iout}{2},'<','>','i');
            if( ~isempty(wheel_names_out) )
              wheel_names_out = wheel_names_out{1};
            end
            [name_list_out,ncount_out] = str_split(wheel_names_out,',');
            
            if( ncount_in ~= ncount_out )
              error('Error: Für die EIngabeGröße <%s> mit n=%i Variationen, hat die Ausgabe <%s> nur n=%i Werte' ...
                   ,citem{itype}{2}{k},ncount_in,citem{iout}{2},ncount_out);
            end
              
            i0_in  = str_find_f(citem{itype}{2}{k},wheel_names_in,'vs')-1;
            i0_out = str_find_f(citem{iout}{2},wheel_names_out,'vs')-1;
            
            tin  = str_cut_index(citem{itype}{2}{k},i0_in,length(wheel_names_in)+2);
            tout = str_cut_index(citem{iout}{2},i0_out, length(wheel_names_out)+2);
            
            for i=1:ncount_out
              name_in  = str_insert_index(tin,i0_in-1,name_list_in{i});
              name_out = str_insert_index(tout,i0_out-1,name_list_out{i});
              iScount = iScount + 1;
              
              S(iScount).name_out     = name_out;
              S(iScount).unit_out     = citem{iout}{3};
              S(iScount).comment      = citem{iout}{4};
              S(iScount).name_in      = name_in;
              S(iScount).unit_in      = citem{itype}{3};
              S(iScount).lin_in       = citem{itype}{4};
              S(iScount).name_sign_in = citem{itype}{5};
            end
          end
        end
      end
    end
  end
          
end
function mat_file = wand_cm_erg_to_mat_build_mat_mess_file_name(mess_file)


% matlab-name bilden
%-------------------
s_file = str_get_pfe_f(mess_file);

if( strcmp(s_file.name,'canlog') ) 
    [c_names,ncount] = str_split(s_file.dir,'\');
    name = 'mat_out';
    for i=ncount:-1:1
        if( ~isempty(c_names{i}) )
            name = c_names{i};
            break;
        end
    end
    mat_file = [s_file.dir,name,'.mat'];
else
    mat_file = [s_file.dir,s_file.name,'.mat'];
end
end