function nmonat = num_monat(dattext)


  [c_names,icount] = str_split(dattext,'.');

  imonat = str2num(c_names{2});
  ijahr  = str2num(c_names{3});
  if( ijahr == 2024 )

    nmonat = imonat;

  elseif( ijahr == 2025 )

    nmonat = imonat + 12;

  else

    error('jahr von %s ist nicht 2024 oder 2025',dattext);

  end
end

