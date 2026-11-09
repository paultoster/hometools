function ctext = str_format(str_in,ncols,regel,pos)
%
% ctext = str_format(str_in,ncols,regel,pos)
%
% str_in        Inpustring
% ncols         Breite
% regel         'v', vorwärts
%               'r', rückwärts
% pos           'l', left
%               'r', right
%               'm', middle
% ctext         formatierter Cell-Array
% beispiel
% ctext = str_format('1234567890 abcdefghij',15,'r','m')
%
% ctext: '  1234567890   '    '  abcdefghij   '

%=======================================================
%=======================================================


if( nargin < 4 )
    pos   = 'r';
end
if( nargin < 3 )
    regel = 'v';

end
    
ctext{1} = '';
ntext = 1;
[c_names,n] = str_split(str_in,' ');
for i=1:n
    str = c_names{i};
    while( length(str) > 0 )
        lc = length(ctext{ntext});
        lt = length(str);
        if( lc == 0 & lt <= ncols )
            ctext{ntext} = str;
            str = '';
        elseif( lc == 0 & lt > ncols )
            ctext{ntext} = str(1:ncols);
            str = str(ncols+1:lt);
            
            ntext = ntext + 1;
            ctext{ntext} = '';
        elseif( lc+1+lt <= ncols )
            ctext{ntext} = [ctext{ntext},' ',str];
            str = '';
        else
            
            ntext = ntext + 1;
            ctext{ntext} = '';
        end
    end
end
if( strcmp(regel,'r') )
    for i=1:length(ctext)
        dtum = str_cut_e_f(ctext{i},' ');
        n   = length(ctext{i})-length(dtum);
        str = '';
        for j=1:n
            str = [str,' '];
        end
        dtum = [str;dtum];
        str = '';
        for j= 1:ncols-length(dtum)
            str = [str,' '];
        end
        ctext{i} = [str,dtum];
    end
end
ctext = str_format_make_text_pos(ctext,pos,ncols);
function ctext = str_format_make_text_pos(ctext,pos,ncols)

for ictext=1:length(ctext)
    
    %n0 = length(ctext{ictext});
    n0 = ncols;
    
    str = str_cut_ae_f(ctext{ictext},' ');
    
    n1   = length(str);
    deln = n0 - n1;
    deln2 = floor(deln/2);
    
    if( deln > 0 )
        
        if( strcmp(lower(pos(1)),'l') )
            
            for i=1:deln
                str = [str,' '];
            end
        elseif( strcmp(lower(pos(1)),'r') )
            
            for i=1:deln
                str = [' ',str];
            end
        else

            for i=1:deln2
                str = [' ',str];
            end
            while( length(str) < n0 )
                
                str = [str,' '];
            end
        end
        
        ctext{ictext} = str;
    end            
end      
