function run_name    = create_run_name(name,type,set_value)
%
% run_name    = create_run_name(name,type)
%
% Es wird der Laufname gebildet mit name und a) dem counter gezählt von 1
% oder b) mit dem Datum und Uhrzeit (ist noch nicht bearbeitet)
%
% name      char        Grundname
% type      char        'count'     Wird hochgezählt, im aktuellen
%                                   Verzeichnis wird die Datei
%                                   ['create_run_name_counter_',name,'.mat'] abgelegt,
%                                   die zum weiteren Zählen verwendnet wird
% set_value double (round) reseted den counter, wenn variable vorhanden

file_name = ['create_run_name_counter_',name,'.mat'];
if( ~exist(file_name,'file') )
    
    counter = 1;
else
    eval(['load ',file_name]);
    if( exist('counter','var') )
        counter = counter+1;
    else
        counter = 1;
    end
end
if( exist('set_value','var') )
    counter = round(set_value);
end
eval(['save ',file_name,' counter']);

run_name = [name,'_',num2str(counter)];