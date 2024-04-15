function c_txt = build_csv_output(s,n,csv_delimter)

  c_txt = {};

  t = ['datum',csv_delimter];
  for i=1:n

    t = [t,s(i).monat,' ',s(i).jahr];
    if( mod(i,12) == 0 )
       t = [t,csv_delimter,'jahr',csv_delimter,'diff'];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['brutto',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).brutto)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_brutto;
       val2 = s(i).j_brutto-s(i).sum.brutto;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['brutto_grund',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).brutto_grund)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_brutto_grund;
       val2 = s(i).j_brutto_grund-s(i).sum.brutto_grund;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['brutto_abfindung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).brutto_abfindung)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_brutto_abfindung;
       val2 = s(i).j_brutto_abfindung-s(i).sum.brutto_abfindung;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['abfindung_grund',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).grund_abfindung)];
    if( mod(i,12) == 0 )
       t = [t,csv_delimter,' ',csv_delimter,' '];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['abfindung_turbo',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).turbo_abfindung)];
    if( mod(i,12) == 0 )
       t = [t,csv_delimter,' ',csv_delimter,' '];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['abfindung_abkauf',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).abkauf_abfindung)];
    if( mod(i,12) == 0 )
       t = [t,csv_delimter,' ',csv_delimter,' '];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['netto',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).netto)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_netto;
       val2 = s(i).j_netto-s(i).sum.netto;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['netto_grund',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).netto_grund)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_netto_grund;
       val2 = s(i).j_netto_grund-s(i).sum.netto_grund;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['netto_abfindung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).netto_abfindung)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_netto_abfindung;
       val2 = s(i).j_netto_abfindung-s(i).sum.netto_abfindung;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['lohnsteuer',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).lsteuer)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_lsteuer;
       val2 = s(i).j_lsteuer-s(i).sum.lsteuer;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['kirchensteur',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).ksteuer)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_ksteuer;
       val2 = s(i).j_ksteuer-s(i).sum.ksteuer;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['soli',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).ssteuer)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_ssteuer;
       val2 = s(i).j_ssteuer-s(i).sum.ssteuer;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['rentenversicherung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).rv_an)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_rv_an;
       val2 = s(i).j_rv_an-s(i).sum.rv_an;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['sozialversicherung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).sv_an)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_sv_an;
       val2 = s(i).j_sv_an-s(i).sum.sv_an;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['krankenversicherung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).kv_an)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_kv_an;
       val2 = s(i).j_kv_an - s(i).sum.kv_an;
       t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['pflegeversicherung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).pv_an)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_pv_an;
       val2 = s(i).j_pv_an - s(i).sum.pv_an;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['Abgaben',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).abgabe)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_abgabe;
       val2 = s(i).j_abgabe-s(i).sum.abgabe;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['Abgaben_grund',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).abgabe_grund)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_abgabe_grund;
       val2 = s(i).j_abgabe_grund-s(i).sum.abgabe_grund;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);
  %--------------------------
  t = ['Abgaben_abfindung',csv_delimter];
  for i=1:n
    t = [t,change_format(s(i).abgabe_abfindung)];
    if( mod(i,12) == 0 )
       val1 = s(i).j_abgabe_abfindung;
       val2 = s(i).j_abgabe_abfindung-s(i).sum.abgabe_abfindung;
              t = [t,csv_delimter,change_format(val1),csv_delimter,change_format(val2)];
    end
    if( i < n )
      t = [t,csv_delimter];
    end
  end
  c_txt = cell_add(c_txt,t);



end
function txtv = change_format(val)
  txtv = str_change_f(num2str(val,'%15.2f'),'.',',');
end

