function s_liste = o_abfragen_werte_liste_erstellen_f(varargin)

% Erstellt aus m=n*3 Werte eine m-fache struktur
% mit value,command,description
% z.B.
% c_dir={};
% c_werte{1} = 10;
% c_werte{2} = 20;
% s_liste = o_abfrage_werte_liste_erstellen(1,1,'dir',c_dir,'verzeichnis' ...
%                                          ,2,0,'val',c_werte,'Funktionwerte' ...
%                                          );
% ergibt
% s_liste(1).option     = 1;
% s_liste(1).tbd        = 1;
% s_liste(1).command    = 'dir';
% s_liste(1).c_value    = {};
% s_liste(1).descrption = 'Verzeichnis';
% s_liste(2).option     = 2;
% s_liste(2).tbd        = 0;
% s_liste(2).command    = 'dir';
% s_liste(2).c_value{1} = 10;
% s_liste(2).c_value{2} = 20;
% s_liste(2).descrption = 'Funktionswerte';
%
n=length(varargin);
n = fix(n/4);

for i=1:n

    
    s_liste(i).option      = i;
    s_liste(i).tbd         = varargin{(i-1)*4+1};
    s_liste(i).command     = str_cut_ae_f(varargin{(i-1)*4+2},' ');
    
    % c_value
    value                  = varargin{(i-1)*4+3};
    if( strcmp(class(value),'double') )
        for j=1:length(value)
            s_liste(i).c_value{j} = value(j);
        end
    elseif( strcmp(class(value),'char') )
         s_liste(i).c_value{1} = value;
    elseif( strcmp(class(value),'struct') )
        error('o_abfrage_werte_liste_erstellen_f','keine Struktur als wert übergeben');
    else
        s_liste(i).c_value = value;
    end
        
    s_liste(i).description = varargin{(i-1)*4+4};
end
