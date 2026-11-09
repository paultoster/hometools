% wandel_vektor_in_struct
% Übergibt Vektoren an Struktur und löscht die Vektoren, wenn
% struct_name_wand mit Strukturnamen im Workspace vorhanden
% und start_name_wand mit den Anfangs-String zur Erkennung des Vektors
% z.B. 
% struct_name_wand = 'res';
% start_name_wand  = 'res_';
% res_p_hyd wird in res.p_hyd gewandelt und res_p_hyd gelöscht
% default sind die oben genannten werte

if( ~exist('struct_name_wand','var') )
    
    struct_name_wand = 'res';
end
    
if( ~exist('start_name_wand','var') )
    
   start_name_wand  = 'res_';
end
command = ['clear ',struct_name_wand];
eval(command)

c_list_wand = who;
ncount_wand = 0;
for i=1:length(c_list_wand)

    dtext_wand = c_list_wand{i};
    n_wand = length(dtext_wand);
    if( n_wand > 4  && strcmp(dtext_wand(1:4),start_name_wand) )

        command = [struct_name_wand,'.',dtext_wand(5:n_wand),' = ',dtext_wand,';'];
        eval(command)
        ncount_wand = ncount_wand+1;
    end
end

command = ['flag_wand_vektor = isfield(',struct_name_wand,',''time'');'];
eval(command)
if( flag_wand_vektor )
    command = [struct_name_wand,' = struct_sortiere_nach_vorne(',struct_name_wand,',''time'');'];
    eval(command)
end
    

command = ['n_wand = length(fieldnames(',struct_name_wand,'));'];
eval(command)
if( n_wand == ncount_wand ) 

    command = ['clear ',start_name_wand,'*'];
    eval(command)
%     fprintf('\n Alle Variablen beginnend mit <%s> in Struktur <%s> abgelegt !!!\n',start_name_wand,struct_name_wand);
else
    error('wand_vektor_in_strukur: nicht alle Ergebnisse wurden in Struktur gewandelt ???')
end

clear struct_name_wand start_name_wand c_list_wand ncount_wand n_wand dtext_wand
