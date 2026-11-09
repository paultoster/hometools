function okay = collect_pdf(destroy_flag,path_name)
%
% Collect all pdf in path and make one pdf
% You need to have Freepdf.exe in "C:\Program Files\FreePDF_XP\"
% otherwise edit this script
%
% okay = collect_pdf(destroy_flag,path)
% destroy_flag = 1        destroy collected pdf
%              = 0        don't destroy collected pdf(default)
% path                    give the path
%                        (default: pwd)
% okay = collect_pdf(destroy_flag,file_names)
% destroy_flag = 1        destroy collected pdf
%              = 0        don't destroy collected pdf(default)
% file_names   (cellarray)Liste mit pdf-Daten
%                        
okay = 1;
exe_file = 'C:\Program Files (x86)\FreePDF_XP\Freepdf.exe';
if( ~exist('destroy_flag','var') )
    destroy_flag = 0;
end
if( ~exist('path_name','var') )
    path_name = pwd;
end
if( ~exist(exe_file,'file') )
    error('Freepdf.exe is not in the right place <%s>',exe_file);
end

% Collect all pdfs
if( iscell(path_name) )
 pdf_files = suche_files_f(path_name,'*',0,1);
 path_name = pdf_files(1).dir;
else
 pdf_files = suche_files_f(path_name,'pdf',0);
end

 if( ~isempty(pdf_files) )

    s_frage = [];
    for i=1:length(pdf_files)
        s_frage.c_liste{i} = pdf_files(i).name;
    end
    s_frage.frage      = 'pdf-Files nacheinander ausw‰hlen (Ende mit cancel)';
    s_frage.single     = 0;
    [okay1,selection] = o_abfragen_listboxsort_f(s_frage);
    if( okay1 )
        c_files = {};
        for i=1:length(selection)
            c_files{i} = pdf_files(selection(i)).full_name;
        end
        n = length(c_files);
        
        s_frage = [];
        s_frage.frage = 'Wie soll die zusammengefasste pdf-Datei heiﬂen ? ';
        s_frage.type  = 'char';
        s_frage.default = 'pdf.pdf';
        [okay,value] = o_abfragen_wert_f(s_frage);
        if( okay )
            s_file = str_get_pfe_f(value);
            f = fullfile(path_name,[s_file.name,'.pdf']);
            command = sprintf('"%s" /m "%s"',exe_file,f);
            for i=1:n
                command = [command,sprintf(' "%s"',c_files{i})];
            end
            
            [status, result] = system(command);
            if( status == 0 && destroy_flag )
                for i=1:n
                    delete(c_files{i});
                end
            end     
        end
    end
        
     
 else
     okay = 0;
     fprintf('No pdf-File found\n');
 end