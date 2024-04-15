addpath('K:/tools/hometools/octave/Freiwilligenprogramm/tools_matlab_tb');

csv_delimter    = ';';
csv_filename_a    = 'aufstellung.csv';
csv_filename_u    = 'uebersicht.csv';

erster_monat     = num_monat('01.01.2024');
letzter_monat    = num_monat('01.4.2025');
erster_monat_frei    = num_monat('1.6.2024');
erster_monat_rente   = num_monat('01.8.2025');

brutto_monat    = 8100;
turbo_factor    = 3;




s = bilde_struct_mit_monat_jahr(erster_monat,letzter_monat);
n = length(s);
for i=1:n

  fprintf('%s %s \n',s(i).monat,s(i).jahr);

  if( s(i).imonat < (erster_monat_frei-1) )

    s(i) = berechne_abgaben_monat_arbeit(s(i),brutto_monat);


  elseif(s(i).imonat == (erster_monat_frei-1))

    s(i) = berechne_abgaben_monat_abfindung(s(i),brutto_monat,erster_monat_rente,erster_monat_frei,turbo_factor);

  elseif(s(i).imonat < erster_monat_rente)

    s(i) = berechne_abgaben_monat_frei(s(i));

  else
    s(i) = berechne_abgaben_monat_arbeit(s(i),brutto_monat);
  end

  % berechne jahres summe und sbrechnung
  s    = berechne_abgaben_jahr(s,i);

  fprintf('brutto: %15.2f € netto: %15.2f € \n',s(i).brutto,s(i).netto);

end

c_csv = build_csv_output(s,n,csv_delimter);
okay = write_ascii_file( csv_filename_a, c_csv );

c_ueber = build_csv_uebersicht(s,n,csv_delimter,brutto_monat,erster_monat_frei,erster_monat_rente-1);
okay = write_ascii_file( csv_filename_a, c_ueber );



