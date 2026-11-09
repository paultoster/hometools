% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function [d,u,f,h,p]=dasprcread(filename,prcfile)
% DASREAD Einlesen der von DAS-Messdateien mit project-File
%  <c> 2001 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=dasprcread
%        d=dasprcread(dat-file)
%        d=dasprcread(dat-file,prc-file)
%        d=dasprcread('',prc-file)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=dasprcread(dat-file,prc-file)
%        [d,u,f]=dasprcread(dat-file,prc-file)
%        [d,u,f,h]=dasprcread(dat-file,prc-file)
%        [d,u,f,h,p]=dasprcread(dat-file,prc-file)
%
%      Eingabeargument: dat-file,prc-file (optional)
%         Es ist hier der Name des '.dat'-Files anzugeben.
%         Das Argument kann weggelassen werden, der dat-file,prc-file wird dann mit einem 
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
fprintf('\ndasprcread Version 1.0 Start ...')
fprintf('\n[d,u,f,h,p]=dasprcread(filename)')
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRC-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<=1 | (nargin==2 & isempty(remblank(prcfile)))
   [file,path]=uigetfile('*.prc','(.prc)- Projectfile auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   prcfile=[path, file];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% '.dat'-Datei einlesen
fprintf('\n[d,u,f,h,p]=dasprcread(''%s'',''%s'')\n',filename,prcfile);

if nargout <= 1
    d = read_data_mat(3,filename,prcfile);
elseif nargout == 2
    [d,u] = read_data_mat(3,filename,prcfile);
elseif nargout == 3
    [d,u,f] = read_data_mat(3,filename,prcfile);
elseif nargout == 4
    [d,u,f,h] = read_data_mat(3,filename,prcfile);
else
    [d,u,f,h,p] = read_data_mat(3,filename,prcfile);
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
