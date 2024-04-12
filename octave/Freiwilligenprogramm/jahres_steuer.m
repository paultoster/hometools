function [lohnsteuer,kirchensteuer, soli] = jahres_steuer(brutto_jahr)


  %
  % von https://www.bmf-steuerrechner.de/ekst/eingabeformekst.xhtml?ekst-result=true
  %

  if( brutto_jahr < 11604 )
    lohnsteuer = 0.0;
  elseif( brutto_jahr < 17005 )
    y = (brutto_jahr - 11604) / 10000;
    lohnsteuer =  (922.98 * y + 1400) * y;
  elseif( brutto_jahr < 66760 )
    y = (brutto_jahr - 17005) / 10000;
    lohnsteuer =  (181.19 * z + 2397) * z + 1025.38;
  elseif( brutto_jahr < 277825 )
    lohnsteuer = 0.42 * brutto_jahr - 10602.13;
  else
    lohnsteuer = 0.45 * brutto_jahr - 18936.88;
  end

  % Korrektur aus meiner Abbrechnung
  lohnsteuer = lohnsteuer * 0.7652;

  kirchensteuer = lohnsteuer * 0.09 * 0.89; % Korrektur aus meiner Abbrechnung
  soli = lohnsteuer * 0.025185 * 0.83;
end


