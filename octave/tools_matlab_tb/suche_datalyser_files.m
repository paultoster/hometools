function s_files = suche_datalyser_files(c_dir)
%
% c_dir             cellarray mit allen Pfaden
% s_files(i).dir    Verzeichnis zB 'D:\messungen\abc'
% s_files(i).name   DAteiname   zB 'mess0001'
% s_files(i).ext    Extension   zB 'dat'
len = 0;

for i=1:length(c_dir)

    liste = dir(c_dir{i});
    
    for j=1:length(liste)    
        [name,ext] = strtok(liste(j).name,'.');
        if( length(ext) > 1 )
            ext = ext(2:length(ext));
        else
            ext = '';
        end
        ext = lower(ext);
        if( ~liste(j).isdir & strcmp(ext,'dat') )
            len = len+1;
            s_files(len).dir      = char(c_dir{i});
            s_files(len).name     = name;
            s_files(len).ext      = 'dat';
            s_files(len).fullname = [char(c_dir{i}),'\',name,'.dat'];
        end
    end
end

if( ~exist('s_files') )
    s_files=[];
end

    

