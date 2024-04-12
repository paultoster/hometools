function [text,ierr] = print_new_line(fid)
% fid       file id from fid=fopen() or fid=1 standard output or fid=0
% 
% print a new line
ierr = 0;
text = '\n';
if( fid > 0 )
    fprintf(fid,text);
end
