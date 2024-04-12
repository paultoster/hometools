function [rv,av, kv, pv] = monats_versicherung_ein_anteil(brutto_monat)

  brutto_jahr = brutto_monat *12;

  [rvj,avj, kvj, pvj] = jahres_versicherung_ein_anteil(brutto_jahr);

  rv = rvj/12;
  av = avj/12;
  kv = kvj/12;
  pv = pvj/12;
end


