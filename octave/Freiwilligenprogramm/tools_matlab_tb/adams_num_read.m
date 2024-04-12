function [d,u,f]=adams_num_read(filename)
% DIAREAD Einlesen der von DAS-Messdateien
%  <c> 2001 by Continental Teves AG & Co. oHG
%
%      Normaler Aufruf:
%        d=adams_num_read
%        d=adams_num_read(filename)
%
%      Mit zusätzlichen Ausgabeargumenten:
%        [d,u]=adams_num_read(filename)
%        [d,u,f]=adams_num_read(filename)
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
%

% TBert, TZS, 3052, 17.03.02, V1.0


% '.dat'-Datei wählen, wenn kein Eingabeargument
fprintf('\nadams_num_read Version 1.0 Start ...')
fprintf('\n[d,u,f]=adams_num_read(filename)')
fprintf('\nd: struct mit allen im Datenfile gefundenen Kanälen')
fprintf('\nu: dazugehörige Einheiten')
fprintf('\nf: verwendeter Dateiname')

d={};
u={};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dat-Datei auswählen und öffnen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OriginalPathName = cd;
if nargin==0 | (nargin==1 & isempty(remblank(filename)))
   [file,path]=uigetfile('*.*','Datenfile auswählen');
   if file==0
     d = 0;
     u = 0;
     f = 0;
     h = {};
     return
   end
   filename=[path, file];
else
    if( length(strfind(filename,'/')) > 0 )
       [file,path] = filename_split_f(filename,'/');
   else
       [file,path] = filename_split_f(filename,'\');
   end
end
   cd (path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% '.dat'-Datei einlesen
fprintf('\n[d,u,f]=adams_num_read(''%s'')\n',filename);

if nargout <= 1
    d = read_adams_num_mat(file);
elseif nargout == 2
    [d,u] = read_adams_num_mat(file);
elseif nargout >= 3
    [d,u,f] = read_adams_num_mat(file);
end
if( nargout >= 3 )
    f = [path,f];
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
function [f,p]=filename_split_f(filename,delim)

pos=max(strfind(filename,delim));


if( isempty(pos) )
    f = filename;
else
    if( pos+1 <= length(filename) )
        f=filename(pos+1:length(filename));
    else
        f = '';
    end
end
if( nargout > 1 )
    if( isempty(pos) )
        p = '.\Results\';
    else
        p=filename(1:pos);
    end
end
