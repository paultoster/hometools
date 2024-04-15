function s = bilde_struct_mit_monat_jahr(erster_monat,letzter_monat)

  n = letzter_monat-erster_monat+1;

  for i=1:n

    imonat = i-1+erster_monat;

    [s(i).jahr s(i).monat] = get_jahr_monat_name(imonat);
    s(i).imonat = imonat;
    s(i).type   = '';

    s(i).brutto = 0;
    s(i).brutto_abfindung = 0;
    s(i).brutto_grund     = 0;
    s(i).lsteuer = 0;
    s(i).ksteuer = 0;
    s(i).ssteuer = 0;
    s(i).rv_an = 0;
    s(i).sv_an = 0;
    s(i).kv_an = 0;
    s(i).pv_an = 0;
    s(i).rv_ag = 0;
    s(i).sv_ag = 0;
    s(i).kv_ag = 0;
    s(i).pv_ag = 0;
    s(i).netto = 0;
    s(i).netto_grund = 0;
    s(i).netto_abfindung = 0;
    s(i).abgabe = 0.;
    s(i).abgabe_abfindung = 0.;
    s(i).abgabe_grund      = 0.;
    s(i).grund_abfindung = 0.0;
    s(i).turbo_abfindung = 0.0;
    s(i).abkauf_abfindung = 0.0;

    % jahres summe
    s(i).sum.brutto = 0;
    s(i).sum.lsteuer = 0;
    s(i).sum.ksteuer = 0;
    s(i).sum.ssteuer = 0;
    s(i).sum.rv_an = 0;
    s(i).sum.sv_an = 0;
    s(i).sum.kv_an = 0;
    s(i).sum.pv_an = 0;
    s(i).sum.rv_ag = 0;
    s(i).sum.sv_ag = 0;
    s(i).sum.kv_ag = 0;
    s(i).sum.pv_ag = 0;
    s(i).sum.netto = 0;
    s(i).sum.abgabe = 0.;
    s(i).sum.abgabe_abfindung = 0.;
    s(i).sum.abgabe_grund     = 0.;

    % jahres abrechnung gilt eignetlich nur für monat 12
    s(i).j_brutto = 0;
    s(i).j_lsteuer = 0;
    s(i).j_ksteuer = 0;
    s(i).j_ssteuer = 0;
    s(i).j_rv_an = 0;
    s(i).j_sv_an = 0;
    s(i).j_kv_an = 0;
    s(i).j_pv_an = 0;
    s(i).j_rv_ag = 0;
    s(i).j_sv_ag = 0;
    s(i).j_kv_ag = 0;
    s(i).j_pv_ag = 0;
    s(i).j_netto = 0;
    s(i).j_abgabe = 0.;

    end

end

