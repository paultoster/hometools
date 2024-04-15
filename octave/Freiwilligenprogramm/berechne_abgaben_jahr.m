function s    = berechne_abgaben_jahr(s,imonat)


  if( mod(imonat,12) == 1 )

    name = 'brutto';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'brutto_grund';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'brutto_abfindung';
    s(imonat).sum.(name) = s(imonat).(name);

    name = 'lsteuer';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'ksteuer';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'ssteuer';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'rv_an';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'sv_an';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'kv_an';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'pv_an';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'netto';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'netto_grund';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'netto_abfindung';
    s(imonat).sum.(name) = s(imonat).(name);

    name = 'abgabe';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'abgabe_grund';
    s(imonat).sum.(name) = s(imonat).(name);
    name = 'abgabe_abfindung';
    s(imonat).sum.(name) = s(imonat).(name);

  else

    name = 'brutto';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'brutto_grund';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'brutto_abfindung';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);

    name = 'lsteuer';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'ksteuer';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'ssteuer';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'rv_an';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'sv_an';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'kv_an';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'pv_an';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'netto';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'netto_grund';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'netto_abfindung';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);

    name = 'abgabe';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'abgabe_grund';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);
    name = 'abgabe_abfindung';
    s(imonat).sum.(name) = s(imonat-1).sum.(name) + s(imonat).(name);

  end

  if( mod(imonat,12) == 0 )

    s = berechne_abgaben_jahr_gesamt(s,imonat);

  end


end
function s = berechne_abgaben_jahr_gesamt(s,imonat)


  s(imonat).j_brutto = s(imonat).sum.brutto;
  s(imonat).j_brutto_grund = s(imonat).sum.brutto_grund;
  s(imonat).j_brutto_abfindung = s(imonat).sum.brutto_abfindung;

  [s(imonat).j_lsteuer,s(imonat).j_ksteuer, s(imonat).j_ssteuer] = jahres_steuer(s(imonat).j_brutto);
  [lsteuer_g,ksteuer_g, ssteuer_g] = jahres_steuer(s(imonat).j_brutto_grund);

  s(imonat).j_rv_an = s(imonat).sum.rv_an;
  s(imonat).j_sv_an = s(imonat).sum.sv_an;
  s(imonat).j_kv_an = s(imonat).sum.kv_an;
  s(imonat).j_pv_an = s(imonat).sum.pv_an;

  s(imonat).j_rv_ag = s(imonat).sum.rv_ag;
  s(imonat).j_sv_ag = s(imonat).sum.sv_ag;
  s(imonat).j_kv_ag = s(imonat).sum.kv_ag;
  s(imonat).j_pv_ag = s(imonat).sum.pv_ag;



  s(imonat).j_netto           = s(imonat).j_brutto - s(imonat).j_lsteuer - s(imonat).j_ksteuer - s(imonat).j_ssteuer - s(imonat).j_rv_an - s(imonat).j_sv_an - s(imonat).j_kv_an - s(imonat).j_pv_an;
  s(imonat).j_netto_grund     = s(imonat).j_brutto_grund - lsteuer_g - ksteuer_g - ssteuer_g  - s(imonat).j_rv_an - s(imonat).j_sv_an - s(imonat).j_kv_an - s(imonat).j_pv_an;
  s(imonat).j_netto_abfindung = s(imonat).j_netto - s(imonat).j_netto_grund;


  s(imonat).j_abgabe           = s(imonat).j_brutto - s(imonat).j_netto;
  s(imonat).j_abgabe_grund     = s(imonat).j_brutto_grund - s(imonat).j_netto_grund ;
  s(imonat).j_abgabe_abfindung = s(imonat).j_abgabe - s(imonat).j_abgabe_grund;



end


