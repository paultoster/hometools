function [okay,out] = commented_struct_par_res_out(out,par,cpar,res,cres)

okay = 1;

%==================
% Ausgabe festlegen
%==================
if( out.flag_doc_word || out.flag_doc_ascii )
    
    if( ~exist(par(1).res_path,'file') )
        mkdir(par(1).res_path)
    end
        
    [okay,s_a] = ausgabe_aw('init' ...
                           ,'name',    par(1).run_name ...
                           ,'path',    par(1).res_path ...
                           ,'ascii',   out.flag_doc_ascii ...
                           ,'word',    out.flag_doc_word ...
                           ,'ncol1',   50 ...
                           ,'ncol2',   10 ...
                           ,'ncol3',   15 ...
                           ,'visible', out.flag_out_vis_word ...
                           );
    s_a.aw_flag = 1;
else
    s_a.aw_flag = 0;
end

if( out.flag_doc_excel )
            
    [okay,s_e] = ausgabe_excel('init' ...
                              ,'name',    'vergleich_ebc' ...
                              ,'visible', out.flag_out_vis_excel ...
                              );
    s_a.excel_flag = 1;
else
    s_a.excel_flag = 0;
end

%==================
% Name
%==================
if( s_a.aw_flag )
    tdum = sprintf('rune_name = %s',par(1).run_name);
    [okay,s_a] = ausgabe_aw('title',    s_a ...
                           ,'text',    tdum...
                           ,'pos','left' ...
                           );                       
end
%==================
% Parameterausgabe
%==================
if( out.flag_par_out & s_a.aw_flag ) 
    
    %
    % Header
    %
    if( isfield(par(1),'par_file') )
        tdum = sprintf('Ausgabe Parameter par_name = %s',par(1).par_file);
    else
        tdum = 'Ausgabe Parameter ';
    end   
    [okay,s_a] = ausgabe_aw('head',s_a ...
                           ,'text',tdum ...
                           ,'newpage',0 ...
                           ,'char','=' ...
                           );                       
    okay = commented_struct_out_form(par(1),cpar(1),s_a,out.flag_par_plot);
    
end

%=================================
% tabellarische Ausgabe Ergebnisse
%=================================
if( out.flag_res_tab & s_a.aw_flag ) 
    
    %
    % Header
    %
    tdum = sprintf('Ausgabe Ergebnisse ');
    [okay,s_a] = ausgabe_aw('head',s_a ...
                           ,'text',tdum ...
                           ,'newpage',0 ...
                           ,'char','=' ...
                           );                       
    okay = commented_struct_out_form(res(1),cres(1),s_a,out.flag_res_plot);
    
end
%=================================
% tabellarische Ausgabe Ergebnisse
%=================================
if( out.flag_res_plot & s_a.aw_flag & out.flag_doc_word ) 

    [okay,out] = ebc_plot_res(res(1),par(1),out,s_a);
    
end
%========================================
% vergleichende Ausgabe Ergebnisse Excel
%========================================
if( out.flag_doc_excel ) 
    
    % Header
    s_e.izeile = 0;
    for i=1:length(par)
        
        s_e.izeile = s_e.izeile+1;
        texta = sprintf('%i. Spalte: %s',i,par(i).run_name);  
        [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',s_e.izeile,'val',texta);
    end
    if( out.flag_par_out )
        [okay,s_e] = commented_struct_out_excel(par,cpar,s_e,s_e.izeile);
    end
    if( out.flag_res_tab )
        [okay,s_e] = commented_struct_out_excel(res,cres,s_e,s_e.izeile);
    end
end
%==================
% Ausgabe beenden
%==================
if( s_a.aw_flag )
    
    if( out.flag_out_vis_word )
        
        [okay,s_a] = ausgabe_aw('save',s_a);
    else
        [okay,s_a] = ausgabe_aw('close',s_a);
    end
    
end
if( s_a.excel_flag )
    
    % Datei speichern
    if( out.flag_out_vis_excel )
        
        [okay,s_e] = ausgabe_excel('save',s_e);
    else
        [okay,s_e] = ausgabe_excel('close',s_e);
    end
end

%=======================
% Ascii ausgabe anzeigen
%=======================
if( out.flag_out_vis_ascii & out.flag_doc_ascii )
    command = ['edit ''',s_a.ascii_file,''';'];
    eval(command)
end
