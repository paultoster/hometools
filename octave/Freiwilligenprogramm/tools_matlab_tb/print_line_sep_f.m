% fid       file id from fid=fopen() or fid=1 standard output or fid=0 string in text
% sep       seperator character for line
% slength   length of  line
%
% print_line_sep_f(1,'-',20+1+5+1+10)
%         1234567890123456789012345678901234567
% text = '-------------------------------------'
% length(text) = 37
%
function [text,ierr] = print_line_sep_f(fid,sep,slength)

ierr = 0;

%new line
text='';
%seperator line
n = floor(slength/length(sep));
for i=1:n
    text = [text,sep];
end

text = [text,'\n'];
if( fid > 0 )
    fprintf(fid,text);
end