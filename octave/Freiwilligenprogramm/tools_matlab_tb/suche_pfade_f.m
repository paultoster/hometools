function pathlist = suche_pfade_f(path_spec)

dirlist = dir(path_spec);

if( length(dirlist) == 0 )
    error('suche_pfade_f: path_spec ist nicht gültig')
    frprintf('\n path_spec = %s\n',path_spec);
else
	j =0;
	for i=1:length(dirlist)
        
        if( dirlist(i).isdir == 1 & ~strcmp(dirlist(i).name,'.') & ~strcmp(dirlist(i).name,'..') )
            j = j+1;
            pathlist(j) = dirlist(i);
        end
	%    fprintf('%s\n',dirlist(i).name)
	end
	%fprintf('pathlist \n');
	%for i=1:length(pathlist)
	%    
	%    fprintf('%s\n',pathlist(i).name)
	%end
end