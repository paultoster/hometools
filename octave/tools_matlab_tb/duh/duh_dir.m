% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
% duh_dir

function duh_dir(full_flag)


liste = suche_files_ext('d:\tools\matlab\duh','m')

fprintf('\n Im Verzeichnis %s stehen folgende Module zur Verfügung:\n\n',liste(1).dir);

for i=1:length(liste)
    
    fprintf(' %s\n',liste(i).name);
end        
        