function [d,u,f]=canread(filename,dbcfile,delta_t,channel)
%
%        d=canread(can-file,dbc-file,[delta_t=0.01],[channel=0])
%
%      Eingabeargument: 
%         can-file     asc- oder log-Canalyserdatei
%         dbc-file     dbc-Datei Can-Datenbankfile
%         delta_t      Zeitschrittweite in s
%         channel      Kanalnummer der Messung von null gezählt
%        
%
%      Ausgabeargumente 
%         d: struct mit allen im Datenfile gefundenen Kanälen
%         u: dazugehörige Einheiten
%         f: verwendeter Dateiname
%

% TBert, TZS, 3052, 02.08.02, V1.0


d={};
u={};
if( ~exist('delta_t','var') )
    delta_t = 0.01;
end
if( ~exist('channel','var') )
    channel = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dat-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OriginalPathName = cd;
if nargin==0 || (nargin>0 && isempty(remblank(filename)))
   [file,path]=uigetfile('*.asc;*.log','Canalyser-Datenfile auswählen');
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
%    cd (path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DBC-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<=1 || (nargin>0 && isempty(remblank(dbcfile)))
   [file,path]=uigetfile('*.dbc','(.dbc)- CAnalyser Datenbankfile auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   dbcfile=[path, file];
end
% 

% Datei einlesen
fprintf('\n[d,u]=cancread(''%s'',''%s'',%f,%i)\n',filename,dbcfile,delta_t,channel);

if nargout <= 1
    d = mexReadData(7,filename,dbcfile,delta_t,channel);
elseif nargout == 2
    [d,u] = mexReadData(7,filename,dbcfile,delta_t,channel);
elseif nargout == 3
    [d,u,f] = mexReadData(7,filename,dbcfile,delta_t,channel);
else
    error('nargout kann maximal 3 sein')
end

% unit checken
u = duh_check_du_f(d,u);

d0 = d;
u0 = u;
names  = fieldnames(d);
d = [];
u = [];
for i=1:length(names)
    
    % Kein Unterstrich am anfang weglassen
    if( str_find_f(names{i},'_','vs') ~= 1 )
        
        d.(names{i}) = d0.(names{i});
        u.(names{i}) = u0.(names{i});
    else
        fprintf('canread: Signal <%s> wurde ausgefiltert, der Name ist nicht gültig und ist wahrscheinlich statistischer Wert\n',names{i});
    end
end
% Ausfiltern

% cd(OriginalPathName);
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
