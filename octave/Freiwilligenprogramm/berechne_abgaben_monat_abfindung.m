function s = berechne_abgaben_monat_abfindung(s,brutto_monat,imonat_start_rente,erster_monat_abfindung,turbo_factor)

  s.type = 'abfindung';

  imonat_start_abfndung = s.imonat+1;

  [s.grund_abfindung,s.turbo_abfindung,s.abkauf_abfindung] = berechne_abfindung(brutto_monat,imonat_start_rente,erster_monat_abfindung,turbo_factor);

  s.brutto_grund     = brutto_monat;
  s.brutto_abfindung = s.grund_abfindung + s.turbo_abfindung + s.abkauf_abfindung;
  s.brutto           = s.brutto_grund + s.brutto_abfindung;

  [s.lsteuer,s.ksteuer, s.ssteuer] = monats_lohnsteuer(s.brutto);
  [lsteuer_g,ksteuer_g, ssteuer_g] = monats_lohnsteuer(s.brutto_grund);
  lsteuer_a = s.lsteuer - lsteuer_g;
  ksteuer_a = s.ksteuer - ksteuer_g;
  ssteuer_a = s.ssteuer - ssteuer_g;

  [s.rv_an,s.sv_an, s.kv_an, s.pv_an] = monats_versicherung_ein_anteil(s.brutto);

  s.rv_ag = s.rv_an;
  s.sv_ag = s.sv_an;
  s.kv_ag = s.kv_an;
  s.pv_ag = s.pv_an;

  s.netto            = s.brutto - s.lsteuer - s.ksteuer - s.ssteuer - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_grund      = s.brutto_grund - lsteuer_g - ksteuer_g - ssteuer_g - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_abfindung  = s.netto - s.netto_grund;

  s.abgabe           = s.brutto - s.netto;
  s.abgabe_grund     = s.brutto_grund - s.netto_grund;
  s.abgabe_abfindung = s.abgabe - s.abgabe_grund;

end
function [grund_abfindung,turbo_abfindung,abkauf_abfindung] = berechne_abfindung(brutto_monat,imonat_start_rente,erster_monat_abfindung,turbo_factor)

  grund_abfindung  = ((imonat_start_rente-1)-erster_monat_abfindung+1)*brutto_monat*0.98;
  turbo_abfindung  = turbo_factor*brutto_monat;

  abkauf_faktor = 0.;
  if( erster_monat_abfindung <= 12 )
    abkauf_faktor = abkauf_faktor + 1.5;
  end
  if( erster_monat_abfindung <= 11 )
    abkauf_faktor = abkauf_faktor + 1.25;
  end
  if( erster_monat_abfindung <= 10 )
    abkauf_faktor = abkauf_faktor + 1.0;
  end
  if( erster_monat_abfindung <= 9 )
    abkauf_faktor = abkauf_faktor + 0.75;
  end
  if( erster_monat_abfindung <= 8 )
    abkauf_faktor = abkauf_faktor + 0.5;
  end
  if( erster_monat_abfindung <= 7 )
    abkauf_faktor = abkauf_faktor + 0.5;
  end
  if( erster_monat_abfindung <= 6 )
    abkauf_faktor = abkauf_faktor + 0.5;
  end
  abkauf_abfindung = abkauf_faktor * brutto_monat;

end

