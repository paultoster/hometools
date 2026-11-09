% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function [d,u,f,h,p]=dasread(filename)
% DASREAD Einlesen der von DAS-Messdateien
%  <c> 2001 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=dasread
%        d=dasread(filename)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=dasread(filename)
%        [d,u,f]=dasread(filename)
%        [d,u,f,h]=dasread(filename)
%        [d,u,f,h,p]=dasread(filename)
%
%      Eingabeargument: filename (optional)
%         Es ist hier der Name des '.dat'-Files anzugeben.
%         Das Argument kann weggelassen werden, der Filename wird dann mit einem 
%         Das Projektfile wird aus dem '.dat'-File ausgelesen (Wenn  nicht möglich
%         benutze dasprcread.m)
%         Dialogfenster erfragt.
%
%      Ausgabeargumente 
%         d: struct mit allen im Datenfile gefundenen Kanälen
%         u: dazugehörige Einheiten
%         f: verwendeter Dateiname
%         h: alle Header-Informationen
%         p: verwendeter Project-File
%

% TBert, TZS, 3052, 02.08.02, V1.0


% '.dat'-Datei wählen, wenn kein Eingabeargument
fprintf('\ndasread Version 1.0 Start ...')
fprintf('\n[d,u,f,h,p]=dasread(filename)')
fprintf('\nd: struct mit allen im Datenfile gefundenen Kanälen')
fprintf('\nu: dazugehörige Einheiten')
fprintf('\nf: verwendeter Dateiname')
fprintf('\nh: alle Header-Informationen')
fprintf('\np: verwendetes Project-File\n')

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
   [file,path]=uigetfile('*.dat','(.dat)-Datenfile auswählen');
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
fprintf('\n[d,u,f,h,p]=dasread(''%s'')\n',filename);

if nargout <= 1
    d = read_data_mat(2,filename);
elseif nargout == 2
    [d,u] = read_data_mat(2,filename);
elseif nargout == 3
    [d,u,f] = read_data_mat(2,filename);
elseif nargout == 4
    [d,u,f,h] = read_data_mat(2,filename);
else
    [d,u,f,h,p] = read_data_mat(2,filename);
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
