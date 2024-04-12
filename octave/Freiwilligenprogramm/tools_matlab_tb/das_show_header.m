path_spec='d:\messungen\a3';

% exclude_file_with_beginning='dia';
% exclude_file_with_beginning = lower(exclude_file_with_beginning);
% prc_file='C:\EIGENE~1\DAS_PRO\TOURAN\TOURAN6T.PRC';
prc_file='C:\EIGENE~1\DAS_PRO\TOURAN\TOURAN8t.PRC';
prc_file='C:\EIGENE~1\DAS_PRO\TOURAN\TOUGAL2.PRC';

path_list = suche_pfade_f(path_spec);

fprintf('\nPfade zum auswaehlen:');
fprintf('\n=====================\n');

if( length(path_list) > 0 )
    fprintf('%s\n','alle');
end    
for i=1:length(path_list)
    
    fprintf('%s\n',path_list(i).name);
end


com_input=input(' Welcher Pfad (delim:'' ''):','s');

[act_path,com_input] = strtok(com_input);

path_list_to_read = {};
if( strcmp(act_path,'alle') )
 
    for i=1:length(path_list)
        path_list_to_read{i} = [path_spec,'\',char(path_list(i).name)];
    end
else
    i = 0;
    while(length(act_path) > 0)
        i = i+1;
        path_list_to_read{i} = [path_spec,'\',act_path];
        [act_path,com_input] = strtok(com_input);
    end
end


fid = fopen('header_file_liste.dat','w');
fprintf(fid,'\n%s\n','--------------------------------------');
fprintf(fid,'\n%s\n','- Headerliste                        -');
fprintf(fid,'\n%s\n','--------------------------------------');

for i=1:length(path_list_to_read)
   
        
    search_dat_path = char(path_list_to_read{i});
	
	file_list = suche_files_f(search_dat_path,'*.dat');
	
	% bereinige dateien:
    
	for i=1:length(file_list)
        
        file_list(i).name = lower(file_list(i).name);
        
            full_file_name = [search_dat_path,'\',file_list(i).name];
%            [d,u,f,h,p] = dasprcread(full_file_name,prc_file);

            fid2=fopen(full_file_name);
            tline = fgetl(fid2);
            header_state = 0;
            while( tline ~= -1 )
                switch header_state
                    case 0
                        if(strcmp(tline,'#BEGINGLOBALHEADER'))
                            header_state = 1;
                            fprintf(fid,'\n%s\n',full_file_name);
                            
                        end
                    case 1
                        if( strcmp(tline,'#ENDGLOBALHEADER'))
                            header_state = 2;
                        else
                            if( strcmp(tline(1:4),'101,') )
                                fprintf(fid,'%s\n',tline);
                            end
                            
                        end
                    case 2
                        break
                end
                tline = fgetl(fid2);
            end
            fclose(fid2)
	end

end

fprintf(fid,'\n%s\n','--------------------------------------');
fprintf(fid,'\n%s\n','- Ende                               -');
fprintf(fid,'\n%s\n','--------------------------------------');
    
fclose(fid);

clear fid d u f h p
	
edit header_file_liste.dat