function s_duh = duh_daten_bearb_peak_filter2(selection,s_duh)

s_frage.c_comment{1} = 'Peakfilter2: aus diff(data) wird die Standardabweichung (std) bestimmt';
s_frage.c_comment{2} = '            Stellen mit 2 Peaks werden erkannt, wenn die differenz > faktor*std ist';
s_frage.c_comment{3} = sprintf(' alter Peakfilterfaktor: %g',s_duh.s_einstell.peak_filt_std_fac);
s_frage.frage        = 'Faktor für Peakfilter';
s_frage.default      = s_duh.s_einstell.peak_filt_std_fac;
s_frage.command      = 'peak_filt_fac';
s_frage.type         = 'double';
s_frage.min          = 0;

[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( okay )
    s_duh.s_einstell.peak_filt_std_fac = value;
end

for i=1:length(selection)
    i1 = selection(i);
    [s_duh.s_data(i1).d,c_comment] = peak_filter2_f(s_duh.s_data(i1).d,s_duh.s_einstell.peak_filt_std_fac,0);

    for k=1:length(c_comment)
        a = sprintf('\n%s',c_comment{k});
        o_ausgabe_f(a,0);
    end
end
