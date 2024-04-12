function [okay,out] = sim_output_par_res(out,par,cpar,res,cres)

%==================
% Ausgabe festlegen
%==================
if( out.flag_doc_word | out.flag_doc_ascii )
        
    [okay,s_a] = ausgabe_aw('init' ...
                           ,'name',    par.run_name ...
                           ,'path',    par.res_path ...
                           ,'ascii',   out.flag_doc_ascii ...
                           ,'word',    out.flag_doc_word ...
                           ,'ncol1',   55 ...
                           ,'ncol2',   10 ...
                           ,'ncol3',   10 ...
                           ,'visible', out.flag_out_vis_word ...
                           );
    s_a.flag = 1;
else
    s_a.flag = 0;
end
%==================
% Name
%==================
if( s_a.flag )
    tdum = sprintf('rune_name = %s',par.run_name);
    [okay,s_a] = ausgabe_aw('title',    s_a ...
                           ,'text',    tdum...
                           ,'pos','left' ...
                           );                       
end

%==================
% Parameterausgabe
%==================
if( out.flag_par_out & s_a.flag) 
    
    %
    % Header
    %
    tdum = sprintf('Ausgabe Parameter par_name = %s',par.par_name);
    [okay,s_a] = ausgabe_aw('head',s_a ...
                           ,'text',tdum ...
                           ,'newpage',0 ...
                           ,'char','=' ...
                           );                       
    [okay,out] = hybrid_out_form(par,cpar,s_a,out);
    
end

%=================================
% tabellarische Ausgabe Ergebnisse
%=================================
if( out.flag_res_tab & s_a.flag ) 
    
    %
    % Header
    %
    tdum = sprintf('Ausgabe Ergebnisse ');
    [okay,s_a] = ausgabe_aw('head',s_a ...
                           ,'text',tdum ...
                           ,'newpage',0 ...
                           ,'char','=' ...
                           );                       
    [okay,out] = hybrid_out_form(res,cres,s_a,out);
    
end

%==================
% Ausgabe beenden
%==================
if( s_a.flag )
    
    if( out.flag_out_vis_word )
        
        [okay,s_a] = ausgabe_aw('save',s_a);
    else
        [okay,s_a] = ausgabe_aw('close',s_a);
    end
end

%=======================
% Ascii ausgabe anzeigen
%=======================
if( out.flag_out_vis_ascii & out.flag_doc_ascii )
    command = ['edit ''',s_a.ascii_file,''';'];
    eval(command)
end
