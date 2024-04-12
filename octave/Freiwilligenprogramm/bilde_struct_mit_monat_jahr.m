function s = bilde_struct_mit_monat_jahr(erster_monat,letzter_monat)

  n = letzter_monat-erster_monat+1;

  for i=1:n

    imonat = i-1+erster_monat;

    [s(i).jahr s(i).monat] = get_jahr_monat_name(imonat);
    s(i).imonat = imonat;
    s(i).type   = '';

    s(i).brutto = 0;
    s(i).lsteuer = 0;
    s(i).ksteuer = 0;
    s(i).ssteuer = 0;
    s(i).rv = 0;
    s(i).sv = 0;
    s(i).kv = 0;
    s(i).pv = 0;
    s(i).netto = 0;

  end

end

