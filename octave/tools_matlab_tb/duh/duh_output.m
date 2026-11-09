function s_out=duh_output(s_out,bildschirm_flag,output)
%
% s_out=duh_output(s_out,output)
%
% s_out.file        Ausgabedatei
% s_out.fid         handle für Ausgabe > 0
%
% bildschirm_flag   =1 wenn an Bildschirm ausgegeben
%                   =0 wird nicht an Bildschirm ausgegeben
%
% output            auszugebende Variable char cel oder double
%
if( ~isfield(s_out,'file') )
    s_out.file = 'result.dat';
end
if( ~isfield(s_out,'fid') )
    s_out.fid = 0;
end

if( s_out.fid == 0 )
    
    [s_out.fid,message] = fopen(s_out.file,'w');
    
    if( s_out.fid == 0 )
        error(message)
    end
end

% Wert wandeln/überprüfen

if( ischar(output) )
    
    [c_ausgabe,clen] = str_split(output,'\n');
elseif( iscell(output) )
    c_ausgabe = {};
    i2        = 0;
    for i1 = 1:length(output)
        if( ischar( output{i1} ) )
            i2 = i2 + 1;
            c_ausgabe{i2} = output{i1};
        end
    end
elseif( isnumeric(output) )
    c_ausgabe = {};
    for i=1:length(output)
        c_ausgabe{i} = num2str(output(i));
    end
else
    c_ausgabe = {}
end

% Ausgabe:

for i=1:length(c_ausgabe)
    fprintf(s_out.fid,'%s',c_ausgabe{i});
    if( bildschirm_flag )
        fprintf('%s',c_ausgabe{i});
    end
    if( i < clen  )
        fprintf(s_out.fid,'\n');
        if( bildschirm_flag )
            fprintf('%s','\n');
        end
    end
end



