function [rv,av, kv, pv] = jahres_versicherung_ein_anteil(brutto_jahr)

  % Begrenzt auf 12*7550=90600 €
  rv = min(brutto_jahr,90600)*0.186/2;
  av = min(brutto_jahr,90600)*0.026/2;

  % Begrenzt 12*5175=62100
  kv = min(brutto_jahr,62100)*0.146/2;
  pv = min(brutto_jahr,62100)*0.034/2;

end


