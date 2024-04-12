function mapping(filepath);

% file:          mapping.m
%
% parameters:    - Pfad mit dem Dateinamen, der Datei mit den zu sortierenden Signalen
%
% related files: sel_name.m
%                  Suchalgorithmus um in den Eingangssignalen eines
%                  BusSelectors nach bestimmten Signalen zu suchen.
%
% Diese Function sortiert die in einer ASCII-Datei definierten Signale
% eines Simulink Modells nach Reihenfolge und Anzahl, so dass diese mit 
% dem Eingang einer ebenfalls mit Hilfe dieser ASCII-Datei erzeugten 
% S-Function übereinstimmen. 
% Der Namen und Pfad der ASCII-Datei wird beim Funktionsaufruf mit übergeben. Die
% ASCII-Datei muß im Subfolder "src" liegen.
% In der ASCII-Datei dürfen nur Signalnamen stehen, keine Gruppennamen!
% Die Signale aus dem Simulink Modell, welche in die S-Function gehen, werden
% innerhalb des Subsystems "mapping_inp" mit Hilfe eines BusSelectors sortiert.
%
% usage:  mapping('c:\project\test.inp')
%
% author: S. Fritz, D. Berneck                            Vs1.1
%
% see also: naming.m
%


ss='mapping_inp'; % Subsystem, das vor s-function gehängt wird
filename=filepath;

syspath=find_system('name',ss);
sp=syspath{1,1}; % Abkürzung für einfachere Schreibweise

% Löschen eines eventuell bereits vorhandenen Systems

if find_system(sp,'FindAll','on','name','BusSelector') ~= 0
  line=find_system(sp,'FindAll','on','type','line');
  a=length(line)-2;
  for I = 1:a,
    start=['BusSelector/' num2str(I)];
    stop =['Mux/' num2str(I)];
    delete_line(sp,start,stop);
  end
  delete_line(sp,'In/1','BusSelector/1');
  delete_line(sp,'Mux/1','Out/1');
  delete_block([sp '/BusSelector']);
  delete_block([sp '/Mux']);
end


% ACII-Datei mit Signalnamen einlesen und Dimension des Ausgangsvektors

fid=fopen(filename,'rt');
i = 1;
while feof(fid) == 0
  tline = fgetl(fid);
  if (((strncmp(tline,' ',1) == 0)) & (length(tline) ~= 0))
    name{1,i} = tline;
    i = i + 1;
  end
end;
fclose(fid);
N=length(name);


% Elemente des Subsystems aufbauen
% (evtl. Ports, BusSelector)

if find_system(sp,'FindAll','on','name','In')
else
  add_block('built-in/Inport',[sp '/In']);
  set_param([sp '/In'],'Position',[25 423 55 437]);
  add_block('built-in/Outport',[sp '/Out']);
  set_param([sp '/Out'],'Position',[650 423 680 437]);
end


add_block('built-in/BusSelector',[sp '/BusSelector'],...
    'MuxedOutput', 'off',...
    'Position',[115 28 130 832],...
    'ShowName','Off',...
    'BackgroundColor','black');

add_block('built-in/Mux',[sp,'/Mux'],...
    'Position',[580 32 590 828],...
    'Inputs',num2str(N),...
    'ShowName','Off',...
    'BackgroundColor','black');

add_line(sp,'In/1','BusSelector/1');
add_line(sp,'Mux/1','Out/1');

% Auslesen der Eingangssignale des BusSelector
InpSig=get_param([sp '/BusSelector'], 'InputSignals');


found_signals=1;
flag=0;
signal_name='';
% parsen der Eingangssignale und vergleichen mit den Signalnamen in Datei
for i=1:N
    signal_name=sel_name(InpSig, name{i});
    if strcmp(signal_name,'empty')==0
        if flag==0
            signals=signal_name;
            flag=flag+1;
        else
            signals=[signals,',',signal_name];
            found_signals=found_signals+1;
        end
    else
        % Fehler (siehe Fehlerausgabe von sel_name.m)
        sprintf('mapping input: Check file %s with your Simulink model for wrong signal names!', filename)
    end
end

set_param([sp '/BusSelector'], 'OutputSignals', signals);

if N==found_signals
    for i = 1:N
        start=['BusSelector/' num2str(i)];
        stop =['Mux/' num2str(i)];
        add_line(sp,start,stop);
    end
    disp(' ')
    disp('mapping input: Successfully Finished')
    disp(' ')
else

    disp(' ')
    disp('mapping input: There are missing signals in your Simulink model!!!!')
    disp(' ')
end



% EOF