function okay = print_unreadable_ascii(t,f,w)
%
% okay = print_unreadable_ascii(t,file_name,w)
%
% t         Textstring
% fiel_name Filename, if 1 => screen, if numeric used as fid
% w         wdth
%
fisopen = 0;
okay    = 1;

if( ~exist('t','var') || ~ischar(t) )
    
    fprintf(2,'okay = print_unreadable_ascii(string,file_name,width)')
    fprintf(2,'string         Textstring');
    fprintf(2,'file_name      Filename, if 1 => screen, if numeric used as fid');
    fprintf(2,'width          print width');
    okay = 0;
    return;
end
if( ~exist('w','var') )
    
    w = 40;
end
if( ischar(f) )
    
    file_name = f;
    f = fopen(file_name,'w');
    if( f == -1 )
        fprintf(2,'print_unreadable_ascii File:<%s> could not be opened',file_name);
        okay = 0;
        return
    else
        fisopen = 1;
    end
end

% for i=1:128
%     
%     fprintf(1,'%i: %s\n',i,char(i));
% end
for i = 1:length(t)

    it = double(t(i));
    if( it > 31 && it < 127 )
        fprintf(f,'%i: <%s> (ascii:%i)\n',i,t(i),it);
    else
        fprintf(f,'%i: <char(%i)> (ascii:%i)\n',i,it,it);
    end
end
if( fisopen )
    fclose(f);
    fprintf(1,'File: <%s> is written',file_name);
end