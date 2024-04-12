function [d,u,f]=dascsvread(filename)
% CSV-Datei von Datalyser2 Einlesen der von DAS-Messdateien
%  <c> 2004 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=dasread
%        d=dasread(filename)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=dasread(filename)
%        [d,u,f]=dasread(filename)
%
%      Eingabeargument: filename (optional)
%         Es ist hier der Name des '.csv'-Files anzugeben.
%         Das Argument kann weggelassen werden, der Filename wird dann mit einem 
%         Das Projektfile wird aus dem '.csv'-File ausgelesen (Wenn  nicht möglich
%         benutze dasprcread.m)
%         Dialogfenster erfragt.
%
%      Ausgabeargumente 
%         d: struct mit allen im Datenfile gefundenen Kanälen
%         u: dazugehörige Einheiten
%         f: verwendeter Dateiname
%         h: alle Header-Informationen
%

% TBert, TZS, 3052, 02.08.02, V1.0


% '.dat'-Datei wählen, wenn kein Eingabeargument
fprintf('\ncsvread Version 1.0 Start ...')
fprintf('\n[d,u,f]=csvread(filename)')
fprintf('\nd: struct mit allen im Datenfile gefundenen Kanälen')
fprintf('\nu: dazugehörige Einheiten')
fprintf('\nf: verwendeter Dateiname')

d={};
u={};
lastfile_bb = ' ';
dataread_bb = 0;
lastfile_ba = ' ';
dataread_ba = 0;
lastfile_ka = ' ';
dataread_ka = 0;
lastfile_first = ' ';
dataread_first = 0;
first_offset = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dat-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OriginalPathName = cd;
if nargin==0 | (nargin==1 & isempty(remblank(filename)))
   [file,path]=uigetfile('*.csv','(.csv)-Datenfile auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   filename=[path, file];
else
    path = extract_path(filename);
end
   cd (path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% '.dat'-Datei einlesen
fprintf('\n[d,u,f,h,p]=dascsvread(''%s'')\n',filename);

M = importdata(filename,',');

if( length(M.textdata) >= 3 )
    
    f = filename;
    
    c_names = str_split(M.textdata{2},',');
    nn      = length(c_names);
    
    %Prüfen
    for i=1:nn
        if( length(c_names{i}) == 0 )        
            c_names{i} = ['Channel',num2str(i)];
        end
    end
    
    c_units = str_split(M.textdata{3},',');    
    nu      = length(c_units);
    
    for i=1:nu
        if( length(c_units{i}) == 0 )        
            c_units{i} = ['-'];
        end
    end
    % fehlende units
    for i=nu+1:nn
        c_units{i} = '-';
    end
    [ndata,mdata] = size(M.data);
    
    if( mdata ~= nn )
        error('error in dascsvread: Daten Block ist größer als der Tabellenheader (Namenslänge)')
    end
    for i=1:length(c_names)
        
        command = ['d.',c_names{i},'= M.data(:,i);'];
        eval(command);
        command = ['u.',c_names{i},'=c_units{i};'];
        eval(command);
    end
    
end

cd(OriginalPathName);
fprintf(' Ende\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=remblank(str)
%Entfernt saemtliche Leerzeichen des Strings
h='';
for i=1:length(str)
   if (str(i) ~= 32)
      h=strcat(h,str(i));
   end
end

%Extrahiere den Pfadname
function p=extract_path(str)

pos=strfind(str,'\');
if( isempty(pos) )
    p = '.\';
else
    pos=max(pos);
    p=str(1:pos);
end
