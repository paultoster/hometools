function s = berechne_abgaben_monat_frei(s)

  s.type = 'frei';

  s.brutto_grund     = 0.;
  s.brutto_abfindung = 0.;
  s.brutto = s.brutto_grund + s.brutto_abfindung;

  [s.lsteuer,s.ksteuer, s.ssteuer] = monats_lohnsteuer(s.brutto);
  [lsteuer_g,ksteuer_g, ssteuer_g] = monats_lohnsteuer(s.brutto_grund);

  lsteuer_a = s.lsteuer - lsteuer_g;
  ksteuer_a = s.ksteuer - ksteuer_g;
  ssteuer_a = s.ssteuer - ssteuer_g;

  [s.rv_an,s.sv_an, s.kv_an, s.pv_an] = monats_versicherung_ein_anteil(s.brutto);

  s.rv_an = s.rv_an*2;
  s.sv_an = s.sv_an*2;
  s.kv_an = s.kv_an*2;
  s.pv_an = s.pv_an*2;

  s.rv_ag = 0.;
  s.sv_ag = 0.;
  s.kv_ag = 0.;
  s.pv_ag = 0.;

  s.netto           = s.brutto - s.lsteuer - s.ksteuer - s.ssteuer - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_grund     = s.brutto_grund - lsteuer_g - ksteuer_g - ssteuer_g - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_abfindung = s.netto - s.netto_grund ;

  s.abgabe           = s.brutto - s.netto;
  s.abgabe_grund     = s.brutto_grund - s.netto_grund;
  s.abgabe_abfindung = s.abgabe - s.abgabe_grund;
end

