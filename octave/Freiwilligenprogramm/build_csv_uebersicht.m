function c_txt = build_csv_uebersicht(s,n,csv_delimter,brutto_monat,erster_monat_frei,letzter_monat_frei)

  c_txt = {};


  %------------------------------------------------
  t = ['datum start',csv_delimter];
  t = [t,s(erster_monat_frei).monat,' ',s(erster_monat_frei).jahr];
  c_txt = cell_add(c_txt,t);
  %------------------------------------------------
  t = [sprintf('Abfindung Basis (%i Monate)',(letzter_monat_frei-erster_monat_frei+1)),csv_delimter];
  t = [t,change_format(s(erster_monat_frei-1).grund_abfindung)];
  c_txt = cell_add(c_txt,t);
  %------------------------------------------------
  t = [sprintf('Abfindung Abkauf (%4.2f Monate)',s(erster_monat_frei-1).abkauf_abfindung/brutto_monat),csv_delimter];
  t = [t,change_format(s(erster_monat_frei-1).abkauf_abfindung)];
  c_txt = cell_add(c_txt,t);
  %------------------------------------------------
  t = [sprintf('Abfindung Turbo (%4.2f Monate)',s(erster_monat_frei-1).turbo_abfindung/brutto_monat),csv_delimter];
  t = [t,change_format(s(erster_monat_frei-1).turbo_abfindung)];
  c_txt = cell_add(c_txt,t);
  %------------------------------------------------
  t = [sprintf('Abfindung gesamt '),csv_delimter];
  t = [t,change_format(s(erster_monat_frei-1).brutto_abfindung)];
  c_txt = cell_add(c_txt,t);

end
function txtv = change_format(val)
  txtv = str_change_f(num2str(val,'%15.2f'),'.',',');
end

