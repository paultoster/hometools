addpath('./tools_matlab_tb');

csv_delimter    = ';';
csv_filename    = 'einkommen.csv';

erster_monat    = num_monat('01.01.2024');
letzter_monat   = num_monat('01.07.2025');

brutto_monat    = 8100;

erster_monat_frei = num_monat('01.08.2025');


s = bilde_struct_mit_monat_jahr(erster_monat,letzter_monat);
n = length(s);
for i=1:n

  fprintf('%s %s \n',s(i).monat,s(i).jahr);

  if( s(i).imonat < erster_monat_frei )
    s(i) = berechne_abgaben_monat_arbeit(s(i),brutto_monat);
  else
    s(i) = berechne_abgaben_monat_arbeit(s(i),brutto_monat);
  end

  fprintf('brutto: %15.2f € netto: %15.2f € \n',s(i).brutto,s(i).netto);

end

c_txt = {};

t = ['datum',csv_delimter];
for i=1:n
  t = [t,s(i).monat,' ',s(i).jahr];
  if( i < n )
    t = [t,csv_delimter];
  end
end
c_txt = cell_add(c_txt,t);
%--------------------------
t = ['brutto',csv_delimter];
for i=1:n
  t = [t,str_change_f(num2str(s(i).brutto,'%10.2f'),'.',',')];
  if( i < n )
    t = [t,csv_delimter];
  end
end
c_txt = cell_add(c_txt,t);
%--------------------------
t = ['netto',csv_delimter];
for i=1:n
  t = [t,str_change_f(num2str(s(i).netto,'%10.2f'),'.',',')];
  if( i < n )
    t = [t,csv_delimter];
  end
end
c_txt = cell_add(c_txt,t);


okay = write_ascii_file( csv_filename, c_txt );


