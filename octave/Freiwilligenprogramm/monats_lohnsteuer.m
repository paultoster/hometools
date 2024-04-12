function [lohnsteuer,kirchensteuer, soli] = monats_lohnsteuer(monats_brutto)

  brutto_jahr = monats_brutto *12;
  [ls,ks, sl] = jahres_steuer(brutto_jahr);

  lohnsteuer = ls/12;
  kirchensteuer = ks/12;
  soli = sl/12;
end
