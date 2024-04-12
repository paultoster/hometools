function s = berechne_abgaben_monat_arbeit(s,brutto_monat)

  s.type = 'arbeit';
  s.brutto = brutto_monat;
  [s.lsteuer,s.ksteuer, s.ssteuer] = monats_lohnsteuer(brutto_monat);

  [s.rv,s.sv, s.kv, s.pv] = monats_versicherung_ein_anteil(brutto_monat);


  s.netto = s.brutto - s.lsteuer - s.ssteuer - s.rv - s.sv - s.kv - s.pv;
end

