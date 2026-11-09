function [bot,mes,cal] = conv_can_mess(dbc_file,bot,mess_file,mes,cal,filt,tab,plt,xls)
% Liest dbc-File
% Liest Messung (nur asci-File aus Canalyser
% Schreibt Botschaft mit Signalen stepweise raus

%dbc-File lesen
%==============
s = str_get_pfe_f(dbc_file);

if( strcmp(class(bot),'struct') ) % bot ist vorhanden

    s_frage.comment   = 'Soll die vorhandene dbc-Struktur bot verwendet werden';
    s_frage.default   = 1;
    s_frage.def_value = 'j';
    if( o_abfragen_jn_f(s_frage) )
        dbc_read_flag = 0;
    else
        dbc_read_flag = 1;
    end
else
    dbc_read_flag = 1;
end
if( dbc_read_flag & exist([s.dir,'\',s.name,'.mat'],'file') )
        s_frage.comment   = 'Soll die vorhandenes mat-File mit dbc-Struktur bot verwendet werden';
        s_frage.default   = 1;
        s_frage.def_value = 'j';
        if( ~o_abfragen_jn_f(s_frage) )
            command = ['load ',s.dir,'\',s.name,'.mat'];
            eval(command);
            dbc_read_flag = 0;
        else
            dbc_read_flag = 1;
        end
end
if( dbc_read_flag )
    fprintf('-> bot = dbc_read(''%s'')\n',dbc_file);
    bot = dbc_read(dbc_file);
    command=['save ',s.dir,'\',s.name,'.mat bot'];
    eval(command);
    fprintf('<- dbc_read()\n');
end

% Messung einlesen
%=================
s_mess_file = str_get_pfe_f(mess_file);

if( strcmp(class(mes),'struct') ) % mes ist vorhanden

    s_frage.comment   = 'Soll die vorhandene Messungs-Struktur mes verwendet werden';
    s_frage.default   = 1;
    s_frage.def_value = 'j';
    if( o_abfragen_jn_f(s_frage) )
        mes_read_flag = 0;
    else
        mes_read_flag = 1;
    end
else
    mes_read_flag = 1;
end
if( mes_read_flag & exist([s_mess_file.dir,'\',s_mess_file.name,'.mat'],'file') )
        s_frage.comment   = 'Soll die vorhandenes mat-File mit Mess-Struktur mes verwendet werden';
        s_frage.default   = 1;
        s_frage.def_value = 'j';
        if( ~o_abfragen_jn_f(s_frage) )
            command = ['load ',s_mess_file.dir,'\',s_mess_file.name,'.mat'];
            eval(command);
            mes_read_flag = 0;
        else
            mes_read_flag = 1;
        end
end

if( mes_read_flag )
    fprintf('-> mes = can_mess_read(''%s'')\n',[mess_file]);
    mes = can_mess_read([mess_file]);
    fprintf('<- can_mess_read()\n');
end

% Messung auswerten nach Signale
if( strcmp(class(cal),'double') )
    fprintf('-> cal = can_mess_calc(mes,bot)\n');
    cal = can_mess_calc(mes,bot);
    fprintf('<- can_mess_calc()\n');
end
% Messung filtern nach Zeit,Sender und Botschaften
fprintf('-> calf = can_mess_filt_bot(cal,bot,filt)\n');
calf = can_mess_filt_bot(cal,bot,filt);
fprintf('<- can_mess_filt_bot()\n');


% ausgewertete Messung in Tabelle ausgeben
if( exist('tab','var') & strcmp(class(tab),'struct') & isfield(tab,'flag') & tab.flag )
    fprintf('-> can_mess_tab_ausgabe(calf,''%s'',tab)\n',[mess_file,'.tab']);
    can_mess_tab_ausgabe(calf,[mess_file,'.tab'],tab);
    fprintf('<- can_mess_tab_ausgabe()\n');
end
% ausgewertete Messung in Plot ausgeben
if( exist('plt','var') & strcmp(class(plt),'struct') & isfield(plt,'flag') & plt.flag )
    fprintf('-> can_mess_plot_ausgabe(calf,plt)\n');
    can_mess_plot_ausgabe(calf,plt);
    fprintf('<- can_mess_plot_ausgabe()\n');
end

% ausgewertete Messung in Plot ausgeben
if( exist('xls','var') & strcmp(class(xls),'struct') & isfield(xls,'flag') & xls.flag )
    fprintf('-> can_mess_xls_ausgabe(calf,xls,''%s'')\n',[mess_file,'.xls']);
    can_mess_xls_ausgabe(calf,xls,[mess_file,'.xls']);
    fprintf('<- can_mess_xls_ausgabe()\n');
end
