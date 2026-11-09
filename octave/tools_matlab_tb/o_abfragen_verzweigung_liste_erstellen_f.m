% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function s_liste = o_abfragen_verzweigung_liste_erstellen_f(varargin)

% Erstellt aus m=n*3 Werte eine m-fache struktur
% mit value,command,description
% z.B.
% s_liste = o_abfrage_liste_erstellen(0,'end','Ende',1,'func1','Funktion 1')
% ergibt
% s_liste(1).value = 0;
% s_liste(1).command = 'end';
% s_liste(1).descrption = 'Ende';
% s_liste(2).value = 1;
% s_liste(2).command = 'func1';
% s_liste(2).descrption = 'Funktion 1';
%
n=length(varargin);
n = fix(n/3);

for i=1:n;

    
    s_liste(i).val         = i;
    s_liste(i).prot        = varargin{(i-1)*3+1};
    s_liste(i).command     = varargin{(i-1)*3+2};
    s_liste(i).description = varargin{(i-1)*3+3}; 
end
