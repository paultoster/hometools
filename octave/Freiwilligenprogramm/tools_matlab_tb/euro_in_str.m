function dstr = euro_in_str(d,delim)
%
% dstr = euro_in_str(d,[delim])
% d = 2.353 => dstr = '2.35'
%
if( ~exist('delim','var') || ~ischar(delim) )
    
    delim = '.';
end

if( d > 0 )

    euro = floor(d);
    cent = round((d-euro)*100);
    dstr = [num2str(euro),delim,num2str(cent,'%2.2i')];
else
    euro = floor(abs(d));
    cent = round((abs(d)-euro)*100);
    dstr = ['-',num2str(euro),delim,num2str(cent,'%2.2i')];
end
