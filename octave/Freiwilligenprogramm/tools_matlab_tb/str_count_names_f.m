function    [s_erg] = str_count_names_f(s_liste,type)
%
% [s_erg] = str_count_names_f(s_liste,type)
%
% s_liste(i).c_names (i=1:n) ist eine Liste mit NAmen in cellarrays
% gespeichert
% z.B.
% s_liste(1).c_names{1} = 'Till';
% s_liste(2).c_names{1} = 'Till';
% s_liste(2).c_names{2} = 'Rufus';
% s_liste(3).c_names{1} = 'Till';
% s_liste(3).c_names{2} = 'Rufus';
% s_liste(3).c_names{3} = 'Arne';
% mit type == 1 wird alles gezählt:
%
% output: 
% s_erg(1).name  = 'Till'
% s_erg(1).n     = 3
% s_erg(2).name  = 'Rufus'
% s_erg(2).n     = 2
% s_erg(3).name  = 'Arne'
% s_erg(3).n     = 1
%
s_erg  = [];
icount = 0;

if( ~isfield(s_liste,'c_names') )
    error('str_count_names_f: c_names gehört  nicht zur Struktur s_liste');
end

if( nargin < 2 )
    type = 1;
elseif(type > 1 )
    type = 1;
end

len = length(s_liste);

% if( type == 1 )
	for i=1:len
        
        for j=1:length(s_liste(i).c_names)
	
            found_flag = 0;
            for k=1:icount
                
                if( strcmp(s_liste(i).c_names{j},s_erg(k).name) )
                    s_erg(k).n = s_erg(k).n + 1;
                    found_flag = 1;
                    break
                end
            end
            if( ~found_flag )
                
                icount = icount+1;
                s_erg(icount).name = s_liste(i).c_names{j};
                s_erg(icount).n    = 1;
            end
        end
	end
% end    