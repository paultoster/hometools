function ctext = str_split_format(text,nzeichen,regel,pos)
%
% ctext = str_split_format(text,nzeichen,regel,pos)
%
% Splittet text (string) in n-Blöcke ctext{1:n}
% Es wird mit Leerzeichen getrennt
% text      char        Text
% nzeichen     double      Anzehl Zeichen in die geteilt wird
% regel     char        ='v' vorwärts
%                       ='r' rueckwaerts
% pos       char        ='left' oder 'right' oder 'middle'
%
if( nargin < 4 )
    pos   = 'right';
end
if( nargin < 3 )
    regel = 'v';

end
ntext = 1;    
ctext{ntext} = '';
[c_names,n] = str_split(text,' ');
for i=1:n
    text = c_names{i};
    while( length(text) > 0 )
        lc = length(ctext{ntext});
        lt = length(text);
        if( lc == 0 & lt <= nzeichen )
            ctext{ntext} = text;
            text = '';
        elseif( lc == 0 & lt > nzeichen )
            ctext{ntext} = text(1:nzeichen);
            text = text(nzeichen+1:lt);
            
            ntext = ntext + 1;
            ctext{ntext} = '';
        elseif( lc+1+lt < nzeichen )
            ctext{ntext} = [ctext{ntext},' ',text];
            text = '';
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
        text = '';
        for j=1:n
            text = [text,' '];
        end
        dtum = [text;dtum];
        text = '';
        for j= 1:nzeichen-length(dtum)
            text = [text,' '];
        end
        ctext{i} = [text,dtum];
    end
end

for ictext=1:length(ctext)
    
    n0 = length(ctext{ictext});
    
    text = str_cut_ae_f(ctext{ictext},' ');
    
    n1   = length(text);
    deln = n0 - n1;
    deln2 = floor(deln/2);
    
    if( deln > 0 )
        
        if( strcmp(lower(pos(1)),'l') )
            
            for i=1:deln
                text = [text,' '];
            end
        elseif( strcmp(lower(pos(1)),'l') )
            
            for i=1:deln
                text = [text,' '];
            end
        else

            for i=1:deln2
                text = [' ',text];
            end
            while( length(text) < n0 )
                
                text = [text,' '];
            end
        end
        
        ctext{ictext} = text;
    end            
end      

