function [c_names,icount] = str_split(textin,delim)
%
% [c_names,icount] = str_split(textin,delim)
%
% Text wird nach delim gesplittet aber die quots werden beachtet
% Ausgabe cellarray mit den Textteilen


    c_names = {};
    icount = 0;
    go_on  = 1;

    if( strcmp(delim,'\t') )
      delim  = sprintf(delim);
    end

    if( isempty(textin) )
        return
    end

    if( iscell(textin) )
      textin = textin{1};
    end
    if( ~ischar(textin) )
      error('textin muﬂ ein string sein')
    end

    while( go_on )

        a = findstr(textin,delim);

        if( length(a) == 0 )

             icount = icount + 1;
             c_names{icount} = textin;
             go_on = 0;
        else
            i0 = a(1)-1;
            i1 = a(1)+length(delim);
            if( i0 < 1 )
                icount = icount + 1;
                c_names{icount} = '';
            else
                icount = icount + 1;
                c_names{icount} = textin(1:i0);
            end
            if( i1 > length(textin) )
                textin = '';
            else
                textin = textin(i1:length(textin));
            end
        end            

    end
end
