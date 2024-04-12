function s_h = print_html(s_h,type,par1,par2,par3,par4,par5,par6,par7)
    
if( strcmp(
set_html_standards
okay = 1;
if( fid < 0 )
    okay = 0;
    fprintf('\nprint_html_error: fid < 0);
    return
end
switch( type )
    case s_html.START

        if( ~strcmp(class(par1),'char') )
            okay = 0;
            fprintf('\nprint_html_error: START par1 kein char);
            return
        end
        fprintf(fid,'\n<html>\n<head>\n<title>')
        fprintf(fid,char(par1))
        fprintf(fid,'</title>\n</head>')
        okay = 1;
    case s_html.END

        fprintf(fid,'\n</html>\n')

    otherwise
        
        okay = 0;
        fprintf('\nprint_html_error: wrong type);
end