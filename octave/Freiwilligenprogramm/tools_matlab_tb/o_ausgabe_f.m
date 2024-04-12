function okay = o_ausgabe_f(ausgabe,debug_fid,bildschirm_ausgabe,return_flag)
%
% okay = o_ausgabe_f(ausgabe,debug_fid,bildschirm_ausgabe)
%
% ausgabe               Gibt Text <ausgabe> an Bildschirm aus 
% debug_fid             schreibt in Protokollfile, wenn gesetzt d.h > 0 (Datei geöffnet)
% bildschirm_ausgabe    nicht gesetzt(=0), dann keine Bildschirmausgabe 
%                       (default immer bildschirm_ausgabe gesetzt)
% return_flag           Wenn gesetzt wird Zeilenvorschub eingefügt (default: 0)

okay            = 1;
fid             = 0;
bildschirm_flag = 1;
if( nargin >= 2 && strcmp(class(debug_fid),'double') )
    
    fid = debug_fid;
end

if( nargin >= 3 && strcmp(class(bildschirm_ausgabe),'double') )
    if( ~bildschirm_ausgabe )
        bildschirm_flag = 0;
    end
end
if( ~exist('return_flag','var') )
    return_flag = 0;
end

if( isstruct(ausgabe) || iscell(ausgabe) )
    ausgabe
else

    if( strcmp(class(ausgabe),'double') )
        ausgabe = sprintf('%g',ausgabe);
    end
    
    len = length(ausgabe);
    % Bildschirm
    if( bildschirm_flag )
        
        [c_ausgabe,clen] = str_split(ausgabe,'\n');
        for i=1:clen
            fprintf('%s',c_ausgabe{i});
            if( i < clen  )
                fprintf('\n');
            end
        end
        if( return_flag )
            fprintf('\n');
        end
        
%         i = 0;
%         while i<len
%             i = i + 1;
%             if( ausgabe(i) == '\' & i<len & ausgabe(i+1) == 'n' )
%                 fprintf('\n');
%                 i = i + 1;
%             else
%                 fprintf('%s',ausgabe(i));
%             end            
%         end
    end
    %Protokoll
    if( fid > 0 )
        i = 0;
        while i<len
            i = i + 1;
            if( i == 1 )
                fprintf(fid,'%%');
            end
            if( double(ausgabe(i)) == 10 )
                fprintf(fid,ausgabe(i));
                if( i < len )
                    fprintf(fid,'%%');
                end
            elseif( ausgabe(i) == '\' & i<len & ausgabe(i+1) == 'n' )
                fprintf(fid,'\n');
                i = i + 1;
                if( i < len )
                    fprintf(fid,'%%');
                end
            else
                fprintf(fid,'%s',ausgabe(i));
                if( i == len )
                    fprintf(fid,'\n');
                end                    
            end            
        end
        if( return_flag)
            fprintf(fid,'\n');
        end
    end
end