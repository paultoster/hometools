function cc = cell_str_cut_ae_f(cc,del_str)
%
% function cc = cell_str_cut_ae_f(cc,del_str)
%
% Schneide del_str aus cc{i} am Anfang und am Ende aus
%
% z.B.  ctxt = str_cut_ae_f({'|abc|','|def|'},'|')
% => ctxt = {'abc','def'}

if( iscell(cc) )
    
    for i=1:length(cc)
        
        str = cc{i};
        if( ischar(str) )
            
            str = str_cut_a_f(str,del_str);
            str = str_cut_e_f(str,del_str);
            cc{i} =  str;
        end
    end
end
