% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
if exist('duh.prot','file') 
    fid = fopen('duh.prot','r');
    fid2 = fopen('duh.m','w');
    
    fprintf(fid2,'s_duh_ectrl.new = 1;\n');
    fprintf(fid2,'s_duh_ectrl.old = 0;\n');
    fprintf(fid2,'\nip = 0;\n');
    while 1
        tline = fgetl(fid);
        % Breche ab wenn Ende erreicht
        if ~ischar(tline)
            break
        end

        if( length(tline) > 0 & tline(1) ~= '%' )
            fprintf(fid2,'ip = ip+1;s_duh_ectrl.remote{ip} = ''%s'';\n',tline);
        end
    end
    
    fprintf(fid2,'\n\nduh_main');
    fclose(fid);
    fclose(fid2);
    edit duh
end
