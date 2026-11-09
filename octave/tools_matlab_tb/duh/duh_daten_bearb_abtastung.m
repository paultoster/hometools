% $JustDate:: 16.08.05  $, $Revision:: 1 $ $Author:: Tftbe1    $
function  s_duh = duh_daten_bearb_abtastung(data_selection,s_duh)

s_frage.frage     = 'Jeder wievielte Wert soll abgetastet werden';
s_frage.prot      = 1;
s_frage.command   = 'sample';
s_frage.type      = 'double';

[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

sample = floor(value);

if( okay )

    for i=1:length(data_selection)

        % data index
        i_data = data_selection(i);

        c_names = fieldnames(s_duh.s_data(i_data).d);

        for j=1:length(c_names)

            l1 = length(s_duh.s_data(i_data).d.(c_names{j}));
            s_duh.s_data(i_data).d.(c_names{j}) = s_duh.s_data(i_data).d.(c_names{j})(1:sample:l1);

        end    
    end
end