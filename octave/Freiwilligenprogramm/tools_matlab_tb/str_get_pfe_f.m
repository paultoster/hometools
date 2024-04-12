function  s_file = str_get_pfe_f(fullfile)
%
% function  s_file = str_get_pfe_f(fullfile)
%
% Sucht aus Fullfile path, file und extension
% Ergebnis:
% s_file.fullfile = fullfile;   % Gesamtfilename
% s_file.dir      =             % directory
% s_file.name                   % Body
% s_file.body                   % Body
% s_file.filename               % filename
% s_file.ext                    % Extension
% s_file.lw                     % Laufwerksbuchstabe
% Beispiel
% >> str_get_pfe_f('d:\test\abc.fig')
% 
% ans = 
% 
%     fullfile: 'd:\test\abc.fig'
%          ext: 'fig'
%          dir: 'd:\test\'
%         name: 'abc'
%     filename: 'abc.fig'
%           lw: 'd'

text = char(fullfile);
s_file.fullfile  = text;
s_file.full_name = text;

idot   = max(strfind(text,'.'));
idelim = max(strfind(text,'\'));

% Wenn idot vor dem letzten delim, dann ist das kein extension
if( idot < idelim )
  idot = [];
end

if( isempty(idot) )
    s_file.ext = '';
elseif( isempty(idelim) || ((idot > idelim) && (idot < length(text))) )
    s_file.ext = text(idot+1:length(text));
    text       = text(1:max(1,idot-1));
else
    s_file.ext = '';
    text       = text(1:max(1,idot-1));
end

idelim = max(strfind(text,'\'));

if( length(idelim) == 0 )
    s_file.dir = '';
else
    s_file.dir = text(1:max(1,idelim));
    if( idelim == length(text) )
        text = '';
    else
        text = text(idelim+1:length(text));
    end
end

s_file.name = text;
s_file.body = text; 

if( isempty(s_file.ext) )
  s_file.filename = s_file.name;
else
  s_file.filename = [s_file.name,'.',s_file.ext];
end

i0 = str_find_f(s_file.dir,':\');
if( i0 > 1)
  s_file.lw = s_file.dir(1:i0-1);
else
  s_file.lw = '';
end