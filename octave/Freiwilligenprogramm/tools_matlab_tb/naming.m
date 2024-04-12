function naming(filepath);
% file:          naming.m
%
% parameters:    Pfad mit Dateinamen, der Datei mit den zu sortierenden Signalen
%
% usage:  naming('c:\project\test.out')
%
% author: S. Fritz                            Vs1.1
%
% see also: mapping.m
%

global N

ss='naming_esp'; % Subsystem, das an s-function gehängt wird
filename=filepath
disp(filename)
syspath=find_system('name',ss);
sp=syspath{1,1}; % Abkürzung für einfachere Schreibweise

% Löschen eines eventuell bereits vorhandenen Systems

if find_system(sp,'FindAll','on','name','Demux') ~= 0
  line=find_system(sp,'FindAll','on','type','line');
  N=length(line)-2;
  for I = 1:N,
    start=['Demux/' num2str(I)];
    stop =['BusCreator/' num2str(I)];
    delete_line(sp,start,stop);
  end
  delete_line(sp,'In/1','Demux/1');
  delete_line(sp,'BusCreator/1','Out/1');
  delete_block([sp '/Demux']);
  delete_block([sp '/BusCreator']);
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
disp(N)
% Elemente des Subsystems aufbauen
% (Demux, BusCreator und Signallinien mit Namen)

if find_system(sp,'FindAll','on','name','In')
else
  add_block('built-in/Inport',[sp '/In']);
  set_param([sp '/In'],'Position',[20 140 50 170]);
  add_block('built-in/Outport',[sp '/Out']);
  set_param([sp '/Out'],'Position',[330 140 360 170]);
end

add_block('built-in/Demux',[sp '/Demux']);
set_param([sp '/Demux'],'Position',[80 100 130 200]);
set_param([sp '/Demux'],'Outputs','N');

add_block('built-in/BusCreator',[sp '/BusCreator']);
set_param([sp '/BusCreator'],'Position',[280 100 290 200]);
set_param([sp '/BusCreator'],'Inputs','N');

add_line(sp,'In/1','Demux/1');
add_line(sp,'BusCreator/1','Out/1');

for i = 1:N,
  start=['Demux/' num2str(i)];
  stop =['BusCreator/' num2str(i)];
  add_line(sp,start,stop);
end

line=find_system(sp,'FindAll','on','type','line');

for i = 1:N,
  set_param(line(N-i+1),'Name',name{1,i});
end


clear name
