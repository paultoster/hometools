function s = berechne_abgaben_monat_arbeit(s,brutto_monat)

  s.type = 'arbeit';

  s.brutto_grund     = brutto_monat;
  s.brutto_abfindung = 0.;
  s.brutto = s.brutto_grund + s.brutto_abfindung;

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

  s.netto           = s.brutto - s.lsteuer - s.ksteuer - s.ssteuer - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_grund     = s.brutto_grund - lsteuer_g - ksteuer_g - ssteuer_g - s.rv_an - s.sv_an - s.kv_an - s.pv_an;
  s.netto_abfindung = s.netto - s.netto_grund ;

  s.abgabe           = s.brutto - s.netto;
  s.abgabe_grund     = s.brutto_grund - s.netto_grund;
  s.abgabe_abfindung = s.abgabe - s.abgabe_grund;
end

