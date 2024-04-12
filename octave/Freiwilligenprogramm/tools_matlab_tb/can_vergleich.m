function [okay,st] = can_vergleich(ctl)
%
% function okay = can_vergleich(ctl)
%
% ctl.path        cellarray       Liste mit Pfaden die durchgescannt werden
%                                 die mit *_pbot.mat gewandelt wurden
%                                 {'D:\CAN_Messungen\Hybrid\GTIFSI\051118_0','D:\abc'};
% ctl.signal_lsite  cellarray       In der Liste steht eine Liste mit
%                                 Botschaftsname und Signalnamen
%                                 {{'Motor_1','MO1_sig1','MO1_sig2'},{'Motor_3','MO3_sig1','MO3_sig2'}}
%
% ctl.plt_flag      double       1: Jedes Signal aus signalliste wird gemeinsam mit allen Messungen geplottet
%                                0: kein Plot
% ctl.plt_dina4     double       Format dina4 längs:1, quer:2, normal:0
% ctl.plt_legend    char         'file','file_short','no'
% ctl.plt_title     char         Titel, der auf das Plot oben geschrieben
%                                wird
%
% Rückgabe
% st.signal(i).bot_name         Botschaftsname
% st.signal(i).sig_name         Signalname
% st.signal(i).mess(j).file     Dateiname
% st.signal(i).mess(j).time     Zeitvektor
% st.signal(i).mess(j).sig      Signalstruktur entsprechen pbot-Struktur siehe can_mess_pbot_aufbereiten
%                               z.B. st.signal(i).mess(j).sig.vec ist das Signal als Vektor passend zu time
%                               


okay = 1;

% Pfad bestimmen und Files sammeln
file_liste = {};

file_liste = can_vergleich_suche_pbot_files(ctl.path,file_liste);

% SignalStruktur anlegen
ist = 0;
for i=1:length(ctl.signal_liste)
    bot = ctl.signal_liste{i};
    for ib = 2:length(bot)
        ist = ist + 1;
        st.signal(ist).bot_name = bot{1};
        st.signal(ist).sig_name = bot{ib};
    end
end
if( ist == 0 )
   warning('can_vergleich: ctl.signal_lsite ist nicht richtig gesetzt {{bot_name},{sig1_name},{sig2_name}, ... }');
   okay = 0;
   return
end

% Auswerten der Fileliste Signale in st schreiben
for i = 1:length(file_liste)
        
        [okay,st] = can_vergleich_suche_signale_in_file(file_liste{i},st);
end

% Plotten, wenn gewünscht:
if( ctl.plt_flag )
    okay = can_vergleich_plot(st,ctl);
end
    
function    f_liste = can_vergleich_suche_pbot_files(c_path,f_liste)
%
% Sucht gewndelte Files *_pbot.mat

for ipath = 1:length(c_path)
    
    path = c_path{ipath};
    
    if( ~exist(path,'dir') )
        warning('can_vergleich_suche_pbot_files: Der Pfad %s existiert nicht',path);
    end
    
    %Pfad nach Files durchsuchen
    s_liste = suche_files_f(path,'mat');

    for is = 1:length(s_liste)
    
        if( str_find_f(s_liste(is).body,'_pbot') > 1 )
        
            f_liste{length(f_liste)+1} = s_liste(is).full_name;
        end
    end
    
    cp = suche_dir(path);
    
    if( length(cp) > 0 )
        for i=1:length(cp)
           f_liste = can_vergleich_suche_pbot_files(cp{i},f_liste);
        end
    end
end

function [okay,st] = can_vergleich_suche_signale_in_file(file,st)

okay = 1;

% Datei einladen
command = ['load ',file];
fprintf('%s\n',command);
eval(command);

if( exist('pbot','var') & isstruct(pbot) )

    for ipbot = 1:length(pbot)
        
        for ist = 1:length(st.signal)
        
            % Botschaft finden
            if( length(strfind(pbot(ipbot).name,st.signal(ist).bot_name)) > 0  | ...
                strcmp(lower(pbot(ipbot).identhex),lower(st.signal(ist).bot_name)) )
            
%           if( length(strfind(pbot(ipbot).name,st.signal(ist).bot_name)) > 0   )
            
                sig = pbot(ipbot).sig;
                
                % Signal finden
                for isig = 1:length(sig)
                    
                    if( length(strfind(sig(isig).name,st.signal(ist).sig_name)) > 0 )
                        
                        clear mess
                        
                        %Messung zusammenspeichern
                        mess.file_name = file;
                        mess.time      = pbot(ipbot).time;
                        mess.sig       = sig(isig);
                        
                        % Struktur übergeben
                        if( isfield(st.signal(ist),'mess') )
                            nmess = length(st.signal(ist).mess)+1;
                        else
                            nmess = 1;
                        end
                        st.signal(ist).mess(nmess) = mess;
                        break;
                    end
                end
            end
        end
    end
end

function okay = can_vergleich_plot(st,ctl)
okay = 1;
set_plot_standards
fig_num = 0;

if( ~isfield(ctl,'plt_legend') )
    ctl.plt_legend = 'no';
end
if( ~isfield(ctl,'plt_dina4') )
    ctl.plt_dina4 = 0;
end

for ist = 1:length(st.signal)
        
    if( isfield(st.signal(ist),'mess') )
        
        fig_num = p_figure(fig_num+1,ctl.plt_dina4,st.signal(ist).sig_name);
    
        nm = length(st.signal(ist).mess);
        c_legend = {};
        for im = 1:nm
            
            mess = st.signal(ist).mess(im);
            plot(mess.time,mess.sig.vec,'Color',PlotStandards.Farbe{min(im,PlotStandards.nFarbe)})
            hold on
            s_file = str_get_pfe_f(mess.file_name);
            if( strcmp(lower(ctl.plt_legend),'file') )
                c_legend{length(c_legend)+1} = str_change_f(s_file.fullfile,'_',' ','a');
            elseif( strcmp(lower(ctl.plt_legend),'file_short') )
                c_legend{length(c_legend)+1} = str_change_f(s_file.name,'_',' ','a');
            end
        end
        hold off
        
        grid on
        
        %title
        if( isfield(ctl,'plt_title') & length(ctl.plt_title) )
            title(str_change_f(ctl.plt_title,'_',' ','a'))
        end
        
        %legend
        if( length(c_legend) > 0 )
            legend(c_legend,'Location','BestOutside')
        end

        % label
        xlabel(str_change_f('time [s]','_',' ','a'));
        ylabel(str_change_f([mess.sig.name,' [',mess.sig.einheit,']'],'_',' ','a'));
        
        % crosshair
        chs('set')

        
    end
end

% Zoom und Menue
if( ~isempty(get_fig_numbers) )
    % Zoom all figures setzen
    zaf('set')
    % Figueren menü
    figmen
end

