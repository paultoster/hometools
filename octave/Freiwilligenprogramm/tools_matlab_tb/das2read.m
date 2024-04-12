function [d,u,f,h,p,a]=das2read(filename)
% DAS2READ Einlesen der von DAS-Messdateien mit project-File
%  <c> 2001 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=das2read
%        d=das2read(dat-file)
%        d=das2read(dat-file,[prc-file],[a2l-file])
%        aber auch
%        d=dasprcread('',prc-file)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=das2read(dat-file)
%        [d,u,f]=das2read(dat-file)
%        [d,u,f,h]=das2read(dat-file)
%        [d,u,f,h,p]=das2read(dat-file)
%        [d,u,f,h,p,a]=das2read(dat-file)
%
%      Eingabeargument: dat-file,prc-file,a2l-file(optional)
%         Es ist hier der Name des '.dl2'-Files anzugeben.
%         Das Argument kann weggelassen werden, der dls-file,prc-file un d a2l-file wird dann mit einem 
%         Dialogfenster erfragt.
%
%      Ausgabeargumente 
%         d: struct mit allen im Datenfile gefundenen Kanälen
%         u: dazugehörige Einheiten
%         f: verwendeter Dateiname
%         h: alle Header-Informationen
%         p: verwendeter Project-File
%         a: verwendeter asap-File
%

% TBert, TZS, 3052, 02.08.02, V1.0


% '.dat'-Datei wählen, wenn kein Eingabeargument
fprintf('\ndas2read Version 1.1 Start ...')
fprintf('\n[d,u,f,h,p,a]=das2read(filename)')
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
%OriginalPathName = cd;
if nargin==0 | (nargin>0 & isempty(remblank(filename)))
   [file,path]=uigetfile('*.dl2','(.dl2)-Datenfile auswählen');
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
%   cd (path)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % PRC-Datei auswählen und öffnen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if nargin<=1 | (nargin>0 & isempty(remblank(prcfile)))
%    [file,path]=uigetfile('*.prc','(.pqrc)- Projectfile auswählen');
%    if file==0
%      d = 0;
%      u = 0;
%      f = 0;
%      h = {};
%      return
%    end
%    prcfile=[path, file];
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % a2l-Datei auswählen und öffnen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if nargin<=2 | (nargin>0 & isempty(remblank(a2lfile)))
%    [file,path]=uigetfile('*.a2l','(.a2l)- Asapfile auswählen');
%    if file==0
%      d = 0;
%      u = 0;
%      f = 0;
%      h = {};
%      return
%    end
%    a2lfile=[path, file];
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% '.dat'-Datei einlesen
fprintf('\n[d,u,f,h,p]=das2read(''%s'')\n',filename);

if nargout <= 1
    d = read_data_mat(4,filename);
elseif nargout == 2
    [d,u] = read_data_mat(4,filename);
elseif nargout == 3
    [d,u,f] = read_data_mat(4,filename);
elseif nargout == 4
    [d,u,f,h] = read_data_mat(4,filename);
elseif nargout == 5
    [d,u,f,h,p] = read_data_mat(4,filename);
else
    [d,u,f,h,p,a] = read_data_mat(4,filename);
end

%cd(OriginalPathName);
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
