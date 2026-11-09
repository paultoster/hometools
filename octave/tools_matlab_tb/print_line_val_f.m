% fid       file id from fid=fopen() or fid=1 standard output or fid=0 string in text
% comment   Comment string
% sep1      first seperator character
% unit      unit string
% sep2      second seperator character
% value     value to print
% clength   length of comment in line
% ulength   length of unit in line
% vlength   length of valueoutput in line
% ndigit    digits after .
%
% print_line_val_f(1,'first value','|','m/s',':',10.23,20,5,10,3)
% 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
% text = 'first value         |  m/s:    10.230'
% length(text) = clength+1+ulength+1+vlength = 37
%
function [text,ierr] = print_line_val_f(fid,comment,sep1,unit,sep2,value,clength,ulength,vlength,ndigit)

ierr = 0;


text='';
%comment
if( length(comment) > clength )
    comment = comment(1:clength);
end
for i=1:clength-length(comment)
    comment=[comment,' '];
end
text=[text,comment];
%seperator1
s1length = length(sep1);
text=[text,sep1];
%unit
iadd = 0;
if( strcmp(unit,'%') )
    unit = [unit,'%'];
    iadd = 1;
end
if( length(unit) > ulength )
    unit = unit(1:ulength);
end
for i=1:ulength+iadd-length(unit)
    unit=[' ',unit];
end
text=[text,unit];
%seperator2
s2length = length(sep2);
text=[text,sep2];

%value
if( strcmp(class(value),'double') )
    
	if(value < 0)
        x     = -value;
        nflag = 1;
	else
        x     = value;
        nflag = 0;
	end
	if( x >= 1.0 )
        vdigit = floor(log10(x))+1;
	else
        vdigit = 1;
	end
        
	if( nflag+vdigit+1+ndigit > vlength )  % sign+vorkomma+punkt+nachkomma
        ndigit = max(0.0,vlength-nflag+vdigit+1);
	end
%	tformat = sprintf('%%%i.%ig',vlength,nflag+vdigit+ndigit);
	tformat = sprintf('%%%i.%if',vlength,ndigit);
	tval    = sprintf(tformat,value);

    text = [text,tval];
    
elseif( strcmp(class(value),'char') )

    if( length(value) > vlength )
        [text1,ierr] = print_line_com_f(0,'',value,'',clength+s1length+ulength+s2length+vlength,1);
        text=[text,text1];
    else
        for i=1:vlength-length(value)
            value=[' ',value];
        end
        text=[text,value];
    end
end
if( fid > 0 )
    fprintf(fid,text);
    fprintf(fid,'\n');
end
    