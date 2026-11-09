function str = str_cut_e_f(str,del_str)
%
% function str = str_cut_ae_f(str,del_str)
% Schneide del_str aus str am Ende aus
%
% z.B.  txt = str_cut_ae_f('|abc|','|')
% => txt = '|abc'
%
% um carrige return zu entfernen del_str=char(10) verwenden
%
l1 = length(del_str);
l2 = length(str);
% Solange der die letzte Stelle von str, an der del_str gefunden wurde
% identisch mit der letzten Stelle von str minus der Länge von del_str ist
while( max(strfind(str,del_str)) == length(str)-l1+1 )
    
    % wird der string del_str entfernt
    if( l1 < l2 )
        str = str(1:l2-l1);
    else
        str = '';
    end
    l2 = length(str);
end