% fid       file id from fid=fopen() or fid=1 standard output or fid=0 string in text
% sep1      seperator character for first line if length > 0
% comment   Cemmt string second line
% sep2      seperator character for third line if length > 0
% slength   length of  line
% position  text position 0:left,1:right,2:midle
%
% print_line_com_f(1,'-','Neuer Wert','',20+1+5+1+10,1)
%         1234567890123456789012345678901234567
% text = '\n-------------------------------------\n                           neuer Wert\n'
% length(text) = 37
%
function [text,ierr] = print_line_com_f(fid,sep1,comment,sep2,slength,position)

ierr = 0;
text = '';
%seperator line
if( length(sep1) > 0 )
    [text1,ierr] = print_line_sep_f(0,sep1,slength);
    if( ierr ~= 0 )
        return
    end
    text = [text,text1];
end
%comment
if( length(comment) > slength )
    comment = comment(1:slength);
end
if( position == 1 )
    for i=1:slength-length(comment)
        comment=[' ',comment];
    end
elseif( position == 2 )
    for i=1:2:slength-length(comment)
        comment=[' ',comment];
    end
end
text=[text,comment];
if( length(sep2) > 0 )
    [text1,ierr] = print_line_sep_f(0,sep2,slength);
    if( ierr ~= 0 )
        return
    end
    text = [text,text1];
end

text = [text,'\n'];
if( fid > 0 )
    fprintf(fid,text);
end
    